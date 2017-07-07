[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bhttps%3A%2F%2Fgithub.com%2FRestComm%2Frestcomm-graylog-docker.svg?type=shield)](https://app.fossa.io/projects/git%2Bhttps%3A%2F%2Fgithub.com%2FRestComm%2Frestcomm-graylog-docker?ref=badge_shield)

﻿# Graylog docker image for monitoring Restcomm.

Graylog in principle is an Open Source Log Management system. 

More: https://www.graylog.org/https://www.graylog.org/


Graylog's great suit apart of the main functionality has received great extension abilities from the community.

 
For Restcomm Raas production servers, we will use an extension plug-in for monitoring functional activity on the servers through HTTP/HTTPS requests.

See: http://www.telestax.com/enterprise-monitoring-for-restcomm-part-3/

The plug-in we are using for that is “HTTP Monitor Input Plugin”

More on Graylog Marketplace :

https://marketplace.graylog.org/addons/1f95ab1c-08d5-4742-99f6-2bf41005bb8b
    
GitHub:

https://github.com/sivasamyk/graylog2-plugin-input-httpmonitor


### Docker image - Graylog (1.3.3) full stack installation - maintained by Graylog, Inc.

This repository, creates a Graylog Docker container, personalised for Monitoring RestComm Cloud instance.
 
 
### Prerequisites
The image has been tested with Docker __1.7__ && __1.9__.

### Supported Tags

* __latest:__ Using this tag you will get the latest RestComm-Graylog build. __restcomm/restcomm/graylog-restcomm__


*To pull the image please use: docker pull restcomm/graylog-restcomm:latest

### Environment variables 

RestComm-Graylog-Docker container provides the following flags that can be set to the RUN command.

* __SECURESSL__ Use Authorised certificate JKS file, If not set a self-signed certificate will be generated. 
   * __CERTCONFURL__ URL to download jks file, for HTTSP - obligatory if ```SECURESSL``` set.
   * __TRUSTSTORE_PASSWORDL__ Password for the authorized jks file - obligatory if ```SECURESSL``` set.
   * __TRUSTSTORE_ALIAS__ Alias for the authorized jks file - obligatory if ```SECURESSL``` set.


### Persist data using host filesystem

You can persist the logs, database, so even if you stop and remove your container, your data won't be lost.


Need to add the following to  the RUN command:
-v /graylog2/data:/var/opt/graylog/data -v /graylog2/logs:/var/log/graylog 

* Graylog data ```-v $YOUR_FOLDER/data:/var/opt/graylog/data ```
* Graylog logs ```-v $YOUR_FOLDER/logs:/var/log/graylog```

*It is necessary to manually create at the host the root directory ($YOUR_FOLDER), not the subdirectories (data,logs) 
they will be created automatically.


### RUN command for RestComm-Graylog
 
 Usually the command that needs to be run is:
 
```docker run --rm -t --ulimit nofile=1024:64000 -p 443:443 -p 80:9000 -p 12201:12201 -p 9200:9200 -p 12900:12900 -p 12201:12201/udp -p 5555:5555 -p 6666:6666 -p 7777:7777 -e GRAYLOG_NODE_ID=AddGraylogId  -e GRAYLOG_ENFORCE_SSL="TRUE" -e SECURESSL="TRUE" -e GRAYLOG_SERVER_SECRET=AddGraylogSecret -e GRAYLOG_USERNAME=USER_NAME -e GRAYLOG_TIMEZONE=Europe/Berlin -e GRAYLOG_RETENTION="--size=3 --indices=10" -e ES_MEMORY=4g -e GRAYLOG_PASSWORD=PassWord -e GRAYLOG_SMTP_SERVER="smtp-email-server --no-tls --no-ssl --port=587 --user=UserForEmailProvider --password=PassWordForEmail --from-email=email@domain.com" -v /graylog/data:/var/opt/graylog/data -v /graylog/logs:/var/log/graylog    --name=restcomm-graylog restcomm/restcomm-graylog:latest```



## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bhttps%3A%2F%2Fgithub.com%2FRestComm%2Frestcomm-graylog-docker.svg?type=large)](https://app.fossa.io/projects/git%2Bhttps%3A%2F%2Fgithub.com%2FRestComm%2Frestcomm-graylog-docker?ref=badge_large)