output "rds_endpoints" {

  value = {

    for key, db in aws_db_instance.this :
    key => db.endpoint

  }

}