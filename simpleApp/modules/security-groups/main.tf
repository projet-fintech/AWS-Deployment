# Security Group pour le EKS Control Plane
resource "aws_security_group" "eks_control_plane" {
  name        = "${var.project_name}-eks-control-plane-sg"
  description = "Security group for EKS Control Plane"
  vpc_id   = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Autoriser l'accès depuis n'importe où (à restreindre si nécessaire)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Autoriser tout le trafic sortant
  }

  tags = {
    Name = "${var.project_name}-eks-control-plane-sg"
  }
}

# Security Group pour les EKS Worker Nodes
resource "aws_security_group" "eks_worker_nodes" {
  name        = "${var.project_name}-eks-worker-nodes-sg"
  description = "Security group for EKS Worker Nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Autoriser le trafic depuis le VPC
  }

  ingress {
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Autoriser le trafic depuis n'importe où (pour les services exposés)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Autoriser tout le trafic sortant
  }

  tags = {
    Name = "${var.project_name}-eks-worker-nodes-sg"
  }
}

# Security Group pour MySQL
resource "aws_security_group" "mysql" {
  name        = "${var.project_name}-mysql-sg"
  description = "Security group for MySQL"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Autoriser l'accès depuis le VPC uniquement
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Autoriser tout le trafic sortant
  }

  tags = {
    Name = "${var.project_name}-mysql-sg"
  }
}

# Security Group pour l'ALB (Application Load Balancer)
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id     = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Autoriser le trafic HTTP depuis n'importe où
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Autoriser le trafic HTTPS depuis n'importe où
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Autoriser tout le trafic sortant
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}



