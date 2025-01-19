provider "aws" {
  region = "eu-west-3"
}

# Récupérer les informations du VPC et des sous-réseaux existants
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = ["public-subnet-*"]
  }
}

resource "aws_security_group" "kafka_sg" {
  name_prefix = "kafka-sg-"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Autoriser SSH depuis n'importe où
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kafka-security-group"
  }
}


# Créer une instance EC2 pour Kafka
resource "aws_instance" "kafka_instance" {
  ami                    = "ami-09be70e689bddcef5"
  instance_type = "t2.medium"              # Taille de l'instance
  subnet_id = data.aws_subnets.public.ids[0]  # Utiliser le premier sous-réseau disponible
  vpc_security_group_ids = [aws_security_group.kafka_sg.id]

  key_name = "yarbi"  # Remplacez par votre paire de clés SSH

  tags = {
    Name = "kafka-instance"
  }
}



# Sortie de l'adresse IP privée de l'instance EC2
output "kafka_instance_private_ip" {
  value = aws_instance.kafka_instance.private_ip
}