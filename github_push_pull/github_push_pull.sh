#!/bin/bash
set -euo pipefail
ACTION="pull"
export PW=${PW:-n}

function login() {
    if [ "$PW" == "y" ] || [ "$PW" == "Y" ];then
        if [ -f source .env ]; then
            export $(cat .env | xargs)
            if grep -Fq GITHUB_USER .env && grep -Fq GITHUB_TOKEN .env
            then
                if [ -z "$GITHUB_USER" ] && [ -z "$GITHUB_TOKEN" ];then
                    echo "environment variables unset in .env file"
                else
                    source $(dirname "$0")/ghloginbot.exp $ACTION $GITHUB_USER $GITHUB_TOKEN
                fi
            else
                echo "environment variables missing in .env file"
            fi
        else
            echo ".env file missing"
        fi
    elif [ "$PW" == "n" ] || [ "$PW" == "N" ];then
        if [ "$ACTION" == "push" ];then
            git push
        elif [ "$ACTION" == "pull" ];then
            git pull
        fi
    fi
}

if [ $# -gt 0 ]
then
    if [ "$1" == "pull" ];then
        login
    elif [ "$1" == "push" ];then 
        ACTION="push"
        git add * && \
        git commit -m "$2" && \
        login
    fi
else
    login
fi
