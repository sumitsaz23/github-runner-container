#Base image
FROM ubuntu:latest
LABEL maintainer="Sumit sur"
LABEL description="GitHub Actions self-hosted runner in a container"

# set the github runner version
#update the version as needed from https://github.com/actions/runner/releases
ARG RUNNER_VERSION
ARG PLATFORM

# update the base packages and add a non-sudo user (docker) to run the container
# this is necessary to run the github actions runner as it requires a non-root user
# you can change the username to whatever you like, but make sure to update the user in the entrypoint script
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

# cd into the user directory, download and unzip the github actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${PLATFORM}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-${PLATFORM}-${RUNNER_VERSION}.tar.gz

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh


# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]