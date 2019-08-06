# First lets build the 
FROM gradle:5.5-jdk8 as builder

#ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Zurich
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \ 
    ca-certificates-java \
    atk1.0 \
    gtk+2.0 \
    libatk-wrapper-java-jni \
    libsctp1 \
    libpulse0 \
    curl \
    software-properties-common

# Really nasty hack could be done better Im sure! We need Java 7 JRE to perform the build of AI, there is no gradle tag for 7.
RUN mkdir /tmp/java7/
RUN curl -o /tmp/java7/openjdk-7-jre_7u181-2.6.14-1~deb8u1_amd64.deb http://ftp.de.debian.org/debian/pool/main/o/openjdk-7/openjdk-7-jre_7u181-2.6.14-1~deb8u1_amd64.deb && \
    curl -o /tmp/java7/openjdk-7-jre-headless_7u181-2.6.14-1~deb8u1_amd64.deb http://ftp.de.debian.org/debian/pool/main/o/openjdk-7/openjdk-7-jre-headless_7u181-2.6.14-1~deb8u1_amd64.deb && \
    curl -o /tmp/java7/libjpeg62-turbo_1.5.2-2+b1_amd64.deb http://ftp.de.debian.org/debian/pool/main/libj/libjpeg-turbo/libjpeg62-turbo_1.5.2-2+b1_amd64.deb && \
    curl -o /tmp/java7/libgif4_4.1.6-11+deb8u1_amd64.deb http://ftp.br.debian.org/debian/pool/main/g/giflib/libgif4_4.1.6-11+deb8u1_amd64.deb && \
    curl -o /tmp/java7/libpng12-0_1.2.50-2+deb8u3_amd64.deb http://ftp.br.debian.org/debian/pool/main/libp/libpng/libpng12-0_1.2.50-2+deb8u3_amd64.deb && \
    dpkg -i --ignore-depends=initscripts,tzdata-java /tmp/java7/*.deb

ENV JAVA_JRE_7 /usr/lib/jvm/java-7-openjdk-amd64/jre
RUN export JAVA_JRE_7

# Tweak our jvm options for the build
ENV GRADLE_OPTS "-Xmx256m -Xms256m -Dorg.gradle.daemon=false"
RUN export GRADLE_OPTS

COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN git clone https://github.com/microsoft/ApplicationInsights-Java.git && \
    cd ApplicationInsights-Java && \
    git checkout codeless
WORKDIR /home/gradle/src/ApplicationInsights-Java
RUN gradle build -x test -DskipWinNative=true -DisBuildServer=true

FROM alpine
# Pass in the version for current codeless agent
ARG AI_AGENT_CODELESS_VERSION=2.5.0-BETA.3
COPY --from=builder /home/gradle/src/ApplicationInsights-Java/agent-codeless/build/libs/applicationinsights-agent-codeless-${AI_AGENT_CODELESS_VERSION}-SNAPSHOT.jar /opt/aiagent/applicationinsights-agent.jar
COPY ApplicationInsights.json /opt/aiagent/ApplicationInsights.json

COPY init-container.sh /tmp/
ENTRYPOINT ["sh","/tmp/init-container.sh"]
