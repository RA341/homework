# Stubs

This folder contains all gRPC stubs used in the project.

## Usage

Make sure to install the [requirements](#requirements).

To generate new stubs, run:

```bash
task gen
```

This command will run the included Dockerfile, compile stubs using the [script](gen-stubs.sh) within the container, and copy the output stubs to their respective configured directories.

## Requirements

The project requires:

* Docker installed on your machine
* [Taskfile CLI](https://taskfile.dev) installed on your machine
