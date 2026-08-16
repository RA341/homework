import asyncio
from typing import AsyncGenerator

import yt_dlp
from pydantic import BaseModel


class VideoItem(BaseModel):
    url: str
    download_path: str

async def download(video: VideoItem) -> AsyncGenerator[dict, None]:
    queue: asyncio.Queue = asyncio.Queue()
    loop = asyncio.get_running_loop()

    def progress_hook(d):
        if d.get("status") == "finished":
            print("Done downloading, now post-processing ...")
        loop.call_soon_threadsafe(queue.put_nowait, {"data": d.copy()})

    def run():
        try:
            base_opts = {
                "logger": ProgressLogger(),
                "progress_hooks": [progress_hook],
                "paths": {"home": video.download_path},
                "verbose": True,
                "cookiesfrombrowser": ("chromium", "./downloader/browser_data/.config/chromium"),
            }

            with yt_dlp.YoutubeDL(base_opts) as ydl:
                ydl.download([video.url])

        except Exception as e:
            loop.call_soon_threadsafe(queue.put_nowait, {"error": str(e)})
        finally:
            loop.call_soon_threadsafe(queue.put_nowait, None)

    loop.run_in_executor(None, run)

    while True:
        msg = await queue.get()
        if msg is None:
            break
        yield msg

class ProgressLogger:
    def debug(self, msg):
        # For compatibility with youtube-dl, both debug and info are passed into debug
        # You can distinguish them by the prefix '[debug] '
        if msg.startswith('[debug] '):
            pass
        else:
            print(msg)
            self.info(msg)

    def info(self, msg):
        pass

    def warning(self, msg):
        pass

    def error(self, msg):
        print(msg)
