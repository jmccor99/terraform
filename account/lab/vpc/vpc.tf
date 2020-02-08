module "vpc" {
  source               = "../../../modules/base/vpc"
  cidr                 = var.cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  vpc_name             = var.vpc_name
}

module "subnet" {
  source               = "../../../modules/base/subnet"
  vpc_id               = module.vpc.vpc_id
  azs                  = var.azs
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
}

module "igw" {
  source               = "../../../modules/base/igw"
  vpc_id               = module.vpc.vpc_id
  cidr                 = var.cidr
  public_subnets       = module.subnet.subnet_public_ids
}

module "ngw" {
  source               = "../../../modules/base/ngw"
  vpc_id               = module.vpc.vpc_id
  azs                  = var.azs
  cidr                 = var.cidr
  public_subnets       = module.subnet.subnet_public_ids
  private_subnets      = module.subnet.subnet_private_ids
}

module "nacl" {
  source               = "../../../modules/base/nacl"
  vpc_id               = module.vpc.vpc_id
  public_subnets       = module.subnet.subnet_public_ids
  private_subnets      = module.subnet.subnet_private_ids
}

module "sg" {
  source               = "../../../modules/base/sg"
  vpc_id               = module.vpc.vpc_id
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
}

module "ec2" {
  source                     = "../../../modules/base/ec2"
  public_subnets             = module.subnet.subnet_public_ids
  private_subnets            = module.subnet.subnet_private_ids
  public_security_group_id   = module.sg.public_security_group_id
  private_security_group_id  = module.sg.private_security_group_id
}

module "nlb" {
  source                     = "../../../modules/base/nlb"
  vpc_id                     = module.vpc.vpc_id
  public_subnets             = module.subnet.subnet_public_ids
  private_subnets            = module.subnet.subnet_private_ids
  public_ec2_id              = module.ec2.public_ec2_id
  private_ec2_id             = module.ec2.private_ec2_id
}

module "lambda" {
  source                     = "../../../modules/base/lambda"
}

module "apigw" {
  source                     = "../../../modules/base/apigw"
  lambda_invoke_arn          = module.lambda.lambda_invoke_arn
  lambda_function_name       = module.lambda.lambda_function_name
}

module "sns" {
  source               = "../../../modules/base/sns"
}