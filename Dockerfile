FROM maven:3.5-jdk-8-alpine                                                                                                                                           
RUN apk update && apk add git

VOLUME ["/app", "/war-skeleton", "/xwar-skeleton", "/maven"]
ENV M2_HOME=/maven

ENTRYPOINT ["/bin/sh"]
