module "lattice-aws" {
    # Specify a source containing the terraform configuration
    source = ".."

    # Specify a URL or local path to a lattice.tgz file for deployment
    lattice_tar_source = "http://lattice.s3.amazonaws.com/releases/backend/lattice-v0.4.3.tgz"

    # Specify an API username and password for your lattice cluster
    # lattice_username = "<CHANGE-ME>"
    # lattice_password = "<CHANGE-ME>"

    # AWS access key
    # aws_access_key = "<CHANGE-ME>"

    # AWS Subnet ID and Security Group
    # aws_subnet_id = "<CHANGE-ME>"
    # aws_security_group = "<CHANGE-ME>"
	
    # AWS secret key
    # aws_secret_key = "<CHANGE-ME>"

    # The SSH key name to use for the instances
    # aws_key_name = "<CHANGE-ME>"

    # Path to the SSH private key file
    # aws_ssh_private_key_file = "<CHANGE-ME>"

    # The number of Lattice Cells to launch (optional, default: "3")
    # num_cells = "3"

    # AWS region (optional, default: "us-east-1")
    # aws_region = "us-east-1"
}

output "lattice_target" {
    value = "${module.lattice-aws.lattice_target}"
}

output "lattice_username" {
    value = "${module.lattice-aws.lattice_username}"
}

output "lattice_password" {
    value = "${module.lattice-aws.lattice_password}"
}

