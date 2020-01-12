#!/bin/bash

results=""
CURL_SHA="18.218.151.201:8080/sha/${CHECKSUM}"
GIT_REPO_URL="${GIT_REPO_URL%.*}"
echo "LICATION_ARTIFACT_URL: ${LICATION_ARTIFACT_URL}${APPLICATION_NAME}_${BUILD_NUMBER}.jar"
echo "ART_USERNAME: ${ART_USERNAME}"
echo "GIT_REPO_URL: ${GIT_REPO_URL}"
echo "BUILD_NUMBER: ${BUILD_NUMBER}"
echo "LICATION_BACKEND: ${LICATION_BACKEND}"
echo "CHECKSUM: ${CHECKSUM}"
echo "STATUS_ENDPOINT: ${STATUS_ENDPOINT}"
echo "CURL SHA: ${CURL_SHA}"

    lication_status=`curl -XPOST -H 'Content-type: application/json' -d "{
        \"artifactUrl\": \"${LICATION_ARTIFACT_URL}${APPLICATION_NAME}_${BUILD_NUMBER}.jar\",
        \"artifactUser\": \"${ART_USERNAME}\",
        \"artifactPass\": \"${ART_PASSWORD}\",
        \"githubUrl\": \"${GIT_REPO_URL}\",
        \"jenkinsJobID\": \"${BUILD_NUMBER}\",
        \"githubCreds\": \"${GIT_TOKEN}\"
        }" "${LICATION_BACKEND}"`

    echo "${lication_status}"


while [ "$results" = "" ]
do 
    echo "Checking scan status..."
    results=`curl 18.218.151.201:8080/sha/${CHECKSUM}`
    # results=`curl ${STATUS_ENDPOINT}"/sha/"${CHECKSUM} | jq -r '.scanStatus'`
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
        cd "${WORKSPACE}/$PROJECT_NAME"
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
        curl ${STATUS_ENDPOINT}"/sha/"${CHECKSUM} | jq -r '.scanStatus'

        exit 1
    else
        echo "Something went wrong! Please review logs"
        echo "results: ${results}"
        exit 1
    fi
done