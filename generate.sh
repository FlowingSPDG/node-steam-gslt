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
  
  echo "What is AppID?"
  echo "(e.g. CSGO=730,TF2=440 )";
  echo -n "AppID : ";
  read appid;
  expr $appid + 1 >/dev/null 2>&1 ;
  if [ $? = 2 ];then
    echo "Please specify valid appid!";
    exit 1;
  fi
  
  echo "How many tokens do you need? (Default : 1)";
  echo -n "NUMBER : "
  read number;
  if [ -z "$number" ]; then
    number=1;
  fi
    
  echo "GSLT Memo prefix? (Default : GSLT_)"
  echo -n "PREFIX : "
  read $prefix;
  if [ -z "$prefix" ]; then
    prefix="GSLT_";
  fi
  
  echo "Specify where GSLTs saved (Default : token.txt)"
  echo -n "DEST : "
  read $dest;
  if [ -z "$dest" ]; then
    dest="token.txt";
  fi
}

if [ $# = 5 ];then
  token=$1;
  appid=$2;
  number=$3;
  prefix=$4;
  dest=$5;
elif [ $# = 3 ];then
  token=$1;
  appid=$2;
  number=$3;
else
  interactive;
fi


echo "Getting GSLTs...";
tokens="";
while [ $number != 0 ]; do
#  tokens+="nodejs ./app.js --webapi=$token --appid=$appid --memo=$prefix$number;
#";
  tokens+="${node} ./app.js --webapi=$token --appid=$appid --memo=$prefix$number;";
  tokens+="
";
  number=$(($number -1 ))
done

echo "$tokens" > $dest;
#head -n -1 $dest;

#いちいち>$destしているとファイルの読み書き処理がエグいので、まとめて変数に格納して後から書き込む

echo "DONE!"
exit;
