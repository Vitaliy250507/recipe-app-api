FROM python:3.12-slim

ENV PYTHONUNBUFFERED = 1

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-install-project --no-dev
COPY . .
ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8000

RUN useradd -m -U djangouser

USER djangouser

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]