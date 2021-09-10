#!/bin/bash
set -e

rm -f /docker_rails/tmp/pids/server.pid
rm -f /docker_rails/tmp/pids/unicorn.pid

exec "$@"