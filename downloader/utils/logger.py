import logging
import os
import sys


def setup_logging() -> None:
    # Get log level from environment, default to INFO
    log_level_str = os.getenv("LOG_LEVEL", "INFO").upper()
    log_level = getattr(logging, log_level_str, logging.INFO)

    logging.basicConfig(
        level=log_level,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        handlers=[logging.StreamHandler(sys.stdout)],
    )

    # Suppress verbose logs from third-party libraries unless log level is DEBUG
    if log_level > logging.DEBUG:
        logging.getLogger("uvicorn.access").setLevel(logging.WARNING)
    else:
        logging.getLogger("uvicorn.access").setLevel(log_level)


logger = logging.getLogger("depot")
