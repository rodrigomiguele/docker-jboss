FROM rodrigomiguele/jboss:6.4.0-EAP

ENV JAVA_OPTS "$JAVA_OPTS -Dfile.encoding=UTF-8 -Xms256m -Xmx1g -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=~/heapdump_$DATE_START.hprof -Dorg.jboss.resolver.warning=true"

ADD customization $JBOSS_HOME/customization/

RUN $JBOSS_HOME/customization/execute.sh

RUN cd $JBOSS_HOME/domain/configuration && \
	sed -e '/<security-realm name="ManagementRealm">/q' host.xml > host1.xml && \
	echo -n "<server-identities><secret value=\"" >> host1.xml && \
	echo -n "MASTER_PASSWORD" >> host1.xml && \
	echo "\" /></server-identities>" >> host1.xml && \
	sed -e '1,/<security-realm name="ManagementRealm">/d' host.xml >> host1.xml && \
	mv host1.xml host.xml

RUN mv $JBOSS_HOME/domain/configuration/host_xml_history/current $JBOSS_HOME/domain/configuration/domain_xml_history/20160311-020413551

EXPOSE 9990 8080

ENV SLAVE_HOST_NAME slave
ENV SLAVE_SERVER_NAME SlaveServer
ENV SERVER_GROUP main-server-group

COPY start-application /usr/local/bin

CMD ["start-application"]
