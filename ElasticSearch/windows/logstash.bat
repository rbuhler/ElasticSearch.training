SET logstash_home=\Users\i820244\DevTools\logstash-5.4.0\bin\
SET logstash_exec=%logstash_home%logstash.bat

cls
echo Starting Logstash ...
echo %logstash_exec%
%logstash_exec% --path.settings=/C:/Users/i820244/DevTools/logstash-5.4.0/config -f /C:/Users/i820244/DevTools/logstash-5.4.0/yourlogstash.conf