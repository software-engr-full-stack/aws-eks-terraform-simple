locals {
  name   = "test-eks-cluster"
  region = "us-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = ["us-west-1a", "us-west-1b"]

  public_subnets  = ["10.0.10.0/24", "10.0.20.0/24"]
  private_subnets = ["10.0.30.0/24", "10.0.40.0/24"]
  intra_subnets   = ["10.0.50.0/24", "10.0.60.0/24"]

  tags = {
    Name = local.name
  }
}
