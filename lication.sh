#!/bin/bash

results=""
echo "${LICATION_ARTIFACT_URL}"
echo "${GIT_REPO_URL}"
echo "${GIT_REPO_URL}"
echo "${LICATION_BACKEND}"
echo "${BUILD_NUMBER}"

    curl -XPOST -H 'Content-type: application/json' -d "{
        \"artifactUrl\": \"${LICATION_ARTIFACT_URL}\",
        \"artifactUser\": \"${ART_USERNAME}\",
        \"artifactPass\": \"${ART_PASSWORD}\",
        \"githubUrl\": \"${GIT_REPO_URL}\", \"jenkinsJobID\": \"${BUILD_NUMBER}\",
        \"githubCreds\": \"${GIT_TOKEN}\"
        }" "${LICATION_BACKEND}"


while [ "$results" = "" ]
do 
    echo "Checking scan status..."
    results=`curl "${LICATION_BACKEND}"/sha/"${CHECKSUM}" | jq -r '.scanStatus'`
    echo "${results}"
    echo "Results stats above"


    if [ "$results" = 2 ]
    then
        echo "Scan status is still pending..."
        results=""
        sleep ${SLEEP_SECOND}
    
    elif [ "$results" = 0 ]
    then
        echo -e "Scan completed!\n"
        echo "No vulnerabilities found, deploying ${APPLICATION_NAME}..."
        cd "${WORKSPACE}"/"$PROJECT_NAME"
        curl -X POST \
            -H 'Content-Type: application/zip' \
            --data-binary @"pcf_artifacts.zip" \
            "${PCF_ENDPOINT}${PCF_ENV}/${PCF_ORG}/${PCF_SPACE}/${APPLICATION_NAME}"
    
    elif [ "$results" = 1 ]
    then
        echo -e "Scan Completed!\n"
        echo -e "Security Test Failed! Cannot Deploy ${APPLICATION_NAME}!"
        exit 1
    elif [[ "$results" =~ "null" ]]
    then
        echo "Return value is null!"
        exit 1
    else
        echo "Something went wrong! Please review logs"
        exit 1
    fi
done