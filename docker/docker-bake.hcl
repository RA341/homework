variable "TAG" {
  default = ""
}

variable "TAGS" {
  default = "latest"
}

variable "REGISTRY" {
  default = "homework"
}

function "tags" {
  params = [name]
  result = [for tag in split(",", TAG != "" ? TAG : TAGS) : "${REGISTRY}/${name}:${trimspace(tag)}"]
}

group "default" {
  cache-from = ["type=gha"]
  cache-to   = ["type=gha,mode=max"]
  targets = ["lite-core", "lite-downloader", "omni"]
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
  context    = "."
  dockerfile = "docker/Dockerfile.lite.core"
  contexts = {
    "base-gomod"    = "target:base-gomod"
    "base-frontend" = "target:base-frontend"
  }
  inherits = ["meta-core"]
}

target "lite-downloader" {
  context    = "."
  dockerfile = "docker/Dockerfile.lite.downloader"
  contexts = {
    "base-gomod" = "target:base-gomod"
    "base-yt"    = "target:base-yt"
  }
  inherits = ["meta-downloader"]
}

target "omni" {
  context    = "."
  dockerfile = "docker/Dockerfile.omni"
  contexts = {
    "base-gomod"    = "target:base-gomod"
    "base-yt"       = "target:base-yt"
    "base-frontend" = "target:base-frontend"
  }
  inherits = ["meta-omni"]
}
