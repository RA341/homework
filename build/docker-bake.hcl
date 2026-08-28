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
  targets    = ["core", "scribe", "omni"]
}

group "base" {
  targets = ["base-frontend", "base-yt", "base-gomod"]
}

group "all" {
  targets = ["base-frontend", "base-yt", "base-gomod", "core", "scribe", "omni"]
}

# --- Base Targets (Intermediate / Cache-only) ---

target "base-frontend" {
  context    = "."
  dockerfile = "build/Dockerfile.base.frontend"
  output     = ["type=cacheonly"]
}

target "base-yt" {
  context    = "."
  dockerfile = "build/Dockerfile.base.yt"
  output     = ["type=cacheonly"]
}

target "base-gomod" {
  context    = "."
  dockerfile = "build/Dockerfile.base.gomod"
  output     = ["type=cacheonly"]
}

# --- Product Targets ---

target "core" {
  inherits   = ["docker-metadata-action"]
  context    = "."
  dockerfile = "build/Dockerfile.core"
  contexts = {
    "base-gomod"    = "target:base-gomod"
    "base-frontend" = "target:base-frontend"
  }
  tags = [
    for t in target.docker-metadata-action.tags :
      can(regex("^ghcr\\.io", t)) ?
        replace(t, "${REPO_NAME}:", "${REPO_NAME}/core:") :
        replace(t, "${REPO_NAME}:", "${REPO_NAME}:core-")
  ]
}

target "scribe" {
  inherits   = ["docker-metadata-action"]
  context    = "."
  dockerfile = "build/Dockerfile.scribe"
  contexts = {
    "base-gomod" = "target:base-gomod"
    "base-yt"    = "target:base-yt"
  }
  tags = [
    for t in target.docker-metadata-action.tags :
      can(regex("^ghcr\\.io", t)) ?
        replace(t, "${REPO_NAME}:", "${REPO_NAME}/scribe:") :
        replace(t, "${REPO_NAME}:", "${REPO_NAME}:scribe-")
  ]
}

target "omni" {
  inherits   = ["docker-metadata-action"]
  context    = "."
  dockerfile = "build/Dockerfile.omni"
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
