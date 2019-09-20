#!/bin/bash
set -e

service mongodb start
service elasticsearch start
#service graylog-server start

exec "$@"