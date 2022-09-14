STEPS
 add local data in main file
add providers 
create vpc and security groups mainly openning ports 8080 and 22 443
provide aws instance reources
through provisioner [
remote-exec used  to work inside the ec2 instance to getting instance ip and local key and send to the local user 
in local-exec we run commands to install jenkins inside ec2 using the data taken from remote-exec and run playbooks inside that
and the play book    installl required packages what we provided in that and shows the password which is in the path of cat /var/lib/jenkins/secrets/initialAdminPassword
]