# Unif.io Packer Dockerfile
[![CircleCI](https://circleci.com/gh/unifio/dockerfile-packer.svg?style=svg)](https://circleci.com/gh/unifio/dockerfile-packer)

## What is Packer

Packer is a tool for creating machine and container images for multiple platforms from a single source configuration.

[https://packer.io/](https://packer.io/)

## Dockerfile

This Docker image is based on the official [alpine:latest](https://hub.docker.com/_/alpine/) base image.

## Enhancements

* Includes [unifio/packer-provisioner-serverspec](https://github.com/unifio/packer-provisioner-serverspec).
* Includes [unifio/packer-post-processor-vagrant-s3](https://github.com/unifio/packer-post-processor-vagrant-s3).
* Includes Ruby for use with Serverspec (see usage instruction below)

## How to use this image

```
docker run unifio/packer [--version] [--help] <command> [<args>]

```

### Using the Serverspec provisioner

The Serverspec provisioner expects you to provide a Rakefile and configure the RubyGems environment. See the `test` section of the [circle.yml](circle.yml) for a comprehensive example.
