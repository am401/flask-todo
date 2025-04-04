data "aws_iam_instance_profile" "ec2-s3-readonly-role" {
	name = "ec2-s3-readonly-role"
}

resource "aws_instance" "my_vm" {
	ami		= "ami-08b5b3a93ed654d19" // Amazon Linux 2023 AMI
	instance_type = "t2.micro"
	iam_instance_profile = data.aws_iam_instance_profile.ec2-s3-readonly-role.name
	key_name = "prod-web-apps-keys"
	security_groups = ["launch-wizard-5"]
	
	metadata_options {
		http_endpoint = "enabled"
		http_tokens = "optional"
	}

	user_data = file("../scripts/userdata.sh")
	tags = {
		Name = "flask-todo-app-tf-test-3"
	}
}
