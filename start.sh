#!/bin/bash
env | grep -i sidewinder > /app/.env

hhvm --mode daemon -vServer.Type=fastcgi -vServer.Port=9000
nginx
