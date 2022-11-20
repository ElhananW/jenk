#!/bin/bash

HOME_DIR="/home/ec2-user"
WORKSPACE="/var/lib/jenkins/workspace/proj"
DIR_NAME=proj
machine=$1

##########################
#TODO handle vars names and messages!!!!!!
##########################

usage(){
  echo "Usage: ./deploy.sh [test | prod]"
  exit 1
}

execute_test_case(){
  echo "Now deploying to test machine."
  scp -o StrictHostKeyChecking=no docker-compose.yml test.sh ec2-user@$machine:$HOME_DIR/
  ssh -o StrictHostKeyChecking=no ec2-user@$machine 'docker-compose up --no-build -d'
  sleep 3

}


execute_prod_case(){
  echo "Now deploying to prod machine."
  #TODO: mkdir and validate if there is exiting dir
	cd /home/ec2-user/BynetFinalProject/
	sudo docker pull avielderhy/finalproject:latest
	sleep 3
	docker-compose up --no-build -d
}


main(){
  if [ "$#" -ne 1 ];
  then
    echo "You entered more/less than 1 argument"
  	exit 1
  elif [ "$machine" == "test" ];
  then
    execute_test_case
  elif [ "$machine" == "prod" ];
  then
    execute_prod_case
  else
    echo "Bad argument $machine"
    usage
  fi

  echo "The application was successfully deployed on $machine machine "
}
