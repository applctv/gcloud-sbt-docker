FROM google/cloud-sdk:latest

# Add needed APT repositories
RUN apt-get install -y apt-transport-https
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN echo "deb https://deb.nodesource.com/node_7.x jessie main" | tee -a /etc/apt/sources.list.d/node.list
RUN apt-get update -y

# Install Java 8 & SBT
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer sbt

# Install NPM & Typescript
# The last "Done" is necessary, otherwise container building halts
# Force yes is to accept unauthenticated nodejs package
RUN apt-get install -y --force-yes nodejs build-essential && echo "Done"
RUN npm install -g typescript
RUN npm install --save-dev @types/jquery

CMD java -version
