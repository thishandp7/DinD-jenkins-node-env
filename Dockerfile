FROM jenkins/jenkins

ENV DEBIAN_FRONTEND noninteractive

USER root

#497 is the gid for ECS instances
ARG DOCKER_GID=497

RUN groupadd -g ${DOCKER_GID:-497} docker

RUN apt-get -y update && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash && \
    apt-get install -y nodejs && \
    apt-get install -y build-essential

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gcc make \
    libssl-dev -y

RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce && \
    usermod -a -G docker jenkins && \
    usermod -a -G users jenkins

RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

USER jenkins
