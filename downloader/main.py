import os
import json
from fastapi import FastAPI, Request
from sse_starlette.sse import EventSourceResponse
import uvicorn

from core.logger import setup_logging
from providers.ytdlp.service import VideoItem, download

setup_logging()

app = FastAPI()

DEFAULT_SOCKET = "/tmp/hw.sock"


@app.get("/hello")
def root():
    return {"hello": "from download worker"}

@app.post("/ytdlp/download")
def download_yt_dlp(item: VideoItem, request: Request):
    return EventSourceResponse(event_generator(item, request))


async def event_generator(item: VideoItem, request: Request):
    async for progress in download(item):
        # Check if the client disconnected to prevent resource leaks
        if await request.is_disconnected():
            print("Client disconnected.")
            break

        if "error" in progress:
            yield {
                "event": "error",
                "data": json.dumps({"message": progress["error"]})
            }
            break

        # Safely clean and extract only serializable progress metrics
        data = progress.get("data", {})

        print(data)

        cleaned_data = {}
        for key in ['status', 'downloaded_bytes', 'total_bytes', 'total_bytes_estimate', 'filename', 'tmpfilename', 'eta', 'speed', 'elapsed']:
            if key in data:
                cleaned_data[key] = data[key]

        yield {
            "event": "progress",
            "data": json.dumps({"data": cleaned_data})
        }

if __name__ == "__main__":
    uvicorn.run("main:app", uds=DEFAULT_SOCKET, reload=True)
