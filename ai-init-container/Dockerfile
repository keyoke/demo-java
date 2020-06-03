FROM alpine
# Pass in the version for agent
ARG AI_AGENT_VERSION=3.0.0-PREVIEW
RUN apk add --update \
    curl \
    && rm -rf /var/cache/apk/*
RUN curl -o /opt/aiagent/applicationinsights-agent.jar --create-dirs -L https://github.com/microsoft/ApplicationInsights-Java/releases/download/${AI_AGENT_VERSION}/applicationinsights-agent-${AI_AGENT_VERSION}.jar
COPY ApplicationInsights.json /opt/aiagent/ApplicationInsights.json

COPY init-container.sh /tmp/
ENTRYPOINT ["sh","/tmp/init-container.sh"]
