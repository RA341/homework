#!/bin/bash

# Load NVM

# Create output directories
mkdir -p generated/go generated/dart

# Generate Connect-RPC stubs using buf
buf generate

# Fix permissions on generated files
chmod -R 770 ./generated
