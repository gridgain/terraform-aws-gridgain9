
provider "aws" {
  region = "us-east-1"
}

module "gridgain" {
  source = "../../"

  nodes_count          = 1
  ami_id               = "ami-############"
  public_access_enable = true
  tags = {
    Reason = "Test Gridgain Terraform AWS module"
  }
  ssh_public_key         = "############"
  cloudwatch_logs_enable = true

  gridgain_config   = file("files/gridgain-config.conf")
  gridgain_logging   = file("files/gridgain-logging.conf")
  gridgain_ssl_cert     = file("files/server.crt")
  gridgain_ssl_key      = file("files/server.key")
  keystore_password     = "############"

  ssm_enable = true
  ssl_enable = true
}


terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
