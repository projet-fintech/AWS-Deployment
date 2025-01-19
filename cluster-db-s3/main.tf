provider "aws" {
  region = "eu-west-3"
}

# Utilisation du VPC existant via le tag Name
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

# Récupération des sous-réseaux publics
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

# Récupération du Security Group existant
data "aws_security_group" "eks" {
  filter {
    name   = "group-name"
    values = ["eks-sg"]
  }
  vpc_id = data.aws_vpc.main.id
}

# IAM Roles for EKS
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = "main-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = data.aws_subnets.public.ids
    security_group_ids = [data.aws_security_group.eks.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
  ]
}

# EKS Node Groups
resource "aws_eks_node_group" "backend" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "backend-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = data.aws_subnets.public.ids

  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 1
  }

  tags = {
    Name = "backend-node-group"
  }


  depends_on = [
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy
  ]
}

resource "aws_eks_node_group" "frontend" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "frontend-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = data.aws_subnets.public.ids

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  tags = {
    Name = "frontend-node-group"
  }


  depends_on = [
    aws_iam_role_policy_attachment.eks_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_node_AmazonEKS_CNI_Policy
  ]
}



# S3 Bucket
resource "aws_s3_bucket" "app_storage" {
  bucket = "app-storage-${random_id.bucket_id.hex}"

  tags = {
    Name = "app-storage"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}