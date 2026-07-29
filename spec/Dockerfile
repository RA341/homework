FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    git \
    wget \
    unzip \
    protobuf-compiler \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install Go
ENV GO_VERSION=1.25.3

RUN curl -OL https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz && \
    rm go$GO_VERSION.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/home/ubuntu/go
ENV PATH=$PATH:$GOPATH/bin

USER ubuntu


USER root
# Install Dart SDK
RUN wget https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip -O /tmp/dart-sdk.zip && \
    unzip /tmp/dart-sdk.zip -d /usr/lib && \
    rm /tmp/dart-sdk.zip
ENV PATH=$PATH:/usr/lib/dart-sdk/bin

USER ubuntu
RUN dart pub global activate protoc_plugin 22.5.0
ENV PATH="/home/ubuntu/.pub-cache/bin:${PATH}"

RUN go install github.com/bufbuild/buf/cmd/buf@latest && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install connectrpc.com/connect/cmd/protoc-gen-connect-go@latest

USER root
RUN mkdir -p /workspace && chown -R ubuntu:ubuntu /workspace
USER ubuntu

WORKDIR /workspace

CMD ["./gen-stubs.sh"]
