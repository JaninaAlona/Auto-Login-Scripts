#!/bin/bash
set -euo pipefail
if [ -f .env ]; then
    export $(cat .env | xargs)
    if grep -Fq GITHUB_USER .env && grep -Fq GITHUB_TOKEN .env
    then
        if [ -z "$GITHUB_USER" ] && [ -z "$GITHUB_TOKEN" ];then
            echo "environment variables unset in .env file"
        else
            ./pullserverbot.exp $GITHUB_USER $GITHUB_TOKEN
        fi
    else
        echo "environment variables missing in .env file"
    fi
else
    echo ".env file missing"
fi