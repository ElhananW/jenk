#!/bin/bash

HOME_DIR = "/home/ec2-user"
WORKSPACE = "/var/lib/jenkins/workspace/BynetFinalProject"
#TEST_IP = "54.83.91.121"
#DEPLOY_IP = "18.208.110.157"
#MY_IP = "$(dig +short myip.opendns.com @resolver1.opendns.com)"
machine = $1

##########################
#TODO handle vars names!!!!!!
##########################

usage(){
  echo "Usage: ./deploy.sh [test | prod]"
  exit 1
}

execute_test_case(){
  echo "Now deploying to test machine."
#  ssh ec2-user@$machine_name "mkdir -p $HOME_DIR/$DIR_NAME"    sudo docker-compose up --no-build -d
    sleep 5
    status=`curl --write-out "%{http_code}\n" --silent --output /dev/null "http://127.0.0.1:5000"`
    if [ "$status" == "200" ];
      then
        echo "test PASSED successfully."
      else
        echo "Test Failed"
    fi
}


execute_prod_case(){
  echo "Now deploying to prod machine."
  if [ $MY_IP == $DEPLOY_IP ];
	then
#	cd /home/ec2-user/BynetFinalProject/
	#sudo docker pull avielderhy/finalproject:latest
	sleep 1
	docker-compose up --no-build -d
	fi
}


main(){
  if [ "$#" -ne 1 ];
  then
    echo "You entered more/less than 1 argument"
  	exit 1
  elif ["$machine" == "test"];
  then
    execute_test_case
  elif ["$machine" == "prod"];
  then
    execute_prod_case
  else
    echo "Bad argument $machine"
    usage
  fi

  echo "The application was successfully deployed on $machine machine "
}
