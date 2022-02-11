#Terraform Jenkins

####Deploy a Jenkins instance via terraform

##Steps

* Run Aws configure with your access key and secret key Or add it to your provider settings
* Run the terraform code using terraform apply --auto-approve
* At the very end you'll see "aws_instance.jenkins (remote-exec): <token>" just above Creation Complete. This token is what you'll use for your initial password
* On your browser hit the ec2 instance url at port 8080 to bring up jenkins.
