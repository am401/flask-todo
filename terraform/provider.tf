terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~> 4.19.0"
		}
	}
}

# Configure AWS provider
provider "aws" {
	region = "us-east-1"
}
