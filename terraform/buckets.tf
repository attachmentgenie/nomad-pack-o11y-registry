resource "minio_s3_bucket" "loki" {
  bucket = "logs"
  acl    = "public"
}

resource "minio_s3_bucket" "mimir-buckets" {
  bucket = "metrics"
  acl    = "public"
}

resource "minio_s3_bucket" "mimir-rules" {
  bucket = "rules"
  acl    = "public"
}

resource "minio_s3_bucket" "tempo" {
  bucket = "traces"
  acl    = "public"
}