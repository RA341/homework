variable "REPO_NAME" {
  default = "homework"
}

target "docker-metadata-action" {
  tags = [
    "${REPO_NAME}:latest"
  ]
}

group "default" {
  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
  targets    = ["lite-core", "lite-downloader", "omni"]
}

group "base" {
  targets = ["base-frontend", "base-yt", "base-gomod"]
}

group "lite" {
  targets = ["lite-core", "lite-downloader"]
}

group "all" {
  targets = ["base-frontend", "base-yt", "base-gomod", "lite-core", "lite-downloader", "omni"]
}

# --- Base Targets (Intermediate / Cache-only) ---

target "base-frontend" {
  context    = "."
  dockerfile = "docker/Dockerfile.base.frontend"
  output     = ["type=cacheonly"]
}

target "base-yt" {
  context    = "."
  dockerfile = "docker/Dockerfile.base.yt"
  output     = ["type=cacheonly"]
}

target "base-gomod" {
  context    = "."
  dockerfile = "docker/Dockerfile.base.gomod"
  output     = ["type=cacheonly"]
}

# --- Product Targets ---

target "lite-core" {
  inherits   = ["docker-metadata-action"]
  context    = "."
  dockerfile = "docker/Dockerfile.lite.core"
  contexts = {
    "base-gomod"    = "target:base-gomod"
    "base-frontend" = "target:base-frontend"
  }
  tags = [
    for t in target.docker-metadata-action.tags :
      can(regex("^ghcr\\.io", t)) ?
        replace(t, "${REPO_NAME}:", "${REPO_NAME}/lite/core:") :
        replace(t, "${REPO_NAME}:", "${REPO_NAME}:lite.core-")
  ]
}

target "lite-downloader" {
  inherits   = ["docker-metadata-action"]
  context    = "."
  dockerfile = "docker/Dockerfile.lite.downloader"
  contexts = {
    "base-gomod" = "target:base-gomod"
    "base-yt"    = "target:base-yt"
  }
  tags = [
    for t in target.docker-metadata-action.tags :
      can(regex("^ghcr\\.io", t)) ?
        replace(t, "${REPO_NAME}:", "${REPO_NAME}/lite/downloader:") :
        replace(t, "${REPO_NAME}:", "${REPO_NAME}:lite.downloader-")
  ]
}

target "omni" {
  inherits   = ["docker-metadata-action"]
  context    = "."
  dockerfile = "docker/Dockerfile.omni"
  contexts = {
    "base-gomod"    = "target:base-gomod"
    "base-yt"       = "target:base-yt"
    "base-frontend" = "target:base-frontend"
  }
  tags = [
    for t in target.docker-metadata-action.tags :
      can(regex("^ghcr\\.io", t)) ?
        replace(t, "${REPO_NAME}:", "${REPO_NAME}/omni:") :
        replace(t, "${REPO_NAME}:", "${REPO_NAME}:omni-")
  ]
}
