#######################################################################
#                                                                     #
# Creates a base CentOS image with JBoss BRMS 6.0.1 #
#   docker run -P -i -t brms601 /bin/bash                             #
#######################################################################

# Use the centos base image
FROM centos

MAINTAINER Jian Feng <jfeng@redhat.com>

# Update the system
RUN yum -y update

# enabling sudo group for jboss
RUN echo '%jboss ALL=(ALL) ALL' >> /etc/sudoers

# Create jboss user
RUN useradd -m -d /home/jboss -p jboss jboss


############################################
# Install Java JDK
############################################
RUN yum -y install java-1.7.0-openjdk unzip
RUN yum clean all
ENV JAVA_HOME /usr/lib/jvm/jre

# Command line shortcuts
RUN echo "export JAVA_HOME=/usr/lib/jvm/jre" >> $HOME/.bash_profile && \
	echo "alias ll='ls -l --color=auto'" >> $HOME/.bash_profile && \
	echo "alias grep='grep --color=auto'" >> $HOME/.bash_profile && \
	echo "alias c='clear'" >> $HOME/.bash_profile

############################################
# Install JBoss Fuse 6.1.0
############################################
USER jboss
ENV HOME /home/jboss
ENV INSTALLDIR $HOME/jboss-fuse-6.1.0.redhat-379
ENV INSTALLSOURCEFILE jboss-fuse-full-6.1.0.redhat-379.zip

RUN mkdir $INSTALLDIR && \
	mkdir $INSTALLDIR/software

ADD ./software/$INSTALLSOURCEFILE $INSTALLDIR/software/$INSTALLSOURCEFILE 

RUN cd $HOME && \
	unzip $INSTALLDIR/software/$INSTALLSOURCEFILE

# 管理ユーザの有効化
# enabling fuse admin user
RUN echo "" 			>> $INSTALLDIR/etc/users.properties && \
	echo "admin=admin,admin" 			>> $INSTALLDIR/etc/users.properties && \
	echo "" 			>> $INSTALLDIR/etc/system.properties && \
	echo "activemq.jmx.user=admin" 		>> $INSTALLDIR/etc/system.properties && \
	echo "activemq.jmx.password=admin" 	>> $INSTALLDIR/etc/system.properties

# startall.sh
USER root
RUN echo "#!/bin/sh" > $HOME/startall.sh  && \
	echo "echo JBoss Fuse Start script" 	>> $HOME/startall.sh && \
	echo "export JAVA_HOME=/usr/lib/jvm/jre" >> $HOME/startall.sh && \
	echo "export KARAF_HOME=$INSTALLDIR" 	>> $HOME/startall.sh && \
	echo "runuser -l jboss -c 'cd $INSTALLDIR/bin && ./fuse'" >> $HOME/startall.sh && \
	chmod +x $HOME/startall.sh

# Clean up
RUN rm -rf $INSTALLDIR/software

EXPOSE 8181 61616

CMD /home/jboss/startall.sh

USER root

# Finished
