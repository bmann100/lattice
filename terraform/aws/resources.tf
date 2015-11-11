resource "aws_eip" "ip" {
    instance = "${aws_instance.lattice-brain.id}"
    vpc = true
    connection {
        host = "${aws_eip.ip.private_ip}"
        user = "${var.aws_ssh_user}"
        key_file = "${var.aws_ssh_private_key_file}"
    }
    provisioner "remote-exec" {
        inline = [       
          "sudo sh -c 'echo \"SYSTEM_DOMAIN=${aws_eip.ip.private_ip}.xip.io\" >> /var/lattice/setup/lattice-environment'",
          "sudo restart receptor",
          "sudo restart trafficcontroller"
        ]   
    }
}

resource "aws_instance" "lattice-brain" {
    ami = "${lookup(var.aws_image, var.aws_region)}"
    instance_type = "${var.aws_instance_type_brain}"
    ebs_optimized = true
    key_name = "${var.aws_key_name}"
    subnet_id = "${var.aws_subnet_id}"
    security_groups = [
        "${var.aws_security_group}",
    ]
    tags {
        Name = "lattice-brain"
    }

    connection {
        user = "${var.aws_ssh_user}"
        key_file = "${var.aws_ssh_private_key_file}"
    }

    provisioner "local-exec" {
        command = "${path.module}/../scripts/local/get-lattice-tar \"${var.lattice_tar_source}\""
    }

    provisioner "file" {
        source = ".terraform/lattice.tgz"
        destination = "/tmp/lattice.tgz"
    }

    provisioner "file" {
        source = "${path.module}/../scripts/remote/install-from-tar"
        destination = "/tmp/install-from-tar"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo mkdir -p /var/lattice/setup",
            "sudo sh -c 'echo \"LATTICE_USERNAME=${var.lattice_username}\" > /var/lattice/setup/lattice-environment'",
            "sudo sh -c 'echo \"LATTICE_PASSWORD=${var.lattice_password}\" >> /var/lattice/setup/lattice-environment'",
            "sudo sh -c 'echo \"CONSUL_SERVER_IP=${aws_instance.lattice-brain.private_ip}\" >> /var/lattice/setup/lattice-environment'",

            "sudo chmod 755 /tmp/install-from-tar",
            "sudo /tmp/install-from-tar brain",
        ]
    }
}

resource "aws_instance" "cell" {
    depends_on = ["aws_eip.ip"]
    count = "${var.num_cells}"
    ami = "${lookup(var.aws_image, var.aws_region)}"
    instance_type = "${var.aws_instance_type_cell}"
    ebs_optimized = true
    key_name = "${var.aws_key_name}"
    subnet_id = "${var.aws_subnet_id}"
    security_groups = [
        "${var.aws_security_group}",
    ]
    tags {
        Name = "cell-${count.index}"
    }

    connection {
        user = "${var.aws_ssh_user}"
        key_file = "${var.aws_ssh_private_key_file}"
    }

    provisioner "local-exec" {
        command = "${path.module}/../scripts/local/get-lattice-tar \"${var.lattice_tar_source}\""
    }

    provisioner "file" {
        source = ".terraform/lattice.tgz"
        destination = "/tmp/lattice.tgz"
    }

    provisioner "file" {
        source = "${path.module}/../scripts/remote/install-from-tar"
        destination = "/tmp/install-from-tar"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo mkdir -p /var/lattice/setup",
            "sudo sh -c 'echo \"CONSUL_SERVER_IP=${aws_instance.lattice-brain.private_ip}\" >> /var/lattice/setup/lattice-environment'",
            "sudo sh -c 'echo \"SYSTEM_DOMAIN=${aws_eip.ip.private_ip}.xip.io\" >> /var/lattice/setup/lattice-environment'",
            "sudo sh -c 'echo \"LATTICE_CELL_ID=cell-${count.index}\" >> /var/lattice/setup/lattice-environment'",
            "sudo sh -c 'echo \"GARDEN_EXTERNAL_IP=$(hostname -I | awk '\"'\"'{ print $1 }'\"'\"')\" >> /var/lattice/setup/lattice-environment'",

            "sudo chmod +x /tmp/install-from-tar",
            "sudo /tmp/install-from-tar cell",

            "sudo tar cf /var/lattice/garden/graph/warmrootfs.tar /var/lattice/rootfs",
            "sudo rm -f /var/lattice/garden/graph/warmrootfs.tar"
        ]
    }
}
