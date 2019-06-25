FROM tomcat:8.5
MAINTAINER Tung Nguyen <tongueroo@gmail.com>

# Debugging tools: A few ways to handle debugging tools.
# Trade off is a slightly more complex volume mount vs keeping the image size down.
RUN apt-get update && \
  apt-get install -y \
    net-tools \
    tree \
    vim && \
  rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get purge

# Replace this with the current version
ARG APPINSIGHTS_VERSION
ENV AGENT_JAR_NAME applicationinsights-agent-${APPINSIGHTS_VERSION}.jar
ENV AI_WEB_JAR_NAME applicationinsights-web-${APPINSIGHTS_VERSION}.jar

# https://github.com/microsoft/ApplicationInsights-Java/wiki/Using-Application-Insights-in-a-Dockerfile
# Get The Application Insights Agent JAR via curl, it should exist outside the Tomcat's and your application's classpath.
RUN curl -L --create-dirs -o /opt/aiagent/${AGENT_JAR_NAME} https://github.com/microsoft/ApplicationInsights-Java/releases/download/${APPINSIGHTS_VERSION}/${AGENT_JAR_NAME}
COPY AI-Agent.xml /opt/aiagent/AI-Agent.xml
RUN curl -L -o ${CATALINA_HOME}/lib/${AI_WEB_JAR_NAME} https://github.com/microsoft/ApplicationInsights-Java/releases/download/${APPINSIGHTS_VERSION}/${AI_WEB_JAR_NAME}
COPY ApplicationInsights.xml ${CATALINA_HOME}/lib/ApplicationInsights.xml

RUN echo 'export JAVA_OPTS="${JAVA_OPTS} -Dapp.env=staging -javaagent:/opt/aiagent/${AGENT_JAR_NAME}"'> /usr/local/tomcat/bin/setenv.sh

RUN chmod 711 /usr/local/tomcat/bin/setenv.sh
COPY pkg/demo.war /usr/local/tomcat/webapps/demo.war

EXPOSE 8080
CMD ["catalina.sh", "run"]