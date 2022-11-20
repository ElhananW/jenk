#!/bin/bash

status=`curl --write-out "%{http_code}\n" --silent --output /dev/null "http://127.0.0.1:5000"`
    if [ "$status" == "200" ];
      then
        echo "test PASSED successfully."
      else
        echo "Test Failed"
    fi
