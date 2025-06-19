#!/bin/bash

REPO=$GITHUB_REPOSITORY
ACCESS_TOKEN=$GH_ACCESS_TOKEN

echo "REPO ${REPO}"
echo "ACCESS_TOKEN ${ACCESS_TOKEN}"

curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/repos/${REPO}/actions/runners/registration-token | jq .token --raw-output

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/repos/${REPO}/actions/runners/registration-token | jq .token --raw-output)


echo "REG_TOKEN ${REG_TOKEN}"

cd /home/docker/actions-runner

./config.sh --url https://github.com/${REPO} --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!