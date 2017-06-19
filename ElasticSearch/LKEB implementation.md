# https://www.elastic.co/
LKEB
[JAM LKEB](https://jam4.sapjam.com/groups/about_page/oEBlwpGE1ZoWIvrdfgjsRL)
[JAM PerfX](https://jam4.sapjam.com/groups/about_page/pleCfjogSvhtRhOssiLyWl)

## ELASTICSEARCH
[elastic.co](https://www.elastic.co/products/elasticsearch)

## KIBANA
[elastic.co](https://www.elastic.co/products/kibana)

## LOGSTASH
[elastic.co](https://www.elastic.co/products/logstash)

### READING
[<< Configuring Logstash >>](https://www.elastic.co/guide/en/logstash/current/configuration.html)

Change config file
* **logstash.yml**
  * config.reload.automatic: true

### DOC
* [Stashing Your First Event](https://www.elastic.co/guide/en/logstash/current/first-event.html)

Logstash pipeline: 

**ELEMENTS**
* Input
* Filter (_optional_)
* Output

### ISSUES AND DOUBTS

[Issue log4j2](https://discuss.elastic.co/t/info-windows-logstash-and-could-not-find-log4j2-configuration/67633)
* System variable in Windows
```
LS_SETTINGS_DIR
/C:/Users/i820244/DevTools/logstash-5.4.0/config
```
## Beats
[elastic.co](https://www.elastic.co/products/beats)

### Filebeat
[elastic.co](https://www.elastic.co/products/beats/filebeat)

## Files
* filebit.template.json
* Start the daemon by running 
```
$[filebeat] ./filebeat -e -c filebeat.yml
```
