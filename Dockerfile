FROM google/cloud-sdk:latest

# Add needed APT repositories
RUN apt-get update && apt-get install -y apt-transport-https curl gnupg wget
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | tee /etc/apt/trusted.gpg.d/sbt.asc
# Java 8 from Adoptium
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
RUN echo "deb https://packages.adoptium.net/artifactory/deb bookworm main" | tee /etc/apt/sources.list.d/adoptium.list
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get update -y

# Install Java 8 & SBT
RUN apt-get install -y temurin-8-jdk sbt

# Set Java 8 as default
ENV JAVA_HOME=/usr/lib/jvm/temurin-8-jdk-amd64
RUN update-alternatives --set java $JAVA_HOME/bin/java && \
    update-alternatives --set javac $JAVA_HOME/bin/javac

ENV PATH=$JAVA_HOME/bin:$PATH

# Install NPM & Typescript
# The last "Done" is necessary, otherwise container building halts
# Force yes is to accept unauthenticated nodejs package
RUN apt-get install -y --force-yes nodejs build-essential && echo "Done"
RUN npm install -g typescript
RUN npm install -g @types/jquery

# Update GCloud
# Instructions from https://cloud.google.com/sdk/docs/downloads-apt-get
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get install -y apt-transport-https ca-certificates gnupg
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update -y
RUN apt-get --only-upgrade -y install kubectl google-cloud-sdk google-cloud-sdk-app-engine-grpc google-cloud-sdk-pubsub-emulator google-cloud-sdk-app-engine-go google-cloud-sdk-datastore-emulator google-cloud-sdk-app-engine-python google-cloud-sdk-cbt google-cloud-sdk-bigtable-emulator google-cloud-sdk-app-engine-python-extras google-cloud-sdk-datalab google-cloud-sdk-app-engine-java
# RUN gcloud components update
RUN gcloud components list

CMD ["java", "-version"]
