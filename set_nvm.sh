#!/bin/bash
export PATH="/usr/local/bin:$PATH"

#Install Node.js for Rails javascript runtime

if [ ! -d /usr/local/nvm ];then
    # install nvm
    git clone https://github.com/creationix/nvm.git /usr/local/nvm
    sh /usr/local/nvm/nvm.sh 

    # nvm(add user to nvm group if you want to use nvm)
    useradd nvm
    chown -R nvm:nvm /usr/local/nvm
    chmod -R 755 /usr/local/nvm
    nvm install 0.10.24

    # Setup rbenv for all user
    echo 'source /usr/local/nvm/nvm.sh' >> /etc/profile.d/nvm.sh
    echo 'nvm use v0.10.24' >> /etc/profile.d/nvm.sh
fi


