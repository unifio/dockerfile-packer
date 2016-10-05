# Unif.io Packer Dockerfile
[![CircleCI](https://circleci.com/gh/unifio/dockerfile-packer.svg?style=svg)](https://circleci.com/gh/unifio/dockerfile-packer)

## What is Packer

Packer is a tool for creating machine and container images for multiple platforms from a single source configuration.

[https://packer.io/](https://packer.io/)

## Dockerfile

This Docker image is based on the official [alpine:3.4](https://hub.docker.com/_/alpine/) base image.

## Enhancements

* Includes [unifio/packer-provisioner-serverspec](https://github.com/unifio/packer-provisioner-serverspec).
* Includes [unifio/packer-post-processor-vagrant-s3](https://github.com/unifio/packer-post-processor-vagrant-s3).
* Includes Ruby for use with Serverspec (see usage instruction below).
* Includes [gosu](https://github.com/tianon/gosu) for optionally changing the user that executes Packer.

## How to use this image

```
docker run --rm unifio/packer [--version] [--help] <command> [<args>]
```

In Continuous Integration (CI) environments it can often be a problem if the container leaves behind artifacts owned by the root user that then prevent clean-up of the build workspace.
You can optionally coordinate the UID of the build user and the user within the container by passing the `LOCAL_USER_ID` environment variables into the container.

For example:

```
docker run -e LOCAL_USER_ID=$UID --rm unifio/packer [--version] [--help] <command> [<args>]
```

With debugging output to log which UID was used:

```
docker run -e LOCAL_USER_ID=$UID -e DEBUG=true --rm unifio/packer [--version] [--help] <command> [<args>]
```

### Using the Serverspec provisioner

The Serverspec provisioner expects you to provide a Rakefile and configure the RubyGems environment. See the `test` section of the [circle.yml](circle.yml) for a comprehensive example.
