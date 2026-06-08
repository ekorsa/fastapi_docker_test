# --- Stage 1: Build dependencies (Builder Pattern) ---
FROM python:3.11-slim AS builder

WORKDIR /app

# Upgrade pip to the latest version to avoid build issues
RUN pip install --no-cache-dir --upgrade pip

# Copy the dependency list into the build container
COPY requirements.txt .

# Build wheels for dependencies to cache compiled binaries and speed up the final image build
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt


# --- Stage 2: Final minimal production image ---
FROM python:3.11-slim

WORKDIR /app

# Copy the pre-built wheels from the builder stage and install them without downloading anything from internet
COPY --from=builder /app/wheels /wheels
RUN pip install --no-cache-dir /wheels/* && rm -rf /wheels

# Copy only the application source code to minimize layer size
COPY main.py .

# Create a non-root user and change ownership for security best practices (avoid running as root in production)
RUN useradd -u 8888 appuser && chown -R appuser:appuser /app
USER appuser

# Document the port that the application listens on
EXPOSE 8000

# Run the uvicorn server, binding it to all interfaces on port 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

