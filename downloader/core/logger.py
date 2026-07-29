import logging
import sys


def setup_logging() -> None:
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        handlers=[logging.StreamHandler(sys.stdout)],
    )

    # Suppress verbose logs from third-party libraries
    logging.getLogger("uvicorn.access").setLevel(logging.WARNING)


logger = logging.getLogger("depot")
