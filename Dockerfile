FROM rodrigomiguele/jboss:6.4.0-EAP

ENV JAVA_OPTS "$JAVA_OPTS -Dfile.encoding=UTF-8 -Xms256m -Xmx1g -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=~/heapdump_$DATE_START.hprof -Dorg.jboss.resolver.warning=true"
ENV MASTER_HOST_NAME master
ENV MASTER_USERNAME master
ENV MASTER_PASSWORD Master@01

ADD customization $JBOSS_HOME/customization/

RUN $JBOSS_HOME/customization/execute.sh $JBOSS_HOME/customization/commands1.cli && \
    $JBOSS_HOME/customization/execute.sh $JBOSS_HOME/customization/commands2.cli

RUN mv $JBOSS_HOME/domain/configuration/host_xml_history/current $JBOSS_HOME/domain/configuration/domain_xml_history/20160311-020413551

EXPOSE 9999 9990 8080

COPY start-application /usr/local/bin

CMD ["start-application"]
