from fastapi import Request
from fastapi.responses import JSONResponse
from core.logger import logger


class DepotError(Exception):
    """Base exception for Depot application."""

    def __init__(self, message: str, status_code: int = 400):
        self.message = message
        self.status_code = status_code
        super().__init__(self.message)


async def depot_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    # Use isinstance check if we need specific DepotError fields
    message = exc.message if isinstance(exc, DepotError) else "An error occurred"
    status_code = exc.status_code if isinstance(exc, DepotError) else 400

    logger.error(f"Application error: {message} (Path: {request.url.path})")
    return JSONResponse(
        status_code=status_code,
        content={"error": message, "status": "error"},
    )


async def global_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    logger.exception(f"Unhandled exception: {str(exc)} (Path: {request.url.path})")
    return JSONResponse(
        status_code=500,
        content={"error": "An internal server error occurred", "status": "error"},
    )
