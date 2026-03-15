output "rds_info" {
  value = {
    for key, db in aws_db_instance.this :
    key => {
      endpoint   = db.endpoint
      secret_arn = db.master_user_secret[0].secret_arn
    }
  }
}