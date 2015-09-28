#!/bin/bash
env | grep sidewinder > /app/.env
chown nginx:nginx /app/.env

supervisord -c /supervisord.conf
echo Done!
