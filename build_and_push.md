# Image Building, Tagging, and Pushing

## Tagging The Image

```[HOSTNAME]/[PROJECT-ID]/[IMAGE]:[TAG]```

Example:

```us.gcr.io/barnboys/cheddar:v1```

Where ```us.gcr.io``` is the Google Container Registry URL, ```barnboys``` is the name of the project the registry is hosted, ````cheddar```` is the name of the container, and ```v1``` is the tag.

In this case, the tag is completely optional. In case you want to make sure you are always pulling the latest image without versioning, you can build the image as so:

```us.gcr.io/barnboys/cheddar```

## Building the image

Basic build without version:

```docker build -t us.gcr.io/barnboys/cheddar .```

This will create an image without a tag. When pushed to the registry, it will be tagged with latest.

A couple things to note about this command:
1) You need to have Docker Desktop installed and running in your machine
2) The ```.``` at the end denotes context. This means that this command must be run in the same directory as the Dockerfile
3) If you don't specify a version, building a new container will replace the existing one

## Pushing the image

First, you will need to authenticate to Google Container Registry, the Docker registry we will be using to host our projects. See ```installing_gcloud_cli.md```

Authenticate to the container registry like so:

```gcloud auth configure-docker```

Then, push out the image you built and tagged in the earlier step:

```docker push us.gcr.io/barnboys/cheddar```

The push should be successful. If you have any issues, see <https://cloud.google.com/container-registry/docs/advanced-authentication>

In this example, the built image can be pulled via the following command: ```docker pull us.gcr.io/barnboys/cheddar:latest```

## Deploying to Jetson Nano

To do...
