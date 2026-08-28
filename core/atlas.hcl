data "external_schema" "gorm" {
  program = [
    "go", "run", "./cmd/migrator",
  ]
}

env "local" {
  src = data.external_schema.gorm.url

  dev = "sqlite://file?mode=memory&cache=shared&_fk=1"

  migration {
    dir    = "file://internal/database/migrations"
    format = goose
  }
}