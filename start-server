#!/bin/bash
env | grep -i sidewinder >> /app/.env

nginx
hhvm --mode daemon -vServer.Type=fastcgi -vServer.Port=9000
