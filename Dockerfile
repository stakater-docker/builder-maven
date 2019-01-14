FROM stakater/pipeline-tools:SNAPSHOT-PR-6-15

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Changing user to root to install maven
USER root

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
RUN addgroup -g 233 docker && \
    adduser -D -u 10000 -h /home/jenkins -G docker jenkins

# Change to jenkins user
USER jenkins

# Define default command, can be overriden by passing an argument when running the container
CMD ["mvn","-version"]