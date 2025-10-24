"""Add is_live column to users table

Revision ID: add_is_live_column
Revises: d9f50014a847
Create Date: 2025-10-24 23:30:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'add_is_live_column'
down_revision: Union[str, None] = 'add_password_reset_fields'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Add is_live column to users table for location sharing status
    op.add_column('users', sa.Column('is_live', sa.Boolean(), nullable=False, server_default=sa.literal(False)))
    
    # Create index on is_live for faster queries
    op.create_index('ix_users_is_live', 'users', ['is_live'])


def downgrade() -> None:
    # Drop index
    op.drop_index('ix_users_is_live', table_name='users')
    
    # Drop column
    op.drop_column('users', 'is_live')