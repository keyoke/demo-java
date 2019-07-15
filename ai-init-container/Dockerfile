FROM alpine

# Replace this with the current version
ARG APPINSIGHTS_VERSION
ENV AGENT_JAR_NAME applicationinsights-agent-${APPINSIGHTS_VERSION}.jar
ENV CORE_JAR_NAME applicationinsights-core-${APPINSIGHTS_VERSION}.jar

RUN apk --no-cache add curl

# https://github.com/microsoft/ApplicationInsights-Java/wiki/Using-Application-Insights-in-a-Dockerfile
# Get The Application Insights Agent JAR via curl, it should exist outside the Tomcat's and your application's classpath.
RUN curl -L --create-dirs -o /opt/aiagent/applicationinsights-agent.jar https://github.com/microsoft/ApplicationInsights-Java/releases/download/${APPINSIGHTS_VERSION}/${AGENT_JAR_NAME}
RUN curl -L --create-dirs -o /opt/aiagent/applicationinsights-core.jar https://github.com/microsoft/ApplicationInsights-Java/releases/download/${APPINSIGHTS_VERSION}/${CORE_JAR_NAME}
COPY AI-Agent.xml /opt/aiagent/AI-Agent.xml
COPY ApplicationInsights.xml /opt/aiagent/ApplicationInsights.xml

COPY init-container.sh /tmp/
ENTRYPOINT ["sh","/tmp/init-container.sh"]
