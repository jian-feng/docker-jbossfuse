#!/usr/bin/env bash
if [ -f "software/jboss-fuse-full-6.1.0.redhat-379.zip" ]
then
        
	echo "Building docker image of JBoss Fuse 6.1.0 for test"
    #docker build --no-cache -t jbossfuse:6.1.0base .
	docker build -t jbossfuse:6.1.0base .
else
	echo "File software/jboss-fuse-full-6.1.0.redhat-379.zip not found."
    echo "   Please download JBoss Fuse 6.1.0 from http://jboss.org/products"
    echo "   See detail in /software/README.md"
    exit 0
fi
