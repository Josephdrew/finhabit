from logging.config import fileConfig
from sqlalchemy import create_engine, pool
from alembic import context
import os
from dotenv import load_dotenv

# Load .env variables
load_dotenv()

# Alembic config
config = context.config

# Setup logging
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# Import your models and metadata
from app.database import Base
from app.models import *  # Import all model files (Currency, OTP, etc.)

# ✅ Correct metadata for autogenerate
target_metadata = Base.metadata


def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode."""
    url = os.getenv("DATABASE_URL_SYNC")  # dynamically load from .env
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    """Run migrations in 'online' mode."""
    database_url = os.getenv("DATABASE_URL_SYNC")

    if not database_url:
        raise ValueError("DATABASE_URL not found in environment variables")

    connectable = create_engine(
        database_url,
        poolclass=pool.NullPool,
    )

    # ✅ Define which tables to exclude
    def include_object(object, name, type_, reflected, compare_to):
        IGNORED_TABLES = ['transactions', 'some_legacy_table']  # Add any non-managed table names here
        if type_ == "table" and name in IGNORED_TABLES:
            return False  # Skip this table
        return True

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
            compare_server_default=True,
            include_object=include_object,  # ✅ Prevent deletion/changes to unmanaged tables
        )

        with context.begin_transaction():
            context.run_migrations()



if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
