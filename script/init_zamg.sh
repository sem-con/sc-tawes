#!/bin/bash

rm -f /usr/src/app/tmp/pids/server.pid /usr/src/app/log/*.log
rails server -b 0.0.0.0 &
export RAILS_PID=$!
bash -c 'while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' localhost:3000/api/active)" != "200" ]]; do sleep 5; done'
/usr/src/app/script/init.rb "$1"
kill $RAILS_PID
rails s puma -b 'ssl://0000:3000?key=/certs/vownyourdata.zamg.ac.at.key&cert=/certs/vownyourdata.zamg.ac.at.crt&verify_mode=none' &
sleep infinity