#!/bin/bash


USER=/home/ec2-user
PIPLINE_WORKSPACE=/var/lib/jenkins/workspace/proj@2
DIR_NAME=proj
machine_name=$1


if [ $# -ne 1 ]; then
    echo "please enter ONLY one argument \nArgument must be [prod | test]"
    exit 1
fi

usage(){
  echo "Usage: ./deploy.sh [test | prod]"
  exit 1

clean_previous_builds(){
    # remove all images and containers
    echo "Remove all containers and images"
    ssh ec2-user@$machine_name "cd /home/ec2-user/$DIR_NAME; docker-compose down -v"
    ssh ec2-user@$machine_name "cd /home/ec2-user/$DIR_NAME; docker system prune -a --volumes -f"
    }
}
in_test_case(){
    # copy script to test machine
    echo "Now deploying to Test machine."
    echo "copy test.sh to Test machine"
    scp /var/lib/jenkins/workspace/final-project/tests/test.sh ec2-user@$machine:$USER/$DIR_NAME
    # give permissions to test.sh file
    ssh ec2-user@test "chmod u+x $USER/$DIR_NAME/test.sh"
    # RUN TESTS
    echo "Running tests"
    ssh ec2-user@test "cd /home/ec2-user/$DIR_NAME; ./test.sh "
    }

check_args() {
    case "$machine" in
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
    echo "Connecting to $machine"
    ssh ec2-user@$machine "mkdir -p $USER/$DIR_NAME"
    # Copy docker compose to machine
    echo "Copy docker-compose to $machine"
    scp $PIPLINE_WORKSPACE/docker-compose.yml ec2-user@$machine:$USER/$DIR_NAME
    echo "Copy .env to $machine"
    scp $PIPLINE_WORKSPACE/.env ec2-user@$machine:$USER/$DIR_NAME
    clean_previous_builds
    echo "run docker compose up"
    ssh ec2-user@$machine "cd /home/ec2-user/$DIR_NAME; docker-compose up -d --no-build"

    #in cade of test stage
    if [ $machine == "test" ];
    then
        in_test_case
    fi

}
check_args
main $machine
