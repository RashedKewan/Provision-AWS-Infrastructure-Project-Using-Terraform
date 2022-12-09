provider "aws"{
    
    region     = "eu-central-1"
    access_key = "YOUR ACCESS KEY"
    secret_key = "YOUR SECRET KEY"
}









###################################################################################################


# 1.create vpc
# Resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "vpc" {
    cidr_block       = "10.0.0.0/16"
    tags             = {
        Name         = "vpc-terraform"
    }
}



###################################################################################################


# 2.create Internet Gateway
# Resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-terraform"
  }
}


###################################################################################################



# 3.create Custom Route Table
# Resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "rtbl_a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.igw.id
    }
  tags = {
    Name = "rtbl_a"
  }
}




###################################################################################################




# 4.create subnet
# Resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "subnet_public_a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
  tags       = {
    Name     = "subnet_public_a"
  }
}



###################################################################################################




# 5.Associate subnet with route table
# Resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_public_a.id
  route_table_id = aws_route_table.rtbl_a.id
}




###################################################################################################

# 6.create security groupe to allow ports 22,80,443
# Resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]   # any TCP traffic
  }

    
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]   # any TCP traffic
  }

  
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]   # any TCP traffic
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"            # any protocol
    cidr_blocks      = ["0.0.0.0/0"]
  
  }

  tags = {
    Name = "allow_web"
  }
}



###################################################################################################

# 7.create network interface
# Resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface
resource "aws_network_interface" "web_server_nic" {
  subnet_id       = aws_subnet.subnet_public_a.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}


###################################################################################################

# 8. Assign an elastic IP to the network interface created in step 7
# Resource : https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "one" {
 
    vpc                        = true
    network_interface          = aws_network_interface.web_server_nic.id
    associate_with_private_ip  = "10.0.1.50"
    depends_on = [
      aws_internet_gateway.igw # we want to specify the whole object not just its id.
    ]
}


###################################################################################################


# 9. Create Ubuntu server and install / enable apache2

resource "aws_instance" "web_server_instance" {
    ami = "ami-06ce824c157700cd2"
    instance_type = "t2.micro"
    availability_zone = "eu-central-1a"
    
    key_name  = "rasheeds_key"
    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.web_server_nic.id
    }

    # NOTE : User_data is run only at the first start up.
    # Execute the bellow script on instance initialization
    user_data = <<-EOF
                    #!/bin/bash
                    sudo apt update -y
                    sudo apt install apache2 -y
                    sudo systemctl start apache2
                    sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                    EOF
    tags = {
        Name = "web-server"
    }
}

