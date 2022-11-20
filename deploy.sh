#!/usr/bin/bash

HOME_DIR="/home/ec2-user"
WORKSPACE="/var/lib/jenkins/workspace/proj"
MACHINE=$1

if [ "$#" -ne 1 ]; then
    echo "You entered more/less than 1 argument"
	exit 1
fi

if [ "$MACHINE" == "test" ];
then
	cd /home/ec2-user/Proj/
	sudo docker-compose up --no-build -d
	sleep 5
	./test.sh
	fi
fi

if [ "$MACHINE" == "prod" ];
then
	if [ $MY_IP == $DEPLOY_IP ];
	then
	cd /home/ec2-user/BynetFinalProject/
	sudo docker pull avielderhy/finalproject:latest
	sleep 1
	docker-compose up --no-build -d
	fi
fi

echo "Deployed to $MACHINE machine successfully"
