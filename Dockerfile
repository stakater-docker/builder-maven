FROM stakater/pipeline-tools:SNAPSHOT-PR-8-11

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'readlink -f /usr/bin/java | sed "s:/bin/java::"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.191.b12-1.el7_6.x86_64
ENV PATH $PATH:${JAVA_HOME}/jre/bin:/usr/lib/jvm/${JAVA_HOME}/bin

ENV JAVA_VERSION 8u191
ENV JAVA_YUM_VERSION 1.8.0.191.b12

RUN yum install -y java-1.8.0-openjdk-devel-${JAVA_YUM_VERSION}

# Setting Maven Version that needs to be installed
ARG MAVEN_VERSION=3.5.4

# Maven
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_VERSION=${MAVEN_VERSION} \
	M2_HOME=/usr/share/maven \
	maven.home=$M2_HOME \
	M2=$M2_HOME/bin \
	PATH=$M2:$PATH

# Add jenkins user with hardcoded ID (the one that jenkins expects)
RUN groupadd -g 233 docker && \
    adduser -u 10000 -d /home/jenkins -g docker jenkins && \
    passwd -d jenkins

# Change to jenkins user
USER jenkins

ENV HOME /home/jenkins

# Define default command, can be overriden by passing an argument when running the container
CMD ["mvn","-version"]