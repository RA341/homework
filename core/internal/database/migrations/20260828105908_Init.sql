-- +goose Up
-- create "contents" table
CREATE TABLE `contents` (
  `id` integer NULL PRIMARY KEY AUTOINCREMENT,
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  `deleted_at` datetime NULL,
  `type` integer NULL,
  `title` text NULL,
  `description` text NULL
);
-- create index "idx_contents_deleted_at" to table: "contents"
CREATE INDEX `idx_contents_deleted_at` ON `contents` (`deleted_at`);
-- create "assets" table
CREATE TABLE `assets` (
  `id` integer NULL PRIMARY KEY AUTOINCREMENT,
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  `deleted_at` datetime NULL,
  `content_id` integer NULL,
  `role` integer NULL,
  `type` integer NULL,
  `storage_path` text NULL,
  `metadata_mime_type` text NULL,
  `metadata_width` integer NULL,
  `metadata_height` integer NULL,
  `metadata_duration` integer NULL,
  `metadata_size` integer NULL,
  `metadata_is_scanned` numeric NULL DEFAULT false,
  CONSTRAINT `fk_assets_content` FOREIGN KEY (`content_id`) REFERENCES `contents` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_asset" to table: "assets"
CREATE INDEX `idx_asset` ON `assets` (`content_id`, `role`);
-- create index "idx_assets_deleted_at" to table: "assets"
CREATE INDEX `idx_assets_deleted_at` ON `assets` (`deleted_at`);
-- create "downloads" table
CREATE TABLE `downloads` (
  `id` integer NULL PRIMARY KEY AUTOINCREMENT,
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  `deleted_at` datetime NULL,
  `asset_id` integer NULL,
  `name` text NULL,
  `download_link` text NULL,
  `progress_status` integer NULL,
  `progress_error` text NULL,
  `progress_time_left_secs` integer NULL,
  `progress_download_bytes_per_second` integer NULL,
  `progress_completed` integer NULL,
  `progress_total` integer NULL,
  `download_path` text NULL,
  CONSTRAINT `fk_downloads_asset` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE
);
-- create index "idx_downloads_deleted_at" to table: "downloads"
CREATE INDEX `idx_downloads_deleted_at` ON `downloads` (`deleted_at`);
-- create "users" table
CREATE TABLE `users` (
  `id` integer NULL PRIMARY KEY AUTOINCREMENT,
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  `deleted_at` datetime NULL,
  `username` text NULL,
  `hashed_password` text NULL
);
-- create index "idx_users_deleted_at" to table: "users"
CREATE INDEX `idx_users_deleted_at` ON `users` (`deleted_at`);
-- create "sessions" table
CREATE TABLE `sessions` (
  `id` integer NULL PRIMARY KEY AUTOINCREMENT,
  `created_at` datetime NULL,
  `updated_at` datetime NULL,
  `deleted_at` datetime NULL,
  `user_id` integer NULL,
  `refresh_hashed` text NULL,
  `refresh_expiry` datetime NULL,
  CONSTRAINT `fk_sessions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- create index "idx_sessions_deleted_at" to table: "sessions"
CREATE INDEX `idx_sessions_deleted_at` ON `sessions` (`deleted_at`);

-- +goose Down
-- reverse: create index "idx_sessions_deleted_at" to table: "sessions"
DROP INDEX `idx_sessions_deleted_at`;
-- reverse: create "sessions" table
DROP TABLE `sessions`;
-- reverse: create index "idx_users_deleted_at" to table: "users"
DROP INDEX `idx_users_deleted_at`;
-- reverse: create "users" table
DROP TABLE `users`;
-- reverse: create index "idx_downloads_deleted_at" to table: "downloads"
DROP INDEX `idx_downloads_deleted_at`;
-- reverse: create "downloads" table
DROP TABLE `downloads`;
-- reverse: create index "idx_assets_deleted_at" to table: "assets"
DROP INDEX `idx_assets_deleted_at`;
-- reverse: create index "idx_asset" to table: "assets"
DROP INDEX `idx_asset`;
-- reverse: create "assets" table
DROP TABLE `assets`;
-- reverse: create index "idx_contents_deleted_at" to table: "contents"
DROP INDEX `idx_contents_deleted_at`;
-- reverse: create "contents" table
DROP TABLE `contents`;
