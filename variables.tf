variable "vpc_id" {
  description = "VPC ID to be deployed into. If empty, module should provision new VPC"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of private subnet IDs to be used for deployment. If empty, module should provision new subnets"
  type        = list(string)
  default     = []
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
  default     = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "zones" {
  description = "List of availability zones to create VPC in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_access_enable" {
  description = "Whether cluster should be publicly accessible or not"
  type        = bool
  default     = false
}

variable "public_allowlist" {
  description = "List of CIDRs to be allowed in securitygroup for public access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ports" {
  description = "List of ports to be allowed in securitygroup"
  type        = list(string)
  default     = ["22", "3344", "10300", "10800"]
}

variable "instance_type" {
  description = "Instance type to be used for GridGain nodes"
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "Size of root volume in GB for GridGain nodes"
  type        = number
  default     = 128
}

variable "root_volume_type" {
  description = "Type of root volume for GridGain nodes"
  type        = string
  default     = "gp3"
}

variable "root_volume_throughput" {
  description = "Root volume throughput in MB/s"
  type        = number
  default     = null
}

variable "root_volume_iops" {
  description = "Amount of provisioned IOPS for root volume"
  type        = number
  default     = null
}

variable "root_volume_delete_on_termination" {
  description = "Whether the volume should be destroyed on GridGain nodes termination"
  type        = bool
  default     = true
}

variable "nodes_count" {
  description = "Number of nodes"
  type        = number
  default     = 3
}

variable "ami_id" {
  description = "AMI to be used in deployment, if empty, should default to latest"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key used to connect to instances. If empty, none will be provisioned"
  type        = string
  default     = ""
}

variable "ssm_enable" {
  description = "Enable secure session manager"
  type        = bool
  default     = true
}

variable "cloudwatch_logs_enable" {
  description = "Enable sending logs to Cloudwatch Logs"
  type        = bool
  default     = false
}

variable "fullname" {
  description = "Full name to be used in description of all resources"
  type        = string
  default     = "GridGain 9 Cluster"
}

variable "name" {
  description = "Name prefix to be used for all resources"
  type        = string
  default     = "gridgain9db"
}

variable "tags" {
  description = "A map of additional tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "gridgain_config" {
  description = "GridGain config"
  type        = string
  default     = ""
}

variable "gridgain_logging" {
  description = "GridGain logging config"
  type        = string
  default     = ""
}

variable "kms_key_alias" {
  description = "KMS Key alias to be used for encryption. If empty, module will create a new one"
  type        = string
  default     = ""
}

variable "ssl_enable" {
  description = "Whether SSL should be enabled"
  type        = bool
  default     = false
}

variable "gridgain_ssl_cert" {
  description = "GridGain SSL certificate"
  type        = string
  default     = ""
}

variable "gridgain_ssl_key" {
  description = "GridGain SSL key"
  type        = string
  default     = ""
}

variable "keystore_password" {
  description = "SSL Keystore password"
  type        = string
  default     = ""
}

variable "gridgain_license" {
  description = "GridGain license"
  type        = string
  default     = ""
}
