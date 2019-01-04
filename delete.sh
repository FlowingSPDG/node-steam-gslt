#!/bin/bash

node=""

type nodejs >> /dev/null
if [ $? = 0 ]; then
  echo "NodeJS Found! Resuming..."
  node="nodejs"
fi

type node >> /dev/null
if [ $? = 0 ]; then
  echo "Node Found! Resuming..."
  node="node"
fi

if [ $node = 0 ]; then
  echo "NodeJS or Node not found!! Install node first"
  exit 1;
fi

function interactive() {
  echo "What is your Steam Web API Token?"
  echo "(Can be found here : https://steamcommunity.com/dev/apikey )";
  echo -n "TOKEN : ";
  read token;
  if [ -z "$token" ]; then
    echo "Please specify valid token!"
    exit 1;
  fi
  
  echo "Specify GSLT to delete?"
  echo -n "GSLT : ";
  read GSLT;
  expr $GSLT + 1 >/dev/null 2>&1 ;
  
}

if [ $# != 2 ];then
  interactive;
fi

${node} ./app.js --action=delete --webapi=$token --token=$GSLT;