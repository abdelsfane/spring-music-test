#!/bin/bash

GIT_REPO_URL="${GIT_REPO_URL%.*}"
LICATION_STATUS=`curl -XPOST -H 'Content-type: application/json' -d "{
    \"artifactUrl\": \"${LICATION_ARTIFACT_URL}${APPLICATION_NAME}_${BUILD_NUMBER}.jar\",
    \"artifactUser\": \"${ART_USERNAME}\",
    \"artifactPass\": \"${ART_PASSWORD}\",
    \"githubUrl\": \"${GIT_REPO_URL}\",
    \"jenkinsJobID\": \"${BUILD_NUMBER}\",
    \"githubCreds\": \"${GIT_TOKEN}\"
}" "${LICATION_BACKEND}"`

echo "LICATION_STATUS: ${LICATION_STATUS}"