#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd $cmd_dir

echo_msg "generate express"
echo

is_fn express
if [ $? -ne 0 ]; then
    echo_inf "express-generator not installed"
    echo_inf "we install it now..."
    npm install express-generator -g
fi

name=express-project

if [ $# -ne 1 ]; then
    echo_info "Enter you project name:"
    read name
    if [ "$name" = "" ]; then
        name=express-project
    fi
else
    name=$1
fi

express $name
cd $name
npm install

npm install --save-dev nodemon

npm install --save async
npm install --save body-parser
npm install --save compression
npm install --save cookie-parser
npm install --save mongoose
npm install --save gorgan
npm install --save morgan
npm install --save serve-favicon
npm install --save express-validator
npm install --save vue

echo_msg "
package.json
scripts:{
    start: node ./bin/www
    devstart: nodemon ./bin/www
}

DEBUG=${name}:* npm run devstart
"

npm install --save-dev eslint

exit 0