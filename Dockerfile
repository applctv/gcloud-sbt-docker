FROM google/cloud-sdk:latest

# Add needed APT repositories
RUN apt-get install -y apt-transport-https
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 1655A0AB68576280  
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv C2518248EEA14886  
RUN echo "deb https://deb.nodesource.com/node_8.x jessie main" | tee -a /etc/apt/sources.list.d/node.list
RUN apt-get update -y

# Install Java 8 & SBT
RUN apt-get install -y openjdk-8-jdk sbt

# Install NPM & Typescript
# The last "Done" is necessary, otherwise container building halts
# Force yes is to accept unauthenticated nodejs package
RUN apt-get install -y --force-yes nodejs build-essential npm && echo "Done"
RUN npm install -g typescript
RUN npm install --save-dev @types/jquery

# Update GCloud
# Instructions from https://cloud.google.com/sdk/docs/downloads-apt-get
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get install -y apt-transport-https ca-certificates gnupg
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update -y
RUN apt-get --only-upgrade -y install kubectl google-cloud-sdk google-cloud-sdk-app-engine-grpc google-cloud-sdk-pubsub-emulator google-cloud-sdk-app-engine-go google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-python google-cloud-sdk-cbt google-cloud-sdk-bigtable-emulator google-cloud-sdk-app-engine-python-extras google-cloud-sdk-datalab google-cloud-sdk-app-engine-java
# RUN gcloud components update
RUN gcloud components list

CMD java -version
