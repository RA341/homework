default:
   just --list

dk:
     docker buildx bake -f build/docker-bake.hcl

dkr:
    just dk
    docker run --rm homework/api:dev

dkd:
    docker build . -f Dockerfile.downloader -t homework/downloader:dev

[working-directory("core")]
mig name:
    atlas migrate diff {{ name }} --env local

dkdr:
    just dkd
    docker run --rm -p 8000:8000 -v ./.build:/home/ra341/Dev/go/homework/.build homework/downloader:dev

brow:
    docker compose up browser

[working-directory("downloader")]
down:
    source .venv/bin/activate
    python3 main.py

[working-directory("core")]
gen:
    go generate ./...

sdk:
    @just gen

[working-directory("spec")]
gensdk:
    task gen
