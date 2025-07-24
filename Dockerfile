FROM python:3.12-slim-bullseye as base


ENV PYTHONUNBUFFERED=1 \
    PYTHONFAULTHANDLER=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=on

# Set the working directory inside the container
WORKDIR /myapp

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libpq-dev \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends gcc libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements, to cache them in Docker layer
COPY ./requirements.txt /myapp/requirements.txt

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Copy the rest of application's code
COPY . /myapp
# Create the qr_codes directory
RUN mkdir -p /myapp/qr_codes
# Copy and make script executable
COPY start.sh /start.sh
RUN chmod +x /start.sh
# Run the application as a non-root user for security
RUN useradd -m myuser
USER myuser

# Port to use to run (https://localhost:8000)
EXPOSE 8000

CMD ["/start.sh"]
