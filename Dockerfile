FROM python:3.9-slim

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    python3-tk \
    libpulse0 \
    sox \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the application files
COPY app.py .
COPY requirements.txt .
COPY templates templates/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set environment variable for display
ENV DISPLAY=:0

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application with gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"] 