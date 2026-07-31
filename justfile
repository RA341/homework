default:
   just --list

dk:
    docker build . -f Dockerfile.core -t homework/api:dev

dkr:
    just dk
    docker run --rm homework/api:dev

dkd:
    docker build . -f Dockerfile.downloader -t homework/downloader:dev

[working-directory("core")]
gen:
    go generate ./...

sdk:
    @just gen

[working-directory("spec")]
gensdk:
    task gen
