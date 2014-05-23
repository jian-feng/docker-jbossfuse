docker-jbossfuse
===========

use to build docker image of JBoss Fuse 6 for quick test

First at all, thanks for [Kenneth's great work](http://www.ossmentor.com/2014/05/docker-and-red-hat-jboss-data.html).


## How to build:
###1. Install Docker by following instruction from docker.io

  https://www.docker.io/gettingstarted/#h_installation

###2. Clone this git repository to your local disk
```sh
git clone https://github.com/jian-feng/docker-jbossfuse.git
```
###3. Run build script
```sh
cd docker-jbossfuse
sudo ./build.sh
```
###4. Confirm the docker image
```Shell
sudo docker images
```

Result is: 
```
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
jbossfuse           6.1.0base           390ebf188a7f        56 minutes ago      1.907 GB
```

## How to run:
####1. Run docker image in foreground

```sh
sudo ./run.sh
```
  * This will give you a fuse console. If you type "exit", this container will be stopped.

####2. Find port of management console
Since this container is running in foreground, please open new terminal.
```sh
sudo docker ps
```

  Result is: 
```
ONTAINER ID     IMAGE                 COMMAND                CREATED         STATUS              PORTS                                               NAMES
f277223e6183    jbossfuse:6.1.0base   /home/jboss/startall   2 minutes ago   Up 2 minutes        0.0.0.0:49216->61616/tcp, 0.0.0.0:49217->8181/tcp   romantic_turing
```
  * Within the string "0.0.0.0:49217->8181/tcp", "49217" is the port for management console.
  * Within the string "0.0.0.0:49216->61616/tcp", "49216" is the port for Active-MQ.


####3. Access Fuse Management Console

```sh
http://(Docker hostname):(port of management console)/
```
  * Docker hostname : Host name or IP addr where your docker installed
  * jbossfuse:610base container port : PORTS that displayed in step 2, ex, 49217
  * log in user is admin, password is admin. You can change it in Dockerfile then build image again.


## How to install your own OSGi bundle:

There is a shared VOLUMN ready for you to share files between host and container. 
The folder is under home directory on host machine. So copy the bundle into it.
```sh
cp AAA-1.0.0.jar ~/shared
```
Then run install command inside Fuse console.
```
> osgi:install -s file:/home/jboss/shared/AAA-1.0.0.jar
```

## How to stop:
####1. Find CONTAINER ID
You can also stop this container from docker.
```sh
sudo docker ps
```
  Result is: 
```
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                                                                                                                        NAMES
903d707b16a3        jbossfuse:6.1.0base   bash                   51 minutes ago      Up 51 minutes       0.0.0.0:49214->61616/tcp, 0.0.0.0:49215->8181/tcp   agitated_perlman
```

####2. Run docker stop
```sh
  sudo docker stop (above CONTAINER ID)
```


