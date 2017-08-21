FROM ubuntu:17.04

MAINTAINER Christian Geser, christian.geser@doubleslash.de

# Install Java
RUN apt-get update && apt-get install -y software-properties-common python-software-properties unzip wget tar ssh less curl
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $PATH:$JAVA_HOME/bin

RUN curl -O -k -L https://10gbps-io.dl.sourceforge.net/project/lportal/Liferay%20Portal/7.0.3%20GA4/liferay-ce-portal-tomcat-7.0-ga4-20170613175008905.zip \
 && unzip liferay-ce-portal-tomcat-7.0-ga4-20170613175008905.zip -d /opt \
 && rm liferay-ce-portal-tomcat-7.0-ga4-20170613175008905.zip
RUN ln -s /opt/liferay-ce-portal-7.0-ga4 /opt/liferay \
 && ln -s /opt/liferay/tomcat-8.0.32 /opt/liferay/tomcat
RUN echo -e '\nCATALINA_OPTS="$CATALINA_OPTS -Djava.security.egd=file:/dev/./urandom"' >> /opt/liferay/tomcat/bin/setenv.sh
COPY assets/supervisord.conf /etc/supervisord.conf
COPY assets/init.sh /opt/liferay/init.sh
VOLUME ["/opt/liferay"]
EXPOSE 8080
CMD /usr/bin/supervisord -n
