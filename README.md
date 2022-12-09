# *Provision AWS Infrastructure Using Terraform*
<img width="932" alt="image" src="imgs/terraform_aws.png">


 ## *Provision AWS Infrastructure Project Using Terraform.*
 ## *In This Project I Had Implemented The Following:* 
 
> 1. Create vpc

> 2. Create Internet Gateway

> 3. Create Custom Route Table

> 4. Create a Subnet

> 5. Associate subnet with Route Table

> 6. Create Security Group to allow port 22, 80, 443

> 7. Create a network interface with an ip in the subnet that was created in step 4

> 8. Assign an elastic IP to the network interface created in step 7

> 9. Create Ubuntu server and install / enable apache2


 

## *Requirements:*
- Terraform Installation
- AWS Account
- VS Code

Clone Project
```shell
  git clone https://github.com/RashedKewan/Provision-AWS-Infrastructure-Project-Using-Terraform.git
```


## *To get your access key ID and secret access key*
1. Open the IAM console at
  https://console.aws.amazon.com/iam/.
2. On the navigation menu , choose Users.
3. Choose your IAM user name ( not the check box ).
4. Open the Security credentials tab , and then choose Create access key .
5. To see the new access key, choose Show. Your credentials resemble the following :
    
    • `Access key ID`: AKIAIOSFODNN7EXAMPLE

    • `Secret access key` : wJalrXUtnFEMI/K7MDENG/bPXRficYEXAMPLEKEY
6. To download the key pair, choose Download .csv file. Store the .csv file with keys in a secure location .

```HCL
provider "aws"{
    
    region     = "eu-central-1"
    access_key = "AKIAIOSFODNN7EXAMPLE"
    secret_key = "wJalrXUtnFEMI/K7MDENG/bPXRficYEXAMPLEKEY"
}
```
## *To Get Your Region*
<img width="932" alt="image" src="imgs/region.png">

## *Run The Terraform File*


- ### *Open Terminal:*
- ### *Init terraform:*
> `terraform` init

- ### *Plan Your Terraform Projec:*
> `terraform` plan 

- ### *Apply Your Terraform Projec:*
> `terraform` apply 

- On the serch bar, search for `EC2`, then select it.
- On the menu in the left pageside , open `instances`, then select  `instances`.
- On the *Instances table* select the instance with `Name` : web-server.

`NOTE` : Make sure your **instance state** is `Running`
<img width="932" alt="image" src="imgs/web-server-instance.png">

- Then click on > `open address`.

<img  alt="image" src="imgs/open-address.png">

## Web-Server
<img width="932" alt="image" src="imgs/connecting-to-apache.png">

#

> 1. Create vpc

<img width="932" alt="image" src="imgs/vpc.png">

#


> 2. Create Internet Gateway

<img width="932" alt="image" src="imgs/igw.png">

#


> 3. Create Custom Route Table

<img width="932" alt="image" src="imgs/rtbl.png">

#


> 4. Create a Subnet

<img width="932" alt="image" src="imgs/subnet.png">

#


> 5. Associate subnet with Route Table

<img width="932" alt="image" src="imgs/rtbl_sbnt.png">

#


> 6. Create Security Group to allow port 22, 80, 443

<img width="932" alt="image" src="imgs/security_group.png">

#


> 7. Create a network interface with an ip in the subnet that was created in step 4

<img width="932" alt="image" src="imgs/nic.png">

#


> 8. Assign an elastic IP to the network interface created in step 7

<img width="932" alt="image" src="imgs/eip.png">

#

> 9. Create Ubuntu server and install / enable apache2

<img width="932" alt="image" src="imgs/web-server-instance.png">





