#!/bin/bash

echo "---"
echo "Initialisation of GitLab for The Farm project"
echo "---"

echo "...installing Docker Engine"
yum update
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
yum install docker-engine

echo "...starting Docker"
service docker start

echo "...initialising GitLab"
docker run --detach \
    --hostname gitlab.the-farm.local \
    --env GITLAB_OMNIBUS_CONFIG="gitlab_rails['gitlab_email_from'] = 'gitlab@the-farm.local'; gitlab_rails['gitlab_email_display_name'] = 'GitLab @ The Farm'; " \
    --publish 443:443 --publish 80:80 --publish 22:22 \
    --name gitlab_the-farm \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
