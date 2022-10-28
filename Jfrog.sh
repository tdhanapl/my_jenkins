#############################Jfrog Artifactory Installation###########################################################
##site
#https://medium.com/globant/jfrog-artifactory-integration-with-ci-cd-jenkins-5c5228471642
##pipeline syntax 
#https://www.jfrog.com/confluence/display/JFROG/Declarative+Pipeline+Syntax
##Installation Steps
#Pre-requisites:
->An AWS T2.small EC2 instance (Linux)
->Open port 8081 and 8082 in the security group
#Login to instance as a root user and install Java
yum install java-1.8* -y 
->Download Artifactory packages onto /opt/
->For refernces puporse of download link of Jfrog https://jfrog.bintary.com/artifactory/jfrog-artifactory-oss-6
cd /opt 
wget https://jfrog.bintray.com/artifactory/jfrog-artifactory-oss-6.9.6.zip
->extract artifactory tar.gz file

unzip jfrog-artifactory-oss-6.9.6.zip
->Go inside to bin directory and start the services
cd /opt/jfrog-artifactory-oss-6.9.6/bin
./artifactory.sh start
#Access artifactory from browser
->http://<PUBLIC_IP_Address>:8081 
# Provide credentials
username: admin
password: passwrod 
->Create new user 
->click admin->click user->click new
->uersname=jenkins->email address=jenkins@gmail.com->mark admin previlage->mark can update profile->set-password=redhat
##create repository
->click maven repository
->Repository key: development-repositor
->repository layout: maven-2-deafult
->checksumpolicy: verfiy against client checksums
->maven snpahot version:unique
->click save and finish
After create repository here  dispaly five file
1. lib-snapshot-local
2. lib-release-local--it store our artifactory(jar,war) 
3. jcenter--it store all thrid dependency
4. libs-snapshot-local--it store the snapshot of version
5. lib-release--it store the dependency
--------------
we use aglie methodology and we work on weekly  base sprintes. now currently I am working on git, docker,  jenkins, docker, Ansible and AWS.
while come to role and reposbility.
1. In git--creating branches, PR merging, resolving merge conflict, creating repo, providing branch permission.
2. In jenkins--creating  pipeline job, managing job as per requriment, taking backup of home directoy of jenkins.
3. creating dockerfile as per requriment.
4. working ansible playbooks and ad-hoc command like user managment, patch, crating lvm, stop service and stoping service, installing packages.
5. IN AWS I am working on  EC2, ALB,IAM,  autoscaling, route53, snapshot, EBS, natgateway, vpc peering.