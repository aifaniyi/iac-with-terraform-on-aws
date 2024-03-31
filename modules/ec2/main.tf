resource "aws_instance" "web_instance_1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.instance_subnet
  vpc_security_group_ids      = [var.instance_security_group]
  associate_public_ip_address = true

  #   key_name      = "MyKeyPair"

  user_data = <<-EOF
  #!/bin/bash -ex
  
  sudo apt update && sudo apt -y install nginx cloud-utils
  sudo echo "<h1>instance: $(ec2metadata --instance-id)</h1><h1>$(curl https://api.kanye.rest/?format=text)</h1>" > /var/www/html/index.nginx-debian.html
  EOF

  tags = {
    "Name" : var.instance_name
  }
}
