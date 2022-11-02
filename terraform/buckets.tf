resource "minio_s3_bucket" "loki-buckets" {
  bucket = "logs"
  acl    = "public"
}

resource "minio_s3_bucket" "loki-rules" {
  bucket = "loki-rules"
  acl    = "public"
}

resource "minio_s3_bucket" "mimir-alertmanager" {
  bucket = "mimir-alertmanager"
  acl    = "public"
}

resource "minio_s3_bucket" "mimir-buckets" {
  bucket = "metrics"
  acl    = "public"
}

resource "minio_s3_bucket" "mimir-rules" {
  bucket = "mimir-rules"
  acl    = "public"
}

resource "minio_s3_bucket" "phlare" {
  bucket = "profiling"
  acl    = "public"
}

resource "minio_s3_bucket" "tempo" {
  bucket = "traces"
  acl    = "public"
}