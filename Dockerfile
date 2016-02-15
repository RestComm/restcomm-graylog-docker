FROM graylog2/allinone:latest
RUN  apt-get update \
  && apt-get install -y wget

COPY ./ConfigureGraylog.sh /etc/my_init.d/configureGraylog.sh
RUN chmod +x /etc/my_init.d/configureGraylog.sh

COPY ./Template_ContentPack.json /opt/graylog/contentpacks/

ADD https://github.com/sivasamyk/graylog2-plugin-input-httpmonitor/releases/download/v1.0.2/graylog2-plugin-input-httpmonitor-1.0.2.jar opt/graylog/plugin/

RUN mkdir  /opt/graylog/sv/index
COPY ./result_template.sh /opt/graylog/sv/index/run
RUN chmod +x /opt/graylog/sv/index/run

