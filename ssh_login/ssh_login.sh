#!/bin/bash
set -euo pipefail

if [ -f .env ]; then
    export $(cat .env | xargs)
    if grep -Fq SERVER_USER .env && grep -Fq SERVER_IP .env && grep -Fq SERVER_PASSPHRASE .env
    then
        if [ -z "$SERVER_USER" ] && [ -z "$SERVER_IP" ] && [ -z "$SERVER_PASSPHRASE" ];then
            echo "environment variables unset in .env file"
        else
            ./sshserverbot.exp $SERVER_USER $SERVER_IP $SERVER_PASSPHRASE
        fi
    else
        echo "environment variables missing in .env file"
    fi
else
    echo ".env file missing"
fi