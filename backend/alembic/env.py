from logging.config import fileConfig
from sqlalchemy import create_engine, pool
from alembic import context
import os
from dotenv import load_dotenv

# Load .env variables
load_dotenv()

# Alembic Config
config = context.config

# Set up logging
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# ✅ Import Base and all models
from app.database import Base
from app.models.user import User
from app.models.asset_type import AssetType
from app.models.net_asset import NetWorthAsset
from app.models.snapshot import NetWorthSnapshot
from app.models.budget import BudgetChoice

# ✅ Make sure all models are loaded into metadata
target_metadata = Base.metadata

# ✅ Safety filter — prevent accidental table drops
def include_object(object, name, type_, reflected, compare_to):
    IGNORED_TABLES = [
        "net_worth_assets",
        "net_worth_snapshots",
        "users",
        "asset_types",
        "currencies",  
        "budget_choice",
        "bank_transaction",
        "mf_transaction",
        "net_worth_transaction",
        # Add more table names you want to protect
    ]
    if type_ == "table" and name in IGNORED_TABLES:
        return False
    return True

def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode."""
    url = os.getenv("DATABASE_URL_SYNC")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        include_object=include_object,
    )
    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online() -> None:
    """Run migrations in 'online' mode."""
    database_url = os.getenv("DATABASE_URL_SYNC")
    if not database_url:
        raise ValueError("DATABASE_URL_SYNC not found in environment variables")

    connectable = create_engine(
        database_url,
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
            compare_server_default=True,
            include_object=include_object,
        )
        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
