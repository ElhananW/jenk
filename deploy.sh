#!/bin/bash

HOME_DIR=/home/ec2-user
PIPLINE_WORKSPACE=/var/lib/jenkins/workspace/proj@2
DIR_NAME=proj
machine_name=$1


if [ $# -ne 1 ]; then
    echo "please enter ONLY one argument \nArgument must be [prod | test]"
    exit 1
fi

clean_previous_builds(){
    # remove all images and containers
    ssh ec2-user@$machine_name "cd /home/ec2-user/$DIR_NAME; docker-compose down -v"
    ssh ec2-user@$machine_name "cd /home/ec2-user/$DIR_NAME; docker system prune -a --volumes -f"
    }
check_args() {
    case "$machine_name" in
    "test") echo "Deploy to TEST machine" ;;
    "prod") echo "Deploy to PROD machine" ;;
    *)
        echo "ERROR! unknown argument ${machine}"
        echo "Usage is ./deploy.sh [prod | test]"
        exit 1
        ;;

    esac
}

main (){
    # Connecting to machine and create new dir
    ssh ec2-user@$machine_name "mkdir -p $HOME_DIR/$DIR_NAME"
    # Copy docker compose to machine
    scp $PIPLINE_WORKSPACE/docker-compose.yml ec2-user@$machine_name:$HOME_DIR/$DIR_NAME
    clean_previeous_builds
    ssh ec2-user@$machine_name "cd /home/ec2-user/$DIR_NAME; docker-compose up -d --no-build"
    if [ $machine_name == "test" ]; then 
        # copy script to test machine 
        scp /var/lib/jenkins/workspace/final-project/tests/test.sh ec2-user@$machine_name:$HOME_DIR/$DIR_NAME
        # give permissions to test.sh file
        ssh ec2-user@test "chmod u+x $HOME_DIR/$DIR_NAME/test.sh"
        # RUN TESTS
        ssh ec2-user@test "cd /home/ec2-user/$DIR_NAME; ./test.sh " 
    fi   

}
check_args
main $machine_name
