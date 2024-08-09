# Créer le secret dans Secrets Manager
resource "aws_secretsmanager_secret" "rds_pg_secret" {
  name        = "my-postgres-rds-secret"  # Nom du secret
  description = "Credentials for the PostgreSQL RDS instance"
}

# Associer les informations d'identification de PostgreSQL au secret
resource "aws_secretsmanager_secret_version" "rds_pg_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_pg_secret.id
  secret_string = jsonencode({
   engine	= aws_db_instance.postgres.engine
   host 	= aws_db_instance.postgres.address
   username	= "compassadmin"
   password	= "yourpassword"
   dbname 	= aws_db_instance.postgres.db_name
   port		= aws_db_instance.postgres.port
 })
}
