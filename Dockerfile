FROM python:3.13-slim

ENV PYTHONUNBUFFERED=1
ARG DEV=false

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    gcc \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

COPY pyproject.toml uv.lock ./

RUN if [ "$DEV" = "true" ]; \
    then uv sync --frozen --no-install-project --all-groups; \
    else uv sync --frozen --no-install-project --no-dev; \
    fi

COPY . .
ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8000

RUN useradd -m -U djangouser
USER djangouser