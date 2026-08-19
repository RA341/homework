import asyncio
import hashlib
import os
from pathlib import Path
from typing import Dict, List, Set

import uvicorn
from fastapi import FastAPI, HTTPException, Response, WebSocket
from fastapi.responses import PlainTextResponse
from pydantic import BaseModel

from utils.logger import setup_logging, logger
from providers.ytdlp.service import VideoItem, download


setup_logging()

app = FastAPI()

DOWNLOAD_ENV = "DOWNLOADER_DOWNLOAD_DIR"
downloadEnv = os.getenv(DOWNLOAD_ENV)

downloadFolder = "downloads"
if downloadEnv is not None:
    downloadFolder = downloadEnv
    # print(f"please set env: {DOWNLOAD_ENV}, for the download dir")
    # exit(1)

downloadFolder = os.path.abspath(downloadFolder)
os.makedirs(downloadFolder, exist_ok=True)


class DownloadProgress(BaseModel):
    TimeLeftSecs: int
    DownloadBytesPerSecond: int
    Complete: int
    Left: int
    Error: str


class DownloadState:
    def __init__(self):
        self.progress = DownloadProgress(
            TimeLeftSecs=0, DownloadBytesPerSecond=0, Complete=0, Left=0, Error=""
        )
        self.lines: List[str] = []
        self.listeners: Set[asyncio.Queue] = set()
        self.finished = False


downloads: Dict[str, DownloadState] = {}


async def run_download(download_id: str, item: VideoItem):
    state = downloads[download_id]
    try:
        async for prog in download(item):
            if "error" in prog:
                err_msg = prog["error"]
                state.progress.Error = err_msg
                line = f"ERROR: {err_msg}"
                state.lines.append(line)
                for queue in list(state.listeners):
                    await queue.put(line)
                break

            data = prog.get("data", {})
            status_val = data.get("status", "")
            downloaded_bytes = data.get("downloaded_bytes") or 0
            total_bytes = (
                data.get("total_bytes") or data.get("total_bytes_estimate") or 0
            )
            speed = data.get("speed") or 0
            eta = data.get("eta") or 0

            left_bytes = max(0, total_bytes - downloaded_bytes)

            state.progress.TimeLeftSecs = int(eta)
            state.progress.DownloadBytesPerSecond = int(speed)
            state.progress.Complete = int(downloaded_bytes)
            state.progress.Left = int(left_bytes)

            percent = (downloaded_bytes / total_bytes * 100) if total_bytes > 0 else 0
            line = f"Status: {status_val} | Progress: {percent:.2f}% | Complete: {downloaded_bytes}/{total_bytes} bytes | Speed: {speed / 1024 / 1024:.2f} MB/s | ETA: {eta}s"

            state.lines.append(line)
            for queue in list(state.listeners):
                await queue.put(line)

    except Exception as e:
        err_msg = str(e)
        state.progress.Error = err_msg
        line = f"ERROR: {err_msg}"
        state.lines.append(line)
        for queue in list(state.listeners):
            await queue.put(line)
    finally:
        state.finished = True
        for queue in list(state.listeners):
            await queue.put(None)


@app.get("/hello")
def root():
    return {"hello": "from download worker"}


@app.get("/status", response_model=DownloadProgress)
def status(response: Response, id: str = ""):
    if id not in downloads:
        raise HTTPException(status_code=404, detail="download not found")
    state = downloads[id]
    if state.progress.Error:
        response.status_code = 400
    elif state.finished:
        response.status_code = 200
    else:
        response.status_code = 206
    return state.progress

class VideoDto(BaseModel):
    url: str

@app.post("/download", response_class=PlainTextResponse)
async def download_endpoint(item: VideoDto):
    download_id = hashlib.sha1(item.url.encode("utf-8")).hexdigest()
    downfold = f"{downloadFolder}/{download_id}"

    logger.debug(f"download path: {downfold}")
    
    os.makedirs(downfold, exist_ok=True)
    v = VideoItem(url=item.url, download_path=downfold)

    downloads[download_id] = DownloadState()
    asyncio.create_task(run_download(download_id, v))
    return download_id

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
