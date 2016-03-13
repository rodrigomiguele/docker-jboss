FROM rodrigomiguele/oracle-jdk:debian-jdk7

ENV JBOSS_URL https://olex-secure.openlogic.com/content/openlogic/jboss/7.2.0.Final/openlogic-jboss-7.2.0.Final-all-bin-1.zip

RUN apt-get update \
    && apt-get install -y curl unzip

RUN cd /opt \
    && curl -O https://olex-secure.openlogic.com/content/openlogic/jboss/7.2.0.Final/openlogic-jboss-7.2.0.Final-all-bin-1.zip \
    && unzip -q openlogic-jboss-7.2.0.Final-all-bin-1.zip \
    && mv /opt/jboss-7.2.0.Final/jboss-as-7.2.0.Final/ /opt/jboss \
    && rm -rf /opt/jboss-7.2.0.Final/ \
    && rm /opt/openlogic-jboss-7.2.0.Final-all-bin-1.zip

ENV JBOSS_HOME /opt/jboss

RUN AUTO_ADDED_PACKAGES=`apt-mark showauto` && \
    apt-get remove --purge -y curl unzip $AUTO_ADDED_PACKAGES

