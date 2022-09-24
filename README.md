Introduction

We will automate the task of setting up Wordpress server with the help of a configuration management tool like Ansible. We will have a standard installation procedure for WordPress and its components. This will reduce the workload/manual operations and draw a standard line of process. Which will continue to help us when a new requirement or client comes in. On top of that the process will be documented and additional changes/amendments will be possible in the code on the basis of requirement. Since the resource creation, provisioning and configuration is documented in the code itself.
We will be including the below mentioned components in our setup:
• PHP
• Apache2
• MySQL
• WordPress
Index
- [1] Prerequisites
- [2] Configurations
- [3] Terraform script
- [4] Ansible playbook
- [5] Git Push
- [6] Init, Plan + Apply
- [7] Wordpress ready - Conclusion


[1] Pre-requisites

We will need to make sure that we are equipped with the right components before working on the project.

[1.1] Basic requirements
1. Linux x86_64 system - Any linux system, however, we will demonstrate on Ubuntu.
2. AWS account - Any cloud service account however, we will demonstrate the steps as per
AWS and writing the code focused on AWS platform.

[1.2] Below are the packages that we want installed into our Linux system, check their availability using these commands:
• Git
$ git —version
• Python
$ python3 —version
• Terraform
$ terraform —version
• Ansible
$ ansible —version


[2] Configurations

[2.1] Git configuration
1. Setup GitHub account, sign in if already a user, else create a new account using signup section.
2. Create a repository to manage our code - Terraform as well as Ansible. Navigate to repository > Click on New > Name the repository and create it. (I am naming it ‘Terraform- ansible_wordpress’)
3. Copy the https code by clicking on the clone button.
4. Clone the repository on your system using the git clone command. 
$ git clone [paste the copied code here]
5. This will create a directory for this specific repository.
6. $ cd [directory name] and move to the directory created by cloning the repository.

[2.2] AWS keys
1. Login to AWS account, or create one if not available.
2. Navigate to EC2 section > under the Network & Security select Key pairs, or key pairs section displayed on the EC2 Dashboard
3. This will open key pair section, all the created keys can be found here.
4. Click on create key pair to create a new key pair (see the figure below)
5. Name the key pair, select .pem format and RSA as key type. (Setting wpkey as the key name here)
6. Click on create key pair to create it and the system will automatically download the key pair.
7. Change the permission of the key using $ chmod 400 [key-path]

[2.3] VPC ID (AWS)
1. Login to AWS account,
2. Navigate to VPC section > click on VPCs section on the VPC dashboard to open the VPC panel.
3. Simply copy the VPC ID from here.

[2.4] AWS API credentials
1. GO to AWS IAM - Identity and access management
2. Get the keys
3. Create the user, provide admin previledges and copy the keys. 
4. You will need all three information: 
       a. Access key
       b. Secret key
       c. Token

[2.5] AMI id (AWS)
1. Login to AWS account
2. Navigate to EC2 section > under the images section > click on AMI catalog
3. Here, we will see the available instances and their AMI ids
4. Copy the AMI ID for the choice of image. (We will use the AMI for Ubuntu)


[3.0] Terraform script

As the title suggests, we will first need a terraform script to provision resources on our AWS cloud.
Navigate to the cloned repository (see [2.1])

$ cd Terraform-ansible_wordpress
Now, let’s start with writing a terraform main.tf script
$ nano main.tf

Created main.tf
Make the changes to this file as per your requirements, each segment has been marked with comments section to provide more information. 

/* Start with replacing the local variables, which will be used throughout the
script ami-id of the instance (see [2.5]), use VPS (see [2.3]), key_name (see
[2.2]) and key_path (see [2.2]) */

/* Declare the provider and other required information linked with it, access
key, secret key and token as per AWS (Or any cloud provider you are using)
(See [2.4]) */


[4.0] Ansible Playbook

The main playbook is initiate.yml, you can make changes to the YAML file as per your configuration requirements. 
All segments have been linked with comments to help understand the task or a configuration. 

[4.2] default.yml
Now, navigate to the vars directory, so that we can create the default.yml file. $ cd vars

$ nano default.yml

#These is a default var file, this will store all our default variables for this
play. You may make changes.

1. php_modules: An array containing PHP extensions that should be installed to support your WordPress setup. You don’t need to change this variable, but you might want to include new extensions to the list if your specific setup requires it.
2. mysql_root_password: The desired password for the root MySQL account.
3. mysql_db: The name of the MySQL database that should be created for WordPress.
4. mysql_user: The name of the MySQL user that should be created for WordPress.
5. mysql_password: The password for the new MySQL user.
6. http_host: Your domain name.
7. http_conf: The name of the configuration file that will be created within Apache.
8. http_port: HTTP port for this virtual host, where 80 is the default.

[4.4] Wordpress-php-config

$ cd files
$ nano wp-config.php.j2

/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 */
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */



[6.0] Init, Plan and Apply

Everything is updated now. We can run main.tf using terraform, which will automatically run the ansible-playbook (see [3.0]).
$ terraform apply
$ terraform validate
$ terraform plan
$ terraform apply

  (we are using —auto-approve, so we are not required to enter yes when it prompts)


[7.0] Wordpress ready - Conclusion

Now that Terraform and Ansible has completed resource creation, provisioning and configuring the remove system, we are able to access Wordpress server through the public Ip.

In future, we can continue using the terraform script along with the Ansible-playbook to allocate resources and configuring systems, which will help us setup a Wordpress server. 

We can edit the playbook as well as terraform main.tf file as per the requirements for further use

 
