# Créer un groupe de sécurité ouvert à tout le trafic
resource "aws_security_group" "allow_all" {
  name        = "allow_all_traffic"
  description = "Security group with all traffic allowed"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 signifie tous les protocoles
    cidr_blocks = ["0.0.0.0/0"]  # Autoriser tout le monde
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Autoriser tout le monde
  }
}

# Créer une instance EC2 de type t2.micro
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-03972092c42e8c0ca"  # Remplacez par l'AMI de votre choix
  instance_type = "t2.micro"

  # Lier l'instance au groupe de sécurité
  security_groups = [aws_security_group.allow_all.name]

  tags = {
    Name = "MyTerraformInstance"
  }
}
