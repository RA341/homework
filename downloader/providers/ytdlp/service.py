import asyncio
from typing import AsyncGenerator
import yt_dlp  # type: ignore
from pydantic import BaseModel



class MyLogger:
    def debug(self, msg):
        # For compatibility with youtube-dl, both debug and info are passed into debug
        # You can distinguish them by the prefix '[debug] '
        if msg.startswith('[debug] '):
            pass
        else:
            self.info(msg)

    def info(self, msg):
        pass

    def warning(self, msg):
        pass

    def error(self, msg):
        print(msg)



class VideoItem(BaseModel):
    url: str
    download_path: str

# ℹ️ See "progress_hooks" in help(yt_dlp.YoutubeDL)
async def download(video: VideoItem) -> AsyncGenerator[dict, None]:
    queue: asyncio.Queue = asyncio.Queue()
    loop = asyncio.get_running_loop()

    def progress_hook(d):
        if d.get('status') == 'finished':
            print('Done downloading, now post-processing ...')
        loop.call_soon_threadsafe(queue.put_nowait, {"data": d.copy()})

    def run():
        try:
            ydl_opts = {
                'logger': MyLogger(),
                'progress_hooks': [progress_hook],
                'paths': {'home': video.download_path},
            }
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
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

