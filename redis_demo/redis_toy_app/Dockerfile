# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY ["app.py", "."]
COPY ["requirements.txt", "."]

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt
RUN apt-get update && apt-get install -y curl

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV NAME World

# Harden the container
RUN groupadd -r app &&\
    useradd -r -g app -d /app -s /sbin/nologin -c "Docker image user" app &&\
    chown -R app:app /app &&\
    chmod u+x app.py

# Run as created user
USER app

# RUN ls -la

# Run app.py when the container launches
CMD ["python", "app.py"]
