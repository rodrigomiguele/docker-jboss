FROM rodrigomiguele/jboss:6.4.0-EAP

ENV JAVA_OPTS "$JAVA_OPTS -Dfile.encoding=UTF-8 -Xms256m -Xmx1g -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=~/heapdump_$DATE_START.hprof -Dorg.jboss.resolver.warning=true"

ADD customization $JBOSS_HOME/customization/

RUN $JBOSS_HOME/customization/execute.sh

RUN $JBOSS_HOME/bin/add-user.sh -u hostOne -p password_1 -r ManagementRealm

RUN mv $JBOSS_HOME/domain/configuration/host_xml_history/current $JBOSS_HOME/domain/configuration/domain_xml_history/20160311-020413551

EXPOSE 9999 9990 8080

COPY start-application /usr/local/bin

ENV MASTER_NAME master
ENV MASTER_PASSWORD Master@01

CMD ["start-application"]
