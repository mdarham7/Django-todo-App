# First stage: build the dependencies
FROM python:3 as builder

# Set working directory
WORKDIR /app

# Copy only the requirements to cache dependencies
COPY requirements.txt .

# Install dependencies
RUN pip install --prefix=/install -r requirements.txt

# Second stage: build the actual image
FROM python:3-slim

# Set working directory
WORKDIR /app

# Copy the application code
COPY . .

# Copy the installed dependencies from the builder stage
COPY --from=builder /install /usr/local

# Run database migrations
RUN python manage.py migrate

# Command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
