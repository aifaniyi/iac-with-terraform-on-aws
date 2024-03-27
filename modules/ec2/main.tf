resource "aws_instance" "web_instance_1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.instance_subnet
  vpc_security_group_ids      = [var.instance_security_group]
  associate_public_ip_address = true

  #   key_name      = "MyKeyPair"

  user_data = <<-EOF
  #!/bin/bash -ex
  
  sudo apt update && sudo apt install nginx
  echo "<h1>$(curl https://api.kanye.rest/?format=text)</h1>" >  /usr/share/nginx/html/index.html
  EOF

  tags = {
    "Name" : "Web server front end"
  }
}
