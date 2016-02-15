#!/bin/bash


if [[ `curl -XHEAD -i localhost:9200/_template/graylog_per_index 2>&1  | grep 'HTTP/1.1 404 Not Found'` ]]; then

curl -XPUT localhost:9200/_template/graylog_per_index -d '
{
"template" : "graylog_*",
"mappings" : {
"message": {
"properties": {
"result" : { "type" : "string" }
}
}
}
}'


elif [[ `curl -XHEAD -i localhost:9200/_template/graylog_per_index 2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
rm -rf /opt/graylog/sv/index/
fi
