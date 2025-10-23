"""add_password_reset_fields

Revision ID: add_password_reset_fields
Revises: make_user_fields_optional
Create Date: 2024-01-01 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'add_password_reset_fields'
down_revision = 'make_user_fields_optional'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Add password reset fields to users table
    op.add_column('users', sa.Column('reset_token', sa.String(), nullable=True))
    op.add_column('users', sa.Column('reset_token_created_at', sa.DateTime(), nullable=True))
    op.add_column('users', sa.Column('reset_token_used', sa.Boolean(), nullable=True, server_default=sa.literal(False)))
    
    # Create index on reset_token for faster lookups
    op.create_index('ix_users_reset_token', 'users', ['reset_token'], unique=True)


def downgrade() -> None:
    # Drop index
    op.drop_index('ix_users_reset_token', table_name='users')
    
    # Drop columns
    op.drop_column('users', 'reset_token_used')
    op.drop_column('users', 'reset_token_created_at')
    op.drop_column('users', 'reset_token')