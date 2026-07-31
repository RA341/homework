import uvicorn
from fastapi import FastAPI, HTTPException, WebSocket
from pydantic import BaseModel

from core.logger import setup_logging

setup_logging()

app = FastAPI()

DEFAULT_SOCKET = "/tmp/hw.sock"


class DownloadProgress(BaseModel):
    TimeLeftSecs: int
    DownloadBytesPerSecond: int
    Complete: int
    Left: int
    Error: str


@app.get("/hello")
def root():
    return {"hello": "from download worker"}


@app.post("/download")
def download_endpoint():
    raise HTTPException(status_code=500, detail="unimplemented")


@app.get("/status")
def status(id: str = ""):
    raise HTTPException(status_code=500, detail="unimplemented")


@app.websocket("/progress")
async def progress(websocket: WebSocket, id: str = ""):
    raise HTTPException(status_code=500, detail="unimplemented")


# @app.post("/ytdlp/download")
# def download_yt_dlp(item: VideoItem, request: Request):
#     return EventSourceResponse(event_generator(item, request))


# async def event_generator(item: VideoItem, request: Request):
#     async for progress in download(item):
#         # Check if the client disconnected to prevent resource leaks
#         if await request.is_disconnected():
#             print("Client disconnected.")
#             break
#
#         if "error" in progress:
#             yield {
#                 "event": "error",
#                 "data": json.dumps({"message": progress["error"]})
#             }
#             break
#
#         # Safely clean and extract only serializable progress metrics
#         data = progress.get("data", {})
#
#         print(data)
#
#         cleaned_data = {}
#         for key in ['status', 'downloaded_bytes', 'total_bytes', 'total_bytes_estimate', 'filename', 'tmpfilename', 'eta', 'speed', 'elapsed']:
#             if key in data:
#                 cleaned_data[key] = data[key]
#
#         yield {
#             "event": "progress",
#             "data": json.dumps({"data": cleaned_data})
#         }

if __name__ == "__main__":
    uvicorn.run("main:app", uds=DEFAULT_SOCKET, reload=True)
