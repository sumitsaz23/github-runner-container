#!/bin/bash

REPO=$GITHUB_REPOSITORY
ACCESS_TOKEN=$GH_ACCESS_TOKEN

echo "REPO ${REPO}"
echo "ACCESS_TOKEN ${ACCESS_TOKEN}"


# # 1. Check raw response & status
# curl -i -H "Authorization: token ${ACCESS_TOKEN}" \
#      -H "Accept: application/vnd.github+json" \
#      https://api.github.com/repos/${REPO}/actions/runners/registration-token

# # 2. If that's good, inspect the JSON
# TOKEN=$(curl -s -H "Authorization: token ${ACCESS_TOKEN}" \
#                -H "Accept: application/vnd.github+json" \
#                https://api.github.com/repos/${REPO}/actions/runners/registration-token)

# echo "Raw JSON: $TOKEN"

# echo "$TOKEN" | jq .token --raw-output

# REG_TOKEN = $(echo "$TOKEN" | jq .token --raw-output)


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