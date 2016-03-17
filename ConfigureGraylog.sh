#!/usr/bin/env bash

TRUSTSTORE_FILE=/opt/graylog/conf/nginx/ca/restcomm-combined.jks

function download_conf(){
echo "url $1 $2 $3"
wget -S --spider $1 $2 $3 2>&1 | grep 'HTTP/1.1 200 OK'
VAR=`wget -S --spider $1 $2 $3 2>&1 | grep 'HTTP/1.1 200 OK'`

if [ -n "$VAR" ]; then
           if [ -n "$2" ] && [ -n "$3" ]; then
                wget $1 $2 $3 -O $4
           else
                wget $1 -O $2
            fi
                return 0;
else
                echo "false"
                exit 1;
  fi
}


sed -i "s/^default\['graylog'\]\['graylog-server'\]\['memory'\]\s\=\s\"1500m\"$/default['graylog']['graylog-server']['memory'] \= \"4000m\"/" \
                  /opt/graylog/embedded/cookbooks/graylog/attributes/default.rb && \
sed -i "s/\#\snode\.name\:\s\"Franz\sKafka\"/node\.name\: RestComm01/" /opt/graylog/embedded/cookbooks/graylog/templates/default/elasticsearch.yml.erb

cat >> /opt/graylog/embedded/share/docker/run_graylogctl <<EOM
if [ ! -z "\$GRAYLOG_ENFORCE_SSL" ]; then
        sudo graylog-ctl enforce-ssl
        sudo graylog-ctl reconfigure
fi
EOM

sed -i "s/^default\['graylog'\]\['graylog-server'\]\['content_packs_auto_load'\]\s\=\s\"grok-patterns.json,content_pack_appliance.json\"$/default['graylog']['graylog-server']['content_packs_auto_load'] \= \"grok-patterns.json,Template_ContentPack.json,LoadBalancer_ContentPack.json\"/" \
/opt/graylog/embedded/cookbooks/graylog/attributes/default.rb

sudo chmod 777 /opt/graylog/plugin/graylog2-plugin-input-httpmonitor*.jar

if [ "$SECURESSL" = "TRUE"  ]; then
   if [ -n "$CERTCONFURL" ]; then
        echo "Certification file URL is: $CERTCONFURL"
        if [ -n "$CERTREPOUSR"  ] && [ -n "$CERTREPOPWRD" ]; then
  		    USR="--user=${CERTREPOUSR}"
  		    PASS="--password=${CERTREPOPWRD}"
        fi
        URL="$CERTCONFURL $USR $PASS"
        echo "$URL"
        download_conf $URL $TRUSTSTORE_FILE
    else
         echo "Error, need to set CERTCONFURL"
        exit 1
    fi

    if [ -n "$TRUSTSTORE_PASSWORD" ] && [ -n "$TRUSTSTORE_ALIAS" ] ; then
        echo "Ok, we can generate: graylog.key &  graylog.crt"

        cd /opt/graylog/conf/nginx/ca/
        /opt/graylog/embedded/jre/bin/keytool  -importkeystore -srckeystore restcomm-combined.jks -destkeystore keystore.p12 -deststoretype PKCS12 -srcalias `echo $TRUSTSTORE_ALIAS`  -deststorepass `echo $TRUSTSTORE_PASSWORD`  -destkeypass `echo $TRUSTSTORE_PASSWORD` --srcstorepass `echo $TRUSTSTORE_PASSWORD`
        openssl pkcs12 -in keystore.p12   -nokeys   -out graylog.crt -passin pass:`echo $TRUSTSTORE_PASSWORD`
        openssl pkcs12 -in keystore.p12   -nocerts -nodes  -out graylog.key -passin pass:`echo $TRUSTSTORE_PASSWORD`
    else
         echo "Error, need to set TRUSTSTORE_PASSWORD & TRUSTSTORE_ALIAS"
        exit 1
    fi
fi
