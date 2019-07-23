FROM jenkins/jnlp-slave:alpine as jnlp

FROM node:alpine

RUN apk -U add openjdk8-jre wget tar gzip git

RUN wget -c https://github.com/gohugoio/hugo/releases/download/v0.55.6/hugo_0.55.6_Linux-64bit.tar.gz -O - | tar -xz
RUN mv hugo /usr/local/bin/hugo

COPY --from=jnlp /usr/local/bin/jenkins-slave /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/slave.jar /usr/share/jenkins/slave.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
