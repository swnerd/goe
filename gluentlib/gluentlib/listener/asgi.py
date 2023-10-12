# Standard Library
import multiprocessing
from pathlib import Path

# Third Party Libraries
from cx_Oracle import DatabaseError as OracleDatabaseError
from fastapi import FastAPI
from fastapi.exceptions import HTTPException, RequestValidationError
from fastapi.responses import ORJSONResponse
from fastapi.staticfiles import StaticFiles
from pydantic import ValidationError
from redis.exceptions import RedisError

# Gluent
from gluent import strict_version_ready, version
from gluentlib.listener import exceptions, schemas
from gluentlib.listener.config import settings
from gluentlib.listener.config.logging import Logger
from gluentlib.listener.config.router import router
from gluentlib.listener.core import events, middleware

LISTENER_ROOT = Path(__file__).parent

ErrorMessage = {"model": schemas.ErrorMessage}
http_error_response_schema_map = {
    404: ErrorMessage,
    422: ErrorMessage,
    401: ErrorMessage,
    403: ErrorMessage,
    500: ErrorMessage,
}
exception_handler_map = {
    OracleDatabaseError: exceptions.database_connectivity_error,
    ValueError: exceptions.system_error_exception_handler,
    ValidationError: exceptions.http422_error_handler,
    HTTPException: exceptions.http_error_handler,
    RequestValidationError: exceptions.http422_error_handler,
    exceptions.BaseApplicationError: exceptions.app_error_handler,
    RedisError: exceptions.cache_connectivity_error,
}


def get_app() -> FastAPI:
    """
    Get FastAPI application.

    This is the main constructor of an application.

    :return: application.
    """
    # this is to prevent endless loops when using pyinstaller and bundlers
    multiprocessing.freeze_support()

    # todo: initialize Offload Logging config here
    logger = Logger.configure_logger()
    # todo: bring in nested/structured config setup
    app = FastAPI(
        # debug=settings.server.debug,
        docs_url=None,  # defined in route so that we can host Swagger JS locally
        openapi_url="/api/openapi.json",
        redoc_url=None,  # defined in route so that we can host Swagger JS locally
        title="Gluent Listener",
        description="Gluent Listener",
        terms_of_service="https://gluent.com/terms-of-service/",  # todo: update this/embed a page/add text?
        version=strict_version_ready(version()),
        default_response_class=ORJSONResponse,
        on_startup=[events.on_startup],
        on_shutdown=[events.on_shutdown],
        logger=logger,
        log_level="error",
        responses=http_error_response_schema_map,
        exception_handlers=exception_handler_map,
    )

    # -----------------
    # Middleware
    # -----------------

    app.add_middleware(middleware.CompressionMiddleware)
    app.add_middleware(middleware.SecurityHeaderMiddleware)
    app.add_middleware(
        middleware.CORSMiddleware,
        path_regex="^/api",
        allow_origins="*",  # todo: integrate the setting into the configuration
        allow_credentials=False,
        allow_methods=["*"],
        allow_headers=["Authorization", "X-Requested-With"],
    )
    # -----------------
    # Static Files
    # -----------------
    app.mount(
        "/public",
        StaticFiles(directory=settings.static_path),
        name="static",
    )

    # -----------------
    # Endpoints
    # -----------------
    app.include_router(router=router)

    return app


application = get_app()
