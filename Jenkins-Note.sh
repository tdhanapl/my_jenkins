#######################Configuration ##############################
jenkins server login deatils
username=ec2-user
pass=ikt@123
###Home directory for jenkins
By default, Jenkins stores all of its data in this directory on the file system
$ ll /var/lib/jenkins

##what is Continuous Integration,Continuous delivery,and Continuous Deployment.
#Continuous Integration (CI)
It  is a software engineering practice in which developers integrate code into a shared repository several times a day in order to obtain rapid feedback of the feasibility of that code. CI enables automated build and testing so that teams can rapidly work on a single project together.

#Continuous delivery (CD) 
It is a software engineering practice in which teams develop, build, test, and release software in short cycles. It depends on automation at every stage so that cycles can be both quick and reliable.

#Continuous Deployment
It  is the process by which qualified changes in software code or architecture are deployed to production as soon as they are ready and without human intervention.

##security tools:
1.Veracode--source code scan
2.trivy-image-scan--docker image scan
3. codcay--source code scan

##pipeline
1.tools
2.agent
3.stage(git checkout)
4.stage(SonarQube analysis and Quality gate check)
5.stage(source code bulit)
6.stage(deploy artifact to jfrog/nexu/s3 bucket)
8.stage(Bulid docker image with artifact and push to jfrog/s3 bucket) 
9.stage(identifying misconfigs using datree in helm charts)
10.stage(pushing the helm charts to jfrog/s3)
11.stage(manual approval for deploy in k8s development/pre-production environment)
12.stage(Deploying application on k8s eks cluster)
13.post{
        always {
            junit '**/target/*.xml'
        }
        failure {
            //mail to: team@example.com, subject: 'The Pipeline failed :('
        }
		sucess {
			// mail to: dhanapal703278@gmail.com, subject: The Pipeline sucess 
		}
    }
## Requried plugin
1. File system scm plugin---->Filesystem Checkout
2. SonarQube scanner plugin for jenkins--->SonarQube integration
3.JaCoCo plugin----> JaCoCo code coverage
4. Nexus Platform Plugin----->Nexus repository for storing repository
5. Email Extension Plugin----> Email Intergation
6. Deploy to container plugin--->Deploy to tomcat
7. Docker Pipeline---->Build and use Docker containers from pipelines.
8. Docker plugin--->This plugin integrates Jenkins with Docker
9. S3 publisher plugin---> upload artifacts to s3
10 SonarScanner-->For test code 
11 Amazon ECR plugin--->This plugin generates Docker authentication token from Amazon Credentials to access Amazon ECR.
12.Nexus Artifact Uploader--->This plugin to upload the artifact to Nexus Repository.
13.Nexus Platform Plugin--->This plugin integrates Sonatype Nexus to Jenkins.
14. Pipeline Utility StepsVersion--->Utility steps for pipeline jobs.
Note: This above plugin is required for nexus artifact upload
14.kubernetes--->This plugin integrates Jenkins with Kubernetes
15. git, Build Timestamp Plugin, Build Timeout, Credentials, Pull Request Builder, Docker Pipeline, Email Extension,github,
   pipeline, maven, artifact, Role-based Authorization Strategy, bule ocean, input, kubernetes deploy, helm.	

#################integarting with jenkins########################
1. git-> jenkins(git-webhook, git pollscm)
2. sonarqube-> jenkins(we pom.xml in properties tag )
3. jfrog-> jenkins(we mention jfrog details under dependency jfrog repository details)

##vsersion
#jenkins requried java version = 1.18
#jenkins version=2.300
#kubernetes version=1.19
#ansible version=2.10
#git=2.30

########################################Installation  maveen##############################
$ cd /opt
$ wget  https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
$ tar -xzvf apache-maven-3.8.6-bin.tar.gz
$ mv apache-maven-3.8.6 maven
$ cd maven
$ cd bin
$ ./mvn --version
##temporary update the binary 
$ export PATH=$PATH:/opt/maven/bin
$ echo $PATH
##permanent update the binary 
$ cd /etc/profile.d/ ##it will update for all user 
$ vim maven.sh
	#!/bin/bash
	export PATH=$PATH:/opt/maven/bin
	:wq!
$ chmod 755 /etc/profile.d/maven.sh
$ echo $PATH
$ bash
$ echo $PATH
	or 
$ vim .bash_profile ##it will update for  particular user only 
export M2_HOME=/opt/maven/bin    
export PATH=$PATH:$M2_HOME
:wq!
$ bash
mvn --version

######################configure maven in jenkins#############
##this use for if it required to bulid in par version only on that time we can add  that version
#we bulid with particular version
->Now go to jenkins 
->manage jenkins->Global Tool Configuration
->Maven installations
List of Maven installations on this system
->Maven
->Name= maven-3.8.5 (label name of maven ) #3.8.5 is version
->MAVEN_HOME= /opt/maven/ #/opt/maven/ home of maven path  and/opt/maven/bin path variables
->click save
-> click apply
###add one more maven version 
->Now go to jenkins 
->manage jenkins->Global Tool Configuration
->Maven(under)
->click add
->Name= maven-3.8.4 (label name of maven ) #3.8.4 is version
->MAVEN_HOME= /opt/maven/ #/opt/maven/ home of maven path  and/opt/maven/bin path variables
->click save
-> click apply

#####################Integrate Your GitHub Repository to Your Jenkins Project##################################
Configuring GitHub
Step 1: go to your GitHub repository and click on ‘Settings
Step 2: Click on Webhooks and then click on ‘Add webhook’.
Step 3: In the ‘Payload URL’ field, paste your Jenkins environment URL.
 ->At the end of this URL add /github-webhook/. 
 Payload URL= https://13.127.199.143:8080/github-webhook
step 4:
->In the ‘Content type’ select: ‘application/json’ and leave the ‘Secret’ field empty.
Step 5: 
Which events would you like to trigger this webhook?
Just the push event.
->mark Send me everything.
In the page ‘Which events would you like to trigger this webhook?’ choose ‘Let me select Send me everything.’ Then, check ‘Pull Requests’ and ‘Pushes’. 
At the end of this option, make sure that the ‘Active’ option is checked and click on ‘Add webhook’.
###Configuring from  Jenkins side
Step 5: In Jenkins, click on ‘New Item’ to create a new project.
Step 6: Give your project a name, then choose ‘Pipeline’ and finally, click on ‘OK’.click pipeline project->click build trigger-
------->mark github hook trigger for GITSCM polling----->click apply.

################################Jenkins master--Slave configuration######################
#adding agent with Launch method via Launch agents via SSH
#create ssh keygen pair
$ ssh-keygen
$ cd ./ssh/
	--here dispaly id_rsa, id_rsa.pub, authorized_keys and hosts_knowns
#copy the public keys to remote server
$ ssh-copy-id -i /dhana/.ssh/id_rsa.pub dhana@192.168.1.6

->In a production environment, there are lot and lot of builds need to run in parallel. This is the time Jenkins slave nodes come into the play. We can run builds in separate Jenkins slave nodes. This will reduce build overhead to the Jenkins master and we can run build in parallel. This article contains in the step by step guide to add Jenkins slave node. This step by step guide will help you to add any flavour of Linux machine as a Jenkins slave node. If you haven’t still install Jenkins Master server read this article “Install Production Jenkins on CentOS 7 in 6 Steps”.
Prepare Slave nodes
->Before adding a slave node to the Jenkins master we need to prepare the node. We need to install Java on the slave node. Jenkins will install a client program on the slave node. To run the client program we need to install the same Java version we used to install on Jenkins master. I am going to use this slave node to build Java Maven project. Therefore I need to install Maven as well. According to your production environment, you need to install and configure the necessary tool in the slave node.
->Install OpenJDK 8 on the slave node.
# sudo yum install -y java-1.8.0-openjdk
-> install apache maven on the slave node. You can download the Apache Maven from their official site.
# mkdir -p build/software/maven/
$ wget https://www-eu.apache.org/dist/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.tar.gz 
###For maven installatin refer above steps 
##On  both server of master and node put PasswordAuthentication yes
$ vim /etc/ssh/sshd_config
PasswordAuthentication yes
$ systemctl restart sshd
#Configure ssh connectivity from master to slave node 
#Log in to the Jenkins master node and create an ssh key-pair. Use the below command to create the key-pair
$ ssh-keygen
$ cat .ssh/id_rsa.pub
Now copy of master node  .ssh/id_rsa.pub file  to slave node of these .ssh/authorized_keys 
Copy the content and log in to the slave node. Add the copied content to authorized_keys.
# vim .ssh/authorized_keys
->From the master ssh to the slave node. It will ask to accept the ssh fingerprint, type yes and enter. 
If you haven’t done anything wrong you should be able to ssh into the slave node.
		or copy of ssh keys with command
$ ssh-copy-id  -i /root/.ssh/id_rsa <username@10.10.1.173>
	---this way we can copy ssh private keys
##Now in jenkins
->Adding the slave node to the master
->Log in to the Jenkins console via the browser and click on "Manage Jenkins" and scroll down to the bottom. From the list click on "Manage Nodes". In the new window click on "New Node".
->Add new node
->Give a name to the node, select Permanent Agent and click on OK
->Jenkins Slave Node name
->In the remote root directory field enter a path in the slave node. Note that ssh user must have read/write access to this directory path. Here I use the ssh uses home directory.
->Enter the slave nodes IP address in the field.
->Set IP and cre
->Click on the "Add" button near the credentials field.
->Jenkins will popup a new window to add credentials. 
->Select the kind as "SSH Username with private key" from the drop-down. 
->Enter the user name of the slave node. In the private key field add the Jenkins masters private key. 
->You can find the private key with the below command,
->Add new credentials to the Jenkins
#cat /home/centos/.ssh/id_rsa
->Click on add and select the credentials we created from the drop-down. Click on save. If you did all the correct slave node will come to live state within a few seconds.
->Slave node list
->Troubleshooting
->You can click on the slave node and from there you can view the log. Fix any error shown in the log
-------

##########pipeline running in slave node###########
-----
pipeline{
    agent any
    tools {
        maven 'maven123'
    }
    stages{
        stage('Checkout') {
            steps {
                git 'https://github.com/dhanapal703278/maven.git'
            }
        }
        stage('Build') {
            steps {
                sh "mvn --version"
                sh "mvn clean install -DskipTests" //DskipTests-it skip tests in this stage
            }
        }
        stage('Test') {
            steps {
                sh "mvn test" //here we are running the tests in this stage
                junit allowEmptyResults: true, testResults: 'target/surefire-reports-/*.xml'
                jacoco()
            }
        }
        
        stage('Post tasks') {
            steps {
                sh "echo send an email"
            }
        }
    }
}

##########pipeline running on docker of another agent machine###########
###build docker image with java, git, maven
$ vim  Dockerfile 
FROM ubuntu
LABEL owner="dhanapal"
LABEL Description="creating image with git, maven, java for docker-jenkins-slave"
RUN  apt update -y \
     && apt   install git -y \
     && apt install wget -y \
     && apt install openjdk-11-jdk -y \
     && cd /opt \
     && wget  https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz \
     && tar -xvf apache-maven-3.8.5-bin.tar.gz \
     && rm -rf apache-maven-3.8.5-bin.tar.gz  \
     && mv apache-maven-3.8.5  maven \
     && ln -s /opt/maven/bin/mvn /usr/bin/mvn \
     && export PATH=$PATH:/opt/maven/bin \
     &&  echo $PATH
CMD  ["mvn", "--version"]
:wq

$docker build --tag docker_with_java_git_maven-3.8.5 .
$ docker image tag docker_with_java_git_maven-3.8.5 dhanapal406/jenkins_java_git_maven-3.8.5
$ docker push dhanapal406/jenkins_java_git_maven-3.8.5

--->In Pugins we need install "Docker Pipeline" in jenins

###multi stage docker file  to reduce image size

###########run pipeline in do
pipeline{
    agent {
        docker { 
            image 'dhanapal406/jenkins_java_git_maven-3.8.5' //docker image 
            label 'docker-node' //agent label
			args '-v /home:/tmp'
			//args '--name maven-docker'
			alwaysPull true
        }
    }
	tools {
        maven 'maven123'
    }
    options {
        //discardbuilds 
        buildDiscarder logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '10', daysToKeepStr: '5', numToKeepStr: '5')
        
    }
    stages{
        stage('Checkout') {
            steps {
                git 'https://github.com/dhanapal703278/maven.git'
            }
        }
        stage('Build') {
            steps {
                sh "mvn --version"
                sh "mvn clean install"
            }
        }
    }
}

//optional add in docker agent (adding addtional)
//agent {
  //docker {
    //alwaysPull true
    //customWorkspace '/root'
    //image 'dhanapal406/jenkins_java_git_maven-3.8.5'
    //label 'docker-node'
    //registryCredentialsId 'username=dhana, password=ikt@406'
    //reuseNode true
  }
}



############################################SonarQube intergration with jenkins################################################################
#######installation of Sonarqube
##https://www.jenkins.io/doc/pipeline/steps/sonar/
#do not all this things with root and created separate username as sonaruser
$ wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.6.50800.zip
$ apt install unzip 
$ unzip sonarqube-8.9.6.50800.zip
$ ls -lrt
$ cd sonarqube-8.9.6.50800
$ ls	-lrt
$ cd conf/
$ ls -lrt
$ vi sonar.properties
sonar.jbc.username=sonarqube
sonar.jbc.password=sonarqube
#sonar.embeddedDatabase.port=we are database port mysql or postgreql
#web server
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.context=/sonarqube
:wq
$ vi wrapper.conf
wrapper.java.command=/usr/lib/jvm/java-8-openjdk-amd64/bin/java
:wq
$cd bin 
$ cd linux-x86-64
$ ls -lrt
./sonar.sh console
go website
->this url=3.104.45.3:9000/sonarqube
 uersname=admin default
 password=admin default
 oldpassword=admin
 newpassword=ikt@406
 confirm password=ikt@406
 #now go to SonarQube server to create token
 -->click Administartor->security->users->click tokens->Generate tokens=jenkins->generate->copy that token
 #Now goto jenkins continue to before part
-->click add(jenkins credintaials)->domain =global credentails->kind=secret text(select)
-->secret=eadb7c27fda4dd57981197bb761e97e5d3d63712 paste the copied sonarqube token->Descrition=jenkins->save---
-->authication=Sonarjenkins->apply.
 ######Now go to jenkins 
 -->manage jenkins->manage plugins->sonarqube(search available)->sonarqube scanner(select)->install(without restart)
 
 -->Again to manage jenkins->configure system->SonarQube Server->mark Environment variables->Add SonarQube->Name=Sonarjenkins->
 -->Server Url=url=3.104.45.3:9000/sonarqube(SonarQube url add /sonarqube in url)---
 
####pipeline with sonarqube#####
 pipeline {
        agent any
        tools {
            maven 'maven123'
        }
        stages {
            stage('Checkout'){
                steps {
                    git 'https://github.com/dhanapal703278/maven.git'
                }
            }
            stage('Build with maven') {
                steps {
                    mvn clean install
                }
            }
            
            stage("build & SonarQube analysis") {
                steps {
              withSonarQubeEnv('My SonarQube Server') {
                sh 'mvn clean package sonar:sonar'
                //sh '''mvn sonar:sonar \\
                //-Dsonar.projectKey=maven-jenkins-pipeline \\
                //-Dsonar.host.url=http://13.126.108.209:9000/'''
                }
            }
          }
          
        }
        post{
            always {
              deleteDir()  
            }
            failure{
              mail bcc: '', body: 'test is failled', cc: '', from: '', replyTo: '', subject: 'Test  results', to: 'dhanapal703278@gmail.com' 
            }
            sucess {
                mail bcc: '', body: 'test is sucess', cc: '', from: '', replyTo: '', subject: 'Test  results', to: 'dhanapal703278@gmail.com'
                
            }
        }
}
		
 ##In pipeline if quality gate sucess then only  it move to next stage else it fail next stage job in pipeline
 #now go to SonarQube server to create quality gate

->click Administartor->click configuration->click webhook create
->Name= sonarqube-jenkins
->URL= <http://jenkins url:8080/sonarqube-webhook/>
->scerts= leave deafult
->click create

##########pipeline for sonarqube quality gate
pipeline {
        agent any
        tools {
            maven 'maven123'
        }
        stages {
            stage('Checkout'){
                steps {
                    git 'https://github.com/dhanapal703278/maven.git'
                }
            }
            stage('Build with maven') {
                steps {
                    mvn clean install
                }
            }
            
            stage("build & SonarQube analysis") {
                 steps {
                     withSonarQubeEnv(credentialsId: 'Sonnar-token') {
                        \\sh 'mvn clean package sonar:sonar'
                        sh "mvn sonar:sonar \
                        -Dsonar.projectKey=maven-jenkins-pipeline \
                        -Dsonar.host.url=http://13.126.108.209:9000/"
                        }
                    }
            }
            stage("Quality Gate") {
                steps {
                    timeout(time: 1, unit: 'HOURS') {
                        WaitForQualityGate abortPipeline: true
                        //waitForQualityGate abortPipeline: true, credentialsId: 'Sonnar-token'
                        }
                    }
            }
        }
        post{
            always {
              deleteDir()  
            }
            failure{
              mail bcc: '', body: 'test is failled', cc: '', from: '', replyTo: '', subject: 'Test  results', to: 'dhanapal703278@gmail.com' 
            }
            sucess {
                mail bcc: '', body: 'test is sucess', cc: '', from: '', replyTo: '', subject: 'Test  results', to: 'dhanapal703278@gmail.com'
                
            }
        }
}

############Publishing Artifacts to Nexus Repository using Jenkins Pipelines##########
--> Now go to your browser and open 
-->http://your-ip-addr:8081
-->The default username is admin, whereas to retrieve the password you need to run the following command:
-->cat /nexus-data/admin.password
502ace93-5450-4f0d-97d2-9b3b3a88d149
##Create a Repository in Nexus
-->In this step, you are going to create a Maven Hosted repository in Nexus, where your Jenkins is going to upload “build” artifacts.
##Step 1
-->Follow the below-mentioned steps to create a hosted repository, name it  maven-nexus-repo
-->Select maven2 (hosted) recipe from the list
##Step 2:
-->On the Create Repository page
-->Enter the name as maven-nexus-repo
-->In Version Policy, select the Mixed type of artifacts.
-->Under the Hosted section, in Deployment policy, select Allow redeploy or select not allow redeploy.  It will allow you to deploy an application multiple times or it will not allow application multiple times.
##Step 3:
-->To create a new user, go to Dashboard 
--> Server Administrator and Configuration > User > Create user. Select Local user type which happens to be the default Realm:
-->In the Create User page
-->ID: Enter the desired ID; in our case, it is jenkins-user.
-->First Name: Enter the desired first name; in our case, it is Jenkins.
-->Last Name: Enter the desired second name; in our case, it is User.
-->Email: Enter your email address.
-->Status: Select Active from your drop-down menu.
-->Roles: Make sure that you grant the nx-admin role to your user.
##With this, we are through with the setup part of Nexus Repository Manager. Let us move to Jenkins to setup Nexus there.
-->Install and Configure Nexus Plugins in Jenkins
-->Here you are going to install and configure a few plugins for Nexus in Jenkins.
-->Go to Jenkins-->Dashboard-->Manage Jenkins-->Manage Plugins > Available and search and install Nexus Artifact Uploader and Pipeline Utility Steps.
-->Add Nexus Repository Manager’s user credentials in Jenkins.
-->Go to Dashboard > Credentials > System > Global credentials (unrestricted)
##Create a Jenkins Pipeline
-->It’s time to create a Jenkins Job. Here you are going to use Pipeline job type, named as JenkinsNexus

##find the Pipeline section and copy the below-mentioned script in the text area:

pipeline {
    agent {
        label "master"
    }
    tools {
        maven "Maven"
    }
    environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "you-ip-addr-here:8081"
        NEXUS_REPOSITORY = "maven-nexus-repo"
        NEXUS_CREDENTIAL_ID = "nexus-user-credentials"
    }
    stages {
        stage("Clone code from VCS") {
            steps {
                script {
                    git 'https://github.com/javaee/cargotracker.git';
                }
            }
        }
        stage("Maven Build") {
            steps {
                script {
                    sh "mvn package -DskipTests=true"
                }
            }
        }
        stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }
    }
}

##Let’s break down the above-mentioned parameters bit by bit:
-->NEXUS_VERSION: Here, we have to mention the exact version of Nexus, which can be nexus2or nexus3 . In our case, it is latest version of nexus3 .
-->NEXUS_PROTOCOL: For this guide we have used HTTP protocol, although, in case of production, you will have to use HTTPS.
-->NEXUS_URL: Add your IP address and port number, where you are running Nexus. Make sure that you add Nexus instance details without mentioning protocols, i.e., https or http .
#-->NEXUS_CREDENTIAL_ID: Enter the user ID, which you previously created in Jenkins, which in our case is  nexus-user-credentials .
-->Project Git: Under stages, we used https://github.com/javaee/cargotracker
-->As you are through with the Pipeline set up, its time to Build our project. Go to the JenkinsNexus project job page and click Build Now. As this is your first build, it is going to take some time, so sit tight.

#################pushing the docker image through Jenkins into nexus###############
##Pre-requisite
-->We need to have Jenkins and nexus server up and running (by default Jenkins runs on 8080 and nexus at 8081)
-->On Jenkins host we need to install docker
-->Initial setup
-->In nexus click on gear button --> click on repositories --> click on create repository
-->once we click on create repository ( types of repository will be listed ) --> click on docker(hosted)
-->fill out the details in Name ( unique name ), enable checkbox beside to HTTP and enter a valid port ( preferred 8083 ) once that click on create repository
-->Once this set up is done in jenkins host we need to setup Insecure Registries. to do that we need to edit or if not present create a file /etc/docker/daemon.json in that file add details of nexus

{ "insecure-registries":["nexus_machine_ip:8083"] }
-->once that is done we need to execute systemctl restart docker this is to apply new changes, also we can verify whether registry is added or not by executing docker info
-->once this is done from jenkins host you can try docker login -u nexus_username -p nexus_pass nexus_ip:8083
###p##ipeline  of pushing the docker image through Jenkins into nexus###
pipeline{
    agent any 
    environment{
        VERSION = "${env.BUILD_ID}"
    }
    stages{
        stage("Clone code from VCS") {
            steps {
                script {
                    git 'https://github.com/javaee/cargotracker.git';
                }
            }
        }
        stage("Maven Build") {
            steps {
                script {
                    sh "mvn package -DskipTests=true"
                }
            }
        }
        stage("docker build & docker push"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_password')]) {
                             sh '''
                                docker build -t 34.125.214.226:8083/springapp:${VERSION} .
                                docker login -u admin -p $docker_password 34.125.214.226:8083 
                                docker push  34.125.214.226:8083/springapp:${VERSION}
                                docker rmi 34.125.214.226:8083/springapp:${VERSION}
                            '''
                    }
                }
            }
        }
        
    }

    post {
		always {
			mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "deekshith.snsep@gmail.com";  
		 }
	   }
}

############# build-docker image and push to docker-hub in pipeline #######
###Default Environment Variables by Jenkins 
Jenkins provides several environment variables by default like - BRANCH_NAME, BUILD_NUMBER, BUILD_TAG, WORKSPACE, etc.

####create credential in 
->Dashboard->click manage jenkins-> click manage Credentials
->Stores scoped to Jenkins(under)
->Jenkins
->Global credentials (unrestricted)->New credentials
->Kind= Username with password
->Scope= Global (Jenkins, nodes, items, all child items, etc)
->Username= dhanapal406(mark Treat username as secret)
->Password= •••••••••
->ID= docker_login
->Description= docker_login
->click create
###Dockerfile in github
$ vim Dockerfile
FROM tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT/
##/root/workspace/pipeline/webapp/target/java-tomcat-maven-example.war
##FRom this path copying of java-tomcat-maven-example.war
##default it take upto /root/workspace/pipeline
COPY webapp.war /usr/local/tomcat/webapps/ROOT/ 
RUN cd /usr/local/tomcat/webapps/ROOT && unzip java-tomcat-maven-example.war && \
    rm -rf /usr/local/tomcat/webapps/ROOT/java-tomcat-maven-example.war
EXPOSE 8080
CMD ["mvn", "run"]
#####username and password in pipeline
#DOCKER_LOGIN = credentials('docker_login')
1.DOCKER_LOGIN= is varible
2.docker_login= it is label we mentioned in  global credential 
3.$DOCKER_LOGIN_USR= it's username for login(USR)
4.$DOCKER_LOGIN_PSW= it's password for login(PSW)

pipeline {
    agent any
    stages {
        stage('Example Username/Password') {
            environment {
                DOCKER_LOGIN = credentials('docker_login')
            }
            steps {
                sh 'echo "Service user is $DOCKER_LOGIN_USR"'
                sh 'echo "Service password is $DOCKER_LOGIN_PSW"'
                sh 'docker login -u $DOCKER_LOGIN_USR -p $DOCKER_LOGIN_PSW'
            }
        }
        
    }
}

######stage level assign agent in this pipeline and ########
pipeline{
    agent none
    environment {
        DOCKER_LOGIN = credentials('docker_login')    
    }
	tools {
        maven 'maven123'
    }
    stages {
        stage ('Checkout and Build') {
            agent {
                docker {
                    image 'dhanapal406/jenkins_java_git_maven-3.8.5'
                    label 'docker-node'
					alwaysPull true
                    
                }
                
            }
            steps{
                git 'https://github.com/dhanapal703278/tomcat_maven_app.git'
                sh "mvn clean package"
            }
        }
        stage('Create  a images'){
            agent {
                label 'docker-node'
            }
            steps {
                sh """
                     //with above docker file we building the docker image
					 docker build -t dhanapal406/tomcat_sai-$BUILD_NUMBER .
                     docker login -u $DOCKER_LOGIN_USR -p $DOCKER_LOGIN_PSW
                     docker push dhanapal406/tomcat_sai-$BUILD_NUMBER
                     docker run -itd -p 8080:8080 -v /dhana:/l406/tomcat_sai-$BUILD_NUMBER
                """
            }
        }
    }
}


######################identifying misconfigs using datree in helm charts and Pushing the helm charts through jenkins into nexus########
##identifying misconfigs using datree in helm charts
###Datree Helm Plugin
A Helm plugin to validate charts against the Datree policy
##Installation
$ helm plugin install https://github.com/datreeio/helm-datree

##Update Datree's plugin version
$ helm plugin update datree
##Uninstall
$ helm plugin uninstall datree
Usage
##Trigger datree policy check via the helm CLI
helm datree test [CHART_DIRECTORY]
##Passing arguments
If you need to pass helm arguments to your template, you will need to add -- before them:

helm datree test [CHART_DIRECTORY] -- --values values.yaml --set name=prod
##Test files
By default, test files generated by Helm will be skipped. If you wish to include test files in your policy check, add the --include-tests flag:

helm datree test --include-tests [CHART_DIRECTORY]
##Pre-requisite for nexus intergaratin with jenkins
-->We need to have Jenkins and nexus server up and running (by default Jenkins runs on 8080 and nexus at 8081)
-->once we click on create repository ( types of repository will be listed ) --> click on helm(hosted)
-->give a meaningful name to repository and click on create repository
-->Now no other configuration is need in Jenkins host because we will nexus repo api and publish the helm charts
-->The below line can help you in pushing the helm chart
 curl -u admin:$nexus_password http://nexus_machine_ip:8081/repository/helm-hosted/ --upload-file myapp-${helmversion}.tgz -v

 ######pipeline  of pushing the helm charts through Jenkins into nexus###
 pipeline{
    agent any 
    environment{
        VERSION = "${env.BUILD_ID}"
    }
    stages{
        stage("Clone code from VCS") {
            steps {
                script {
                    git 'https://github.com/javaee/cargotracker.git';
                }
            }
        }
        stage("Maven Build") {
            steps {
                script {
                    sh "mvn package -DskipTests=true"
                }
            }
        }
        stage("docker build & docker push"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_password')]) {
                             sh '''
                                docker build -t 34.125.214.226:8083/springapp:${VERSION} .
                                docker login -u admin -p $docker_password 34.125.214.226:8083 
                                docker push  34.125.214.226:8083/springapp:${VERSION}
                                docker rmi 34.125.214.226:8083/springapp:${VERSION}
                            '''
                    }
                }
            }
        }
        stage('indentifying misconfigs using datree in helm charts'){
            steps{
                script{

                    dir('kubernetes/') {
                        withEnv(['DATREE_TOKEN=GJdx2cP2TCDyUY3EhQKgTc']) {
                              sh 'helm datree test myapp/'
                        }
                    }
                }
            }
        }
        stage("pushing the helm charts to nexus"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_password')]) {
                          dir('kubernetes/') {
                             sh '''
                                 helmversion=$( helm show chart myapp | grep version | cut -d: -f 2 | tr -d ' ')
                                 tar -czvf  myapp-${helmversion}.tgz myapp/
                                 curl -u admin:$docker_password http://34.125.214.226:8081/repository/helm-hosted/ --upload-file myapp-${helmversion}.tgz -v
                            '''
                          }
                    }
                }
            }
        }

    }

    post {
		always {
			mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "deekshith.snsep@gmail.com";  
		 }
	   }
}

####################### Manual approve and Deploying application on k8s cluster#############
##Now on jenkins 
-->Install Kubernetes Continuous Deploy Plugin, once its installed successfully. 
-->Goto manage jenkins --> manage credentials --> Click on jenkins global --> add credentials
-->select
-->Kind : Kubernetes Configuration 
-->Scope : Global ID : kubernetes-configs ( any meaningful name )
-->Kubeconfig : copy the content of kubernetes config file and place it at the file /root/kube/config in jenkins host
-->click OK
###pipeline Manual approve and Deploying application on k8s cluster
pipeline {
    agent any
    environment{
        VERSION = "${env.BUILD_ID}"
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "you-ip-addr-here:8081"
        NEXUS_REPOSITORY = "maven-nexus-repo"
        NEXUS_CREDENTIAL_ID = "nexus-user-credentials"
    }
    tools {
        maven 'maven123'
    }
    options {
        timestamps()
        //discardbuilds 
        buildDiscarder logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '10', daysToKeepStr: '5', numToKeepStr: '5')
    }
    stages{
        stage ('Git-checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build source code') {
            steps {
                'mvn clean package'
            }
        }
        stage('Junit test and Jacoco test') {
            steps {
                sh "mvn test" //here we are running the tests in this stage
                junit allowEmptyResults: true, testResults: 'target/surefire-reports-/*.xml'
                jacoco()
            }
        }
        stage("build & SonarQube analysis") {
            steps {
                withSonarQubeEnv('My SonarQube Server') {
                    //sh 'mvn clean package sonar:sonar'
                    sh "mvn sonar:sonar \
                        -Dsonar.projectKey=maven-jenkins-pipeline \
                        -Dsonar.host.url=http://13.126.108.209:9000/"
                }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
                }
            }
        }
        stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version}";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }
        stage("docker build & docker push to nexus"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_password')]) {
                             sh '''
                                docker build -t 34.125.214.226:8083/springapp:${VERSION} .
                                docker login -u admin -p $docker_password 34.125.214.226:8083 
                                docker push  34.125.214.226:8083/springapp:${VERSION}
                                docker rmi 34.125.214.226:8083/springapp:${VERSION}
                            '''
                    }
                }
            }
        }
        stage('identifying misconfigs using datree in helm charts') {
            script{
                dir('kubernetes/') {
                    withEnv(['DATREE_TOKEN=GJdx2cP2TCDyUY3EhQKgTc']) {
                        sh 'helm datree test myapp/'
                    }
                }
            }
        }
        
        stage("pushing the helm charts to nexus"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_pass', variable: 'docker_password')]) {
                          dir('kubernetes/') {
                             sh '''
                                 helmversion=$( helm show chart myapp | grep version | cut -d: -f 2 | tr -d ' ')
                                 tar -czvf  myapp-${helmversion}.tgz myapp/
                                 curl -u admin:$docker_password http://34.125.214.226:8081/repository/helm-hosted/ --upload-file myapp-${helmversion}.tgz -v
                            '''
                          }
                    }
                }
            }
        }
        
        stage('manual approval'){
            steps{
                script{
                    timeout(10) {
                        mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> Go to build url and approve the deployment request <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "deekshith.snsep@gmail.com";  
                        input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                    }
                }
            }
        }

        stage('Deploying application on k8s cluster') {
            steps {
               script{
                   withCredentials([kubeconfigFile(credentialsId: 'kubernetes-config', variable: 'KUBECONFIG')]) {
                        dir('kubernetes/') {
                          sh 'helm upgrade --install --set image.repository="34.125.214.226:8083/springapp" --set image.tag="${VERSION}" myjavaapp myapp/ ' 
                        }
                    }
               }
            }
        }
        
    }
    post{
        always {
            junit '**/target/*.xml'
            mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "dhanapal703278@gmail.com";  
        }
        failure {
            //mail to: team@example.com, subject: 'The Pipeline failed :('
        }
		sucess {
			// mail to: dhanapal703278@gmail.com, subject: The Pipeline sucess 
		}
    }
}

####################upload artifact to S3 bucket############
--->Go AWS -->create a "IAM user" --> add  permission policy of "AmazonS3FullAccess" --> download or note the Access key and Secret key
###Now go to jenkins
--->Dashboard->click manage jenkins->manage jenkins->manage plugins->S3 publisher plugin & Amazon S3 Bucket Credentials Plugin(search available)
  -> S3 publisher plugin & Amazon S3 Bucket Credentials Plugin(select)->install(without restart)
 
 -->Again to manage jenkins->configure system-> Amazon S3 profiles->Profile name=S3-Artifactupload-->mark Use IAM Role 
  ->Add SonarQube->Name=Sonarjenkins->Access key=AKIA4PNPSDJFMC3ES4P->Secret key=an57dsdnds1ldldDD/@DD-->click test connection(it show check passed)-->click apply-->save

##now run pipeline to upload artifact to s3 bucket####
pipeline{
    agent  any
    tools {
            maven 'maven-3.8.6'
        }
    options {
        //discardbuilds 
        buildDiscarder logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '10', daysToKeepStr: '5', numToKeepStr: '5')
        
    }
    stages{
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh "mvn --version"
                sh "mvn  install -DskipTests" //DskipTests-it skip tests in this stage
            }
        }
        stage('Test Maven - JUnit and Jacoco') {
            steps {
              sh "mvn test"
               jacoco()
            }
            
        }
        stage('upload artifcat to s3') {
            steps {
                s3Upload consoleLogLevel: 'INFO', dontSetBuildResultOnFailure: false, dontWaitForConcurrentBuildCompletion: false, entries: [[bucket: 'myartifact-store', excludedFile: '', flatten: false, gzipFiles: false, keepForever: false, managedArtifacts: false, noUploadOnFailure: true, selectedRegion: 'ap-south-1', showDirectlyInBrowser: true, sourceFile: '**/*.war', storageClass: 'STANDARD', uploadFromSlave: false, useServerSideEncryption: false]], pluginFailureResultConstraint: 'FAILURE', profileName: 'S3-Artifactupload', userMetadata: []
            }
            
        }
        
    }
}

##################build-docker image and push to ECR in pipeline###################
##Go AWS 
-->create a "IAM user" or exissting user --> add  permission policy of "AmazonEC2ContainerRegistryFullAccess" --> download or note the Access key and Secret key
### create ECR on AWS
-->Amazon ECR-->Repositories--> click Create repository-->mark public-->leave deafult reamining-->click repository.
###Now go to jenkins for installation AWS ECR plugin
--->Dashboard->click manage jenkins->manage jenkins->manage plugins->Amazon ECR plugin(search available)
  -> Amazon ECR plugin(select)->install(without restart)
##Now create Environment variables on jenkins
->Now to manage jenkins->configure system->Environment variable-->List of variables-->-->click add-->Name=AWS_ACCESS_KEY_ID Value=AKhHSHSAMXCJHWC3ES4P 
-->click add-->Name=AWS_SECRET_ACCESS_KEY Value=MlfaTC1/9eLBJIizwm -->click add -->Name=AWS_DEFAULT_REGION Value=ap-south-1

##pipeline
pipeline{
    agent  any
    environment {
        AWS_ACCOUNT_ID="857751058578"
        AWS_DEFAULT_REGION="ap-south-1"
        IMAGE_REPO_NAME="myown-docker-repository"
        IMAGE_TAG="v2.2"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        HELM_PACKAGE_NAME = "helm-test-chart"
    }
    tools {
            maven 'maven-3.8.6'
        }
    options {
        //discardbuilds 
        buildDiscarder logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '10', daysToKeepStr: '5', numToKeepStr: '5')
        
    }
    stages{
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh "mvn --version"
                sh "mvn  install -DskipTests" //DskipTests-it skip tests in this stage
            }
        }
        stage('Test Maven - JUnit and Jacoco') {
            steps {
              sh "mvn test"
               jacoco()
            }
            
        }
        stage('upload artifcat to s3') {
            steps {
                s3Upload consoleLogLevel: 'INFO', dontSetBuildResultOnFailure: false, dontWaitForConcurrentBuildCompletion: false, entries: [[bucket: 'myartifact-store', excludedFile: '', flatten: false, gzipFiles: false, keepForever: false, managedArtifacts: false, noUploadOnFailure: true, selectedRegion: 'ap-south-1', showDirectlyInBrowser: true, sourceFile: '**/*.war', storageClass: 'STANDARD', uploadFromSlave: false, useServerSideEncryption: false]], pluginFailureResultConstraint: 'FAILURE', profileName: 'S3-Artifactupload', userMetadata: []
            }
            
        }
        stage (' Bulid Images & Publish to ECR') {
            steps {
                //sh 'aws ecr-public get-login-password --region ap-south-1 | docker login --username AWS --password-stdin public.ecr.aws/t7e2c6o4'
                //withAWS(credentials: 'aws-credential-iam', region: 'ap-south-1') {
                //withEnv(["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}", "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}"]) {
		        sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
				sh "docker tag alpine ${REPOSITORY_URI}:$IMAGE_TAG"
                sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
            }
            
        }
          
    }
}

#############helm chart and push to s3/ECR in pipeline################
#####helm Chart repository create in S3 AWS
## Install the Helm v3 client.	
-->To download and install the Helm client on your local system, run the following command: 
$ sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
##Initialize an S3 bucket as a Helm repository
##Create an S3 bucket for Helm charts.
-->Create a unique S3 bucket. 
-->In the bucket, create a folder called stable/myapp.
-->The example in this pattern uses s3://my-helm-charts/stable/myapp as the target chart repository.
##Install the helm-s3 plugin for Amazon S3.
-->To install the helm-s3 plugin on your client machine, run the following command: 
$ helm plugin install https://github.com/hypnoglow/helm-s3.git
##Initialize the Amazon S3 Helm repository.
-->To initialize the target folder as a Helm repository, use the following command: 
$ helm s3 init s3://my-helm-charts/stable/myapp 
-->The command creates an index.yaml file in the target to track all the chart information that is stored at that location.
##Verify the newly created Helm repository.
-->To verify that the index.yaml file was created, run the following command: 
$ aws s3 ls s3://my-helm-charts/stable/myapp/
##Add the Amazon S3 repository to Helm on the client machine.
$ To add the target repository alias to the Helm client machine, use the following command: 
$ helm repo add stable-myapp s3://my-helm-charts/stable/myapp/
##Package the local Helm chart.
-->To package the chart that you created or cloned, use the following command: 
$ helm package ./my-app  
-->As an example, this pattern uses the my-app chart. The command packages all the contents of the my-app chart folder into an archive file, which is named using the version number that is mentioned in the Chart.yaml file.
##Store the local package in the Amazon S3 Helm repository.
$ To upload the local package to the Helm repository in Amazon S3, run the following command: 
$ helm s3 push ./my-app-0.1.0.tgz stable-myapp
In the command, my-app is your chart folder name, 0.1.0 is the chart version mentioned in Chart.yaml, and stable-myapp is the target repository alias.
##Search for the Helm chart.
-->To confirm that the chart appears both locally and in the Amazon S3 Helm repository, run the following command: 
$ helm search repo stable-myapp
########helm Chart repository create in S3 AWS
##To push a Docker image to an Amazon ECR repository
1. Authenticate your Docker client to the Amazon ECR registry to which you intend to push your image.
$ aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com
2. If your image repository does not exist in the registry you intend to push to yet, create it. For more information, see Creating a private repository.
3.Identify the local image to push. Run the docker images command to list the container images on your system.
$ docker images
4.Tag your image with the Amazon ECR registry, repository, and optional image tag name combination to use. The registry format is aws_account_id.dkr.ecr.region.amazonaws.com.
$ docker tag e9ae3c220b23 aws_account_id.dkr.ecr.region.amazonaws.com/my-repository:tag
5.Push the image using the docker push command:
$ docker push aws_account_id.dkr.ecr.region.amazonaws.com/my-repository:tag
Note:
The same steps we doing cli that we can do through jenkins pipeline. We doing in below pipeline
##pipeline
pipeline {
    environment {
       AWS_ACCOUNT_ID="857751058578"
        AWS_DEFAULT_REGION="ap-south-1"
        IMAGE_REPO_NAME="myown-docker-repository"
        IMAGE_TAG="dhanapal-v1"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        HELM_PACKAGE_NAME = "test" 
    }
    agent  {
        label 'docker-node'
    }
    tools {
        maven 'maven-3.8.6'
    }
    stages {
        stage('Checkout'){
           steps {
               git 'https://github.com/dhanapal703278/maven.git'
           }
        }
        stage('helm chart to S3 bucket') {
            steps {
                script {
                    dir('kubernetes/') {
                        sh '''
                           helmversion=$( helm show chart ${HELM_PACKAGE_NAME} | grep version | cut -d: -f 2 | tr -d ' ')
                           helm s3 init s3://myartifact-store/helm-charts/ ##inits chart repository in 'myartifact-store' bucket under 'helm-charts' path.
                           helm package ${HELM_PACKAGE_NAME}
                           helm s3 push ./epicservice-0.5.1.tgz kuberntes ##- uploads chart file 'epicservice-0.5.1.tgz' from the current directory to the repository with name 'my-repo'
                        '''
                    }
                }
            }
                
        } 
         // OR we can go with ECR for pushing helm charts
        stage('helm chart to ECR') {
            steps {
                script {
                    dir('kubernetes/') {
                        sh '''
                           helmversion=$( helm show chart test | grep version | cut -d: -f 2 | tr -d ' ')
                           helm package ${HELM_PACKAGE_NAME}
                           aws ecr create-repository      --repository-name helm-test-chart      --region ap-south-1
                           aws ecr get-login-password      --region ${AWS_DEFAULT_REGION} | helm registry login      --username AWS      --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
                           helm push ${HELM_PACKAGE_NAME}-${helmversion}.tgz oci://${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/
                        '''
                    }
                }
            }
                
        }
        
    }
    
}

#################pipeline  of option use##############
##Available Options
$ buildDiscarder
Persist artifacts and console output for the specific number of recent Pipeline runs. For example: options { buildDiscarder(logRotator(numToKeepStr: '1')) }

$checkoutToSubdirectory
Perform the automatic source control checkout in a subdirectory of the workspace. For example: options { checkoutToSubdirectory('foo') }

$disableConcurrentBuilds
Disallow concurrent executions of the Pipeline. Can be useful for preventing simultaneous accesses to shared resources, etc. For example: options { disableConcurrentBuilds() }

$disableResume
Do not allow the pipeline to resume if the controller restarts. For example: options { disableResume() }

$newContainerPerStage
Used with docker or dockerfile top-level agent. When specified, each stage will run in a new container instance on the same node, rather than all stages running in the same container instance.

$overrideIndexTriggers
Allows overriding default treatment of branch indexing triggers. If branch indexing triggers are disabled at the multibranch or organization label, options { overrideIndexTriggers(true) } will enable them for this job only. Otherwise, options { overrideIndexTriggers(false) } will disable branch indexing triggers for this job only.

$preserveStashes
Preserve stashes from completed builds, for use with stage restarting. For example: options { preserveStashes() } to preserve the stashes from the most recent completed build, or options { preserveStashes(buildCount: 5) } to preserve the stashes from the five most recent completed builds.

$quietPeriod
Set the quiet period, in seconds, for the Pipeline, overriding the global default. For example: options { quietPeriod(30) }

$retry
On failure, retry the entire Pipeline the specified number of times. For example: options { retry(3) }

$skipDefaultCheckout
Skip checking out code from source control by default in the agent directive. For example: options { skipDefaultCheckout() }

$skipStagesAfterUnstable
Skip stages once the build status has gone to UNSTABLE. For example: options { skipStagesAfterUnstable() }

$timeout
Set a timeout period for the Pipeline run, after which Jenkins should abort the Pipeline. For example: options { timeout(time: 1, unit: 'HOURS') }

pipeline {
    agent any
    options {
        buildDiscarder logRotator(artifactDaysToKeepStr: '7', artifactNumToKeepStr: '10', daysToKeepStr: '7', numToKeepStr: '10')
        retry(2)
        timestamps()
        warnError('Error messages')
        disableResume()
        //disableConcurrentBuilds abortPrevious: true
        timeout(activity: true, time: 40)
    }

    stages {
        stage{
            steps{
                echo "this pipeline for how to use  option"
            }
        }
	}
}


########Configure Clouds agent(EC2 instance)
->Now go to jenkins 
->click manage jenkins->manage plugins->Amazon ec2 instance, docker and kubernetes (search available)->Amazon ec2 instance, docker and kubernetes (select)->install(without restart)
###Now go aws console for create IAM group and user assigned AmazonEC2FullAccess policy
1.create group jenkins
2.add permission (AmazonEC2FullAccess) to jenkins group
3.create IAM user dhanapal user->download access key and secret key
4.click add dhanapal user to jenkins group
###Now create keypair 
1.click create keypair 
2. select  .pem
3.click save 
->now again click manage jenkins
->click Manage nodes and clouds
->click Configure Clouds
->select Amazon EC2
->Name= ec2-agent
->Amazon EC2 Credentials->click add (jenkins)->
->Add Credentials
->Domain= Global credentials (unrestricted)
->Kind= AWS Credentials
->Scope= Global (Jenkins, nodes, items, all child items, etc)
->ID= AWS-KEYS
->Description= AWS-KEYS
->Access Key ID= AKIA4PNPSPCJNBYNPM4Z (acess key IAM role of dhanapal)
->Secret Access Key= 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
->IAM Role Support->click advance
->IAM Role To Use=
->External Id To Use=
->MFA Serial Number=
->MFA Token= 
->STS Token Duration= 3600
->click add
->Use EC2 instance profile to obtain credentials (leave default=unmark)
->Alternate EC2 Endpoint(leave deafult)
->Region= ap-south-1 (select your wish of region)
->EC2 Key Pairs Private Key->click add (jenkins)->
->Add Credentials
->Domain= Global credentials (unrestricted)
->Kind= SSH Username with private key
->Scope= Global (Jenkins, nodes, items, all child items, etc)
->ID= AWS-KEYS
->Description= AWS-KEYS
->ID= ec2private-keys
->Description= ec2private-keys
-.Username= ec2-user
->mark Treat username as secret
->Private Key->Enter directly->Key(add the pem key )
->click add
click test connection --here display sucess
->click AMIs (List of AMIs to be launched as agents)
->Description= AWS-Ec2-ap-south-1a
->AMI ID= ami-06a0b4e3b7eb7a300
->AMI Owners= leave default
->AMI Users= leave deafult
->AMI Filters= leave defult
->Instance Type= T2micro
->EBS Optimized, Monitoring, T2 Unlimited (leave deafult =unmark)
->Availability Zone
->vailability Zone=ap-south-1a
->Spot configuration (unmark )
->Security group names= sg-0684a74fe71f043b5
->Remote FS root= /home/redhat
->Remote user= redhat
->AMI Type= unix
->Root command prefix= sudo
->Agent command prefix= (leave deafult)
->Agent command suffix= (leave deafult)
->Remote ssh port= 22
->Boot Delay= (leave deafult)
->Labels= aws-jenkins-agent
->Usage= Only build jobs with label expressions matching this node
->Idle termination time= 25 (it delete after 25 minutes and idle time is 25 minutes )
->Init script= yum install git -y 
			   yum install maven -y 
		       yum install  java-1.8.0-openjdk -y 
->click advance
->Number of Executors= 2
->VM Options= leave deafult
->Stop/Disconnect on Idle Timeout = leave deafult
->Subnet IDs for VPC= subnet-0913f861258ec54fc
->Tags
->EC2 Tag/Value Pairs
->Minimum number of instances= 0
->Minimum number of spare instances= 0
-> Only apply minimum number of instances during specific time range= leave deafult
->Instance Cap
->IAM Instance Profile
->Delete root device on instance termination
->Use ephemeral devices
->Encrypt EBS root volume
->Based on AMI
->Block device mapping
->Launch Timeout in seconds
->Associate= Public IP
->Tenancy= Default
->Connection Strategy= Public IP
-> mark Connect by SSh
->click apply
->click save



#############################Jfrog Artifactory Installation###########################################################
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
->Repository key: development-repository
->repository layout: maven-2-deafult
->checksumpolicy: verfiy against client checksums
->maven snpahot version:unique
->click save and finish
After create repository here  dispaly five file
1. lib-snapshot-local--it store the snapshot of version
2. lib-release-local--it store our artifactory(jar,war) 
3. jcenter--it store all thrid dependency
4. lib-release--it store the dependency


#################copy jar from one server to another and work for remote server from jenkins###########
#create ssh-keygen
#copy public key to remote server into .ssh/authorized_keys 
#create credentails in jenkins of ssh with private (copy private from  ssh-key generate server##
#install sshagent plug-in in jenkins

pipeline{
    agent {
        docker { 
            image 'dhanapal406/jenkins_java_git_maven-3.8.5' //docker image 
            label 'docker-node' //agent label
			alwaysPull true
        }
    }
	tools {
        maven 'maven123'
    }
    options {
        //discardbuilds 
        buildDiscarder logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '10', daysToKeepStr: '5', numToKeepStr: '5')
        
    }
    environment {
        remote_server_ip = "10.10.1.173 "
        remote_username = "root"
    }
    stages{
        stage('Checkout') {
            steps {
                git 'https://github.com/dhanapal703278/tomcat_maven_app.git'
            }
        }
        stage('work for remote server from jenkins') {
            steps {
                sshagent(['sshagent-scp']) {
                    sh """
                    ssh  -o StrictHostKeyChecking=no  $remote_username@$remote_server_ip  mkdir /opt/jenkins80 ; touch ~/dhanafile80 ; rm -rf /opt/jenkins88   
                    ssh  -o StrictHostKeyChecking=no  $remote_username@$remote_server_ip cat /etc/sudoers
                    """ 
                    
                }
                
            }
        }
        stage('copy jar or war from master to agent') {
            steps {
                //if we  build is run on server and deploy in another server for it requried jar or war
                sshagent(['sshagent-scp']) {
                    /*<packaging>jar</packaging>
                    <version>1.0-SNAPSHOT</version>
                    <name>my-app</name>
                    above are in pom.xml
					-o StrictHostKeyChecking=no  is do not hostkey check promot for yes or no while copying file
					For comment we can use staring with /* and endin with */
					*/
                    sh " scp -o StrictHostKeyChecking=no  target/java-tomcat-maven-example.war root@10.10.1.173:/opt/pipeline-repo/"
                }
            }
                
        }
        
            
            
           
    }
        
        
}

########################run pipeline in parallel and trigger with cron jobs##########
#The ways to trigger a Jenkins Job/Pipeline?

There are many ways we can trigger a job in Jenkins. Some of the common ways are as below -

Trigger an API (POST) request to the target job URL with the required data.
Trigger it manually from the Jenkins web application.
Trigger it using Jenkins CLI from the master/slave nodes.
Time-based Scheduled Triggers like a cron job.
Event-based Triggers like SCM Actions (Git Commit, Pull Requests), WebHooks, etc.
Upstream/Downstream triggers by other Jenkins jobs

pipeline {
    agent any
    tools {
        maven 'maven123'
    }
    options {
        buildDiscarder logRotator(artifactDaysToKeepStr: '7', artifactNumToKeepStr: '10', daysToKeepStr: '7', numToKeepStr: '10')
        retry(2)
        timestamps()
        warnError('Error messages')
        disableResume()
        disableConcurrentBuilds abortPrevious: true
        timeout(activity: true, time: 2)
    }
    triggers {
        //minute, hour, day of month, and day of week (0 and 7 are sundays)
        cron('0 12 * * 2,4')
        //@yearly, @monthly, @hourly, @daily
    }
    stages {
        stage('parallel build the code') {
            parallel {
                stage('checkout' ) {
                    steps {
                        echo 'checkout of git'
                    }
                }
                stage('build') {
                    steps {
                        echo 'build with maven'
                    }
                }
                stage('test') {
                    steps {
                        echo 'test the soruce code'
                    }
                }
            }
        }
        stage('deploy the code') {
            parallel {
                stage('deploy the code to UAT') {
                    input {
                        message 'Provide your approval to deploy in UAT'
                    }
                    steps {
                        echo 'deploy the code to UAT'
                    }
                
                }
                stage('deploy the code to DEV') {
                    steps {
                        echo 'deploy the code to DEV'
                    }
                }
            }
            
        }
    }
}

###########################pipeline trigger with pollscm########

pipeline {
    agent any
    tools {
        maven 'maven123'
    }
    options {
        buildDiscarder logRotator(artifactDaysToKeepStr: '7', artifactNumToKeepStr: '10', daysToKeepStr: '7', numToKeepStr: '10')
        retry(2)
        timestamps()
        warnError('Error messages')
        disableResume()
        disableConcurrentBuilds abortPrevious: true
        timeout(activity: true, time: 2)
    }
    triggers {
        //minute, hour, day of month, and day of week (0 and 7 are sundays)
        pollSCM('* 4 * * * ')
        //@yearly, @monthly, @hourly, @daily
    }
    stages {
        stage('parallel build the code') {
            parallel {
                stage('checkout' ) {
                    steps {
                        echo 'checkout of git'
                    }
                }
                stage('build') {
                    steps {
                        echo 'build with maven'
                    }
                }
                stage('test') {
                    steps {
                        echo 'test the soruce code'
                    }
                }
            }
        }
        stage('deploy the code') {
            parallel {
                stage('deploy the code to UAT') {
                    input {
                        message 'Provide your approval to deploy in UAT'
                    }
                    steps {
                        echo 'deploy the code to UAT'
                    }
                
                }
                stage('deploy the code to DEV') {
                    steps {
                        echo 'deploy the code to DEV'
                    }
                }
            }
            
        }
    }
}


################################################Integrate Artifactory with Jenkins######################################
pre-requisites
->An Artifactory server 
->A Jenkins Server 
##now login to jfrog artifactory server
#we need to have common user to communicate between Jenkins and artifactory
1.login to the Jforg Artifactory console as an administrator.
http://<jfrog server ip:8081/artifactory>
2.Go to Admin area navigate to Users Click on “New User” button.
3. Enter the desired fields and make sure to mark Disable UI Access (We are using this user only for connectivity between Jenkins and Jforg Artifactory not to access the UI)
4. Click save.
##3. Creating Maven repository in Jfrog

#Integration Steps
->Login to Jenkins to integrate Artifactory with Jenkins
->Install "Artifactory" plug-in
->Manage Jenkins -> Jenkins Plugins -> available -> artifactory-> select without restart.
->Configure Artifactory server credentials
->Manage Jenkins -> Configure System -> Artifactory
->Artifactory Servers
->Server ID : <Artifactory-Server-ip>
->URL : <<<Artifactory Server URL>>>
->Username : jenkins
->Password : redhat
->click test connection->here found Artifactory version 


###############Reverse Proxy with nginx for jenkin url access########
#set hostname with FQDN
$ hostnamectl set-hostname jenkins.cntech.local
$ echo `hostname -i | awk '{print $NF}'`" "`hostname`" "`hostname -s ` >> /etc/hosts
##now install nginx 
$ yum install nginx
 # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/deffault.d/*.conf;

        location / {
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
	-------------remove above line the in above configuration file 
	------starting from server line to last flower bracket }
:wq!
##create new file in /etc/nginx/conf.d/jenkins-proxy.conf
$ vim /etc/nginx/conf.d/jenkins-proxy.conf
##
####reverse proxy configuration link
#https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/
upstream jenkins {
    #server <server-ip-address:8080>;
	server 35.154.4.51:8080; 
}
server {
    listen       80 default;
    server_name   jenkins.cntech.local; # replace 'jenkins.cntech.local' with your server domain name
	
	access_log   /var/log/jenkins.access.log;
	error_log   /var/log/jenkins.error.log;
location / {
    proxy_buffers 16 4k;
    proxy_buffer_size 2k;
    proxy_set_header Accept-Encoding "";
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_pass http://jenkins;

	}
}

:wq!
##To check configuration reverse proxy syntax error
$  nginx -t
$ systemctl restart nginx

###################Periodic Backup(plug-in)###############
#Backup plugin allows archiving and restoring your Jenkins (and Hudson) home directory.
#With Periodic Backup we schudle cron jobs for backup perpouse
->Now go to jenkins 
->manage jenkins->manage plugins->Periodic Backup(search available)->Periodic Backup(select)->install(without restart)
->now to go jenkins server create a directory for storing jenkins backup data.
$ mkdir /opt/backup-jenkins-data
$ chown -R jenkins:jenkins /opt/backup-jenkins-data
->Again to manage jenkins->configure system->Periodic Backup Manager(last down)->click here to configure it->
->Root Directory=/var/lib/jenkins
->Temporary Directory=/tmp
->Backup schedule (cron)=30 * * * * (every day  30 minutes)
->Maximum backups in location=20
->Store no older than (days)=15
->File Management Strategy= ConfigOnly/FullBackup
->Storage Strategy=Tar.GzStorage
->Backup Location=/opt/backup-jenkins-data
->mark enable this location
->click validate
->clik save
###For taking backup 
-> click Backup Now
###For restore backup  
##if any important job deletd means we can restore with this 
-> click restore

################################## Securirty########################
->Now go to jenkins 
->manage jenkins->manage plugins->Role-based Authorization Strategy(search available)->Role-based Authorization Strategy(select)->install(without restart)

############LDAP configuration in jenkins##############
##server LDAP configuration details (deatils for configure LDAP in jenkins###
objectClass: top
objectClass: dcObject 
objectClass: organization
o: example.com
dc: example.com
structuralobjectClass: organization
entryUID: bies4684-739-1036-8256-33433ee5d363
creatorsName: cn=admin,dc=example,dc=com
createTimestamp: 202187210636232
Security Realm createTimestamp: 287187216636737
entryCSN: 20210721053623,32521320000000000000000
modifiersName: cn=admin,dc=example,dc=com
modifyTimestamp: 282187210636232

dn: cn=admin,dc=example,dc=com
objectClass simpleSecurityObject 
objectClass: organizationalRole
cn: admin
description: LOAP administrator
user Password: #INTSEF3atybJZOM VZVVFZIU
structuralObjectClass: organizationalRole
entryUID: bies4684-739-1036-8256-33433ee5d363
creatorsName: cn=admin,dc=example,dc=com
entryUID: bies4684-739-1036-8256-33433ee5d363
createTimestamp: 202187210636232 
entryCSN: 20210721053623,32521320000000000000000
modifierstime: cn=admin,dc=example,dc=com 
modifyTimestamp: 202107210636732
------------------
#Authentication(LDAP configuration)
->Security Realm=LDAP
Server
->Server= 172.13.43.20:389(Syntax of server field is SERVER or SERVER:PORT or ldaps://SERVER[:PORT])
->root DN= dc=example,dc=com(Allow blank rootDN)
->User search base= OU=people
->User search filter= uid={0}
->Group search base= OU=groups
-> Group search filter= empty (leave default)
->Group membership
Parse user attribute for list of LDAP groups/Search for LDAP groups containing user
-> mark Search for LDAP groups containing user
->Group membership filter= ((member={0})(uniqueMember={0})(memberUid={1}))
->Manager DN= cn=admin,dc=example,dc=com
->Manager Password= LDAP password
->Display Name LDAP attribute= cn <displayname>
->Email Address LDAP attribute= mail
-> Environment Properties--leave default
-> click test LDAP user-> username= dhana->password=dhan@1234
-> mark Disable Ldap Email Resolver
-> mark Disable Backward Compatibility for Roles
->click save
-> click apply
##Now go to jenkins  for security
->manage jenkins->click Configure Global Security
->Authorization= Role-Based Strategy
->click save
-> click apply
->now again manage jenkins
->under Security
-> click Manage and Assign Roles 
->click Manage Roles
->Role to add= devops
->click add
->again Role to add= devolper
->click add
-> here dispaly two user mark the required permission for the user
 
#############Pipeline of Post stage########

Always/success/failure
---------------------
pipeline{
    agent any
    stages{
        stage('Build'){
            steps{
                    echo "building"
                    //error("Build failed")
            }
        }
    }
    post{
		//Only runs if the current Pipeline’s or stage’s run has a "success" status
		success{
			echo 'post->success is called'
		}
		//Only runs if the current Pipeline’s or stage’s run has a "failed" status
		failure { 
            echo 'post->failure is called'
        }
		//Runs regardless of the completion status of the Pipeline’s or stage’s run.
        always { 
            echo 'post->always is called'
        }
    }
}

changed 
-------------
pipeline{
    agent any
    stages{
        stage('Build'){
            steps{
                    echo "building"					
					//script{
					//	currentBuild.result = 'UNSTABLE'
					//}
            }
        }
    }
    post{
		//Only runs if the current Pipeline’s or stage’s run has a different completion status from its previous run.
        changed { 
            echo 'post->changed is called'
        }
    }
}

unstable
---------
using example from above


		//Only run the steps in post if the current Pipeline’s or stage’s run has an "unstable" status, usually caused by test failures, code violations, etc. 
		unstable { 
            echo 'post->unstable is called'
        }




fixed
------
pipeline{
    agent any
    stages{
        stage('Build'){
            steps{
                    echo "building"
            }
        }
    }
    post{
		//Only runs if the current Pipeline’s or stage’s run is successful and the previous run failed or was unstable.
		fixed { 
            echo 'post->fixed is called'
        }
    }
}

regression
-----------
pipeline{
    agent any
    stages{
        stage('Build'){
            steps{
                    echo "building"
					error("Build failed")
            }
        }
    }
    post{
		//Only runs if the current Pipeline’s or stage’s status is failure, unstable, or aborted and the previous run was successful.
		regression { 
            echo 'post->regression is called'
        }
    }
}

aborted
-------

pipeline{
    agent any
    stages{
        stage('Build'){
            steps{
                    echo "building"
					script{
						currentBuild.result = 'ABORTED'
					}
            }
        }
    }
    post{
		//Only runs if the current Pipeline’s or stage’s run has an "aborted" status, usually due to the Pipeline being manually aborted. 
		aborted { 
            echo 'post->aborted is called'
        }
    }
}



cleanup
--------
pipeline{
    agent any
    stages{
        stage('Build'){
            steps{
                    echo "building"
                    //error("Build failed")
            }
        }
    }
    post{
		//Only runs if the current Pipeline’s or stage’s run has a "success" status, typically denoted by blue or green in the web UI.
		success{
			echo 'post->success is called'
		}
		//Only runs if the current Pipeline’s or stage’s run has a "failed" status, typically denoted by red in the web UI.
		failure { 
            echo 'post->failure is called'
        }
		//Runs regardless of the completion status of the Pipeline’s or stage’s run.
        always { 
            echo 'post->always is called'
        }
		//Runs after every other post condition has been evaluated, regardless of the status of Pipeline or stage
		cleanup{
			echo 'post->cleanup is called'
		}
    }
}




---------------------------------------Jenkins(CI continue intergration/Continue delivery CD)---------------------------------------------------
->source code commit--trigger automatically(web-hook)-->checkout(Git)-->Build(maveen)-->sonar analysis(SonarQube)-->test(junit)---------
->upload artifactory(nexus/jfrog/S3)-->Build source code jar/war the docker image (Docker Environment)---->upload the docker images to (ECR/jfrog/nexus)---->Deploy to Devploment(Kubernetes).
pipeline {
    agent any
	tools {
        maven 'maven-3.8.5'
    }
    options {
        timeout(30)
		buildDiscarder(logRotator(numToKeepStr: '5'))
		
    }
	stages {
        stage('Checkout') {
			steps{
				checkout scm
				}
		}
		stage('Build'){
			steps{
				mvn clean install 
				}
			} 
		stage('Scan') {
			steps {
				withSonarQubeEnv(installationName: 'sonarjenkins') { 
				sh './mvn clean org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar'
        }
	    stage('create Image') {
            steps {
                sh """
                    docker build -t dhanapal406/tomcat-$BUILD_NUMBER .
                    docker login -u $DOCKER_LOGIN_USR -p $DOCKER_LOGIN_PSW
                    docker push dhanapal406/tomcat-$BUILD_NUMBER
                    docker run -itd -p 8080:8080 -v /dhana:/l406/tomcat-$BUILD_NUMBER
                """
            }
        }
//	    stage('SonarQube analysis') {
//      def scannerHome = tool 'SonarScanner 4.0';
//        steps{
//       withSonarQubeEnv('sonarqube-8.9') { 
//      If you have configured more than one global server connection, you can specify its name
//            sh "${scannerHome}/bin/sonar-scanner"
//          sh "mvn sonar:sonar"
        }
        stage('Test') {
            steps {
                sh 'make check'
            }
        }
  
    post {
        always {
            junit '**/target/*.xml'
        }
        failure {
            //mail to: team@example.com, subject: 'The Pipeline failed :('
        }
		sucess {
			// mail to: dhanapal703278@gmail.com, subject: The Pipeline sucess 
		}
    }
}

#####################build time##########
dev builds (every  monday and thusday)
prod builds (wensday)
UAT builds(tue)   
