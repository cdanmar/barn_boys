# Building Images for ARM

Building a Python docker image for an ARM device has an extra step! In images that support it, we can use builx to build a version that is ARM specific. Otherwise, some Docker images will assume the CPU architecture of the build machine is the same as the destination machine.

Note that this does not affect Docker Compose in any way.

Let's get started:

## Using buildx to build ARM images

### Checking if buildx is installed

```buildx``` is an experimental tool that needs the following environment variable enabled for it to work:

```DOCKER_CLI_EXPERIMENTAL=enabled```

Once you set this, you can verify that it works by typing in ```docker buildx``` into your terminal. You should get something to the effect of ```Usage:  docker buildx COMMAND```

### Building the image

```buildx``` typically follows a similar format as ```docker build```, with some notable changes.

First, we need to create a new builder instance:

```docker buildx create --name redis_toy_app_builder```

Then switch to it:

```docker buildx use redis_toy_app_builder```

We can now use that builder to create an ARM image for us. Navigate to the folder container the Dockerfile you want to build. From there, run the following command:

```docker buildx build --platform linux/arm64 -t us.gcr.io/barnboys/redis_toy_app . --push```

This will build and push your image to the Google Container Registry. Neat!!!
