"""Add email verification and OTP fields to users table

Revision ID: add_email_verification_otp
Revises: make_optional_001
Create Date: 2024-01-01 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'add_email_verification_otp'
down_revision = 'make_optional_001'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Add email verification columns
    op.add_column('users', sa.Column('email_verified_at', sa.DateTime(), nullable=True))
    op.add_column('users', sa.Column('verification_otp', sa.String(), nullable=True))
    op.add_column('users', sa.Column('otp_created_at', sa.DateTime(), nullable=True))
    op.add_column('users', sa.Column('otp_attempts', sa.Integer(), nullable=False, server_default='0'))


def downgrade() -> None:
    # Remove email verification columns
    op.drop_column('users', 'otp_attempts')
    op.drop_column('users', 'otp_created_at')
    op.drop_column('users', 'verification_otp')
    op.drop_column('users', 'email_verified_at')