#stuff for deployment
working_directory "/var/www/eyebleach"
pid "/var/www/eyebleach/pids/unicorn.pid"
sterr_path "/var/www/eyebleach/log/unicorn.log"
stout_path "/var/www/eyebleach/log/unicorn.log"

listen "/tmp/unicorn.[eyebleach].sock"
listen "/tmp/unicorn.eyebleach.sock"

worker_processes 2

timeout 30
