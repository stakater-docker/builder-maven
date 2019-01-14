# builder-maven
A maven builder image used to build maven apps

This image runs as user `jenkins` with id `10000`, so that it can run maven as a non-root user which can access Jenkins directories and files as well, in order to seamlessly run as a Jenkins slave.