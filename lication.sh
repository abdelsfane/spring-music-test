#!/bin/bash
echo "RESULTS: ${RESULTS}"

while true
do 
    echo "Checking Lication security scan status..."

    if [ "$RESULTS" = 2 ]
    then
        echo "Scan status is pending..."
        sleep ${SLEEP_SECONDS}
    
    elif [ "$RESULTS" = 0 ]
    then
        echo -e "Scan completed!\n"
        echo "No vulnerabilities found, deploying ${APPLICATION_NAME}..."
        cd "${WORKSPACE}/$PROJECT_NAME"
        curl -X POST \
            -H 'Content-Type: application/zip' \
            --data-binary @"pcf_artifacts.zip" \
            "${PCF_ENDPOINT}${PCF_ENV}/${PCF_ORG}/${PCF_SPACE}/${APPLICATION_NAME}"
        break
    
    elif [ "$RESULTS" = 1 ]
    then
        echo -e "Scan Completed!\n"
        echo -e "Security Test Failed! Cannot Deploy ${APPLICATION_NAME}!"
        exit 1
    elif [[ "$RESULTS" =~ "null" ]]
    then
        echo "Return value is null!"
        exit 1
    else
        echo "Something went wrong! Please review logs"
        echo "results: ${RESULTS}"
        exit 1
    fi
done