#!/bin/bash
env | grep sidewinder > /app/.env
chown nginx:nginx /app/.env

php5-fpm &
nginx
