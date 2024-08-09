provider "aws" {
  region     = "us-east-1" # Remplacez par la région souhaitée
}

# Création du groupe de sécurité
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS PostgreSQL"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permet les connexions depuis n'importe où
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Autorise tout le trafic sortant
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "14" # Remplacez par la version souhaitée
  instance_class       = "db.t3.micro"
  db_name                 = "mydb"
  username             = "compassadmin"
  password             = "yourpassword"
  skip_final_snapshot  = true
  publicly_accessible = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  # Vous pouvez ajouter des configurations supplémentaires ici
  # par exemple pour le subnet, les groupes de sécurité, etc.

  tags = {
    Name = "MyPostgresDB"
  }
}

output "endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "username" {
  value = aws_db_instance.postgres.username
}


output "address" {
  value = aws_db_instance.postgres.address
}


output "db_name" {
  value = aws_db_instance.postgres.db_name
}
