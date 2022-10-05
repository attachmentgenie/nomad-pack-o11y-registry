resource "minio_s3_bucket" "loki" {
  bucket = "logs"
  acl    = "public"
}

resource "minio_s3_bucket" "mimir" {
  bucket = "metrics"
  acl    = "public"
}

resource "minio_s3_bucket" "tempo" {
  bucket = "traces"
  acl    = "public"
}