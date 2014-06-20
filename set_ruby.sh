#!/bin/bash
export PATH="/usr/local/bin:$PATH"

yum clean all
yum -y update

#Security Update
yum -y install yum-plugin-security
yum --security update

#Ruby
yum -y install gcc 
yum -y install make
yum -y install zlib
yum -y install zlib-deve
yum -y install readline
yum -y install readline-devel
yum -y install openssl
yum -y install openssl-devel
yum -y install curl
yum -y install curl-devel

#for therubyracer
yum -y install gcc-c++

#for ImageMagick
yum -y install ImageMagick
yum -y install ImageMagick-devel


#for rubygems mysql2
yum -y install mysql-devel l

#for capistrano zip
yum -y install bzip2*
yum -y install zlib-devel

# for nokogiri
yum -y install libxml2
yum -y install libxml2-devel
yum -y install libxslt
yum -y install libxslt-devel


# for Capybara-webkit
yum -y install qt48-qt-webkit-devel
ln -s /opt/rh/qt48/root/usr/include/QtCore/qconfig-64.h  /opt/rh/qt48/root/usr/include/QtCore/qconfig-x86_64.h
ln -s /opt/rh/qt48/enable /etc/profile.d/enable
source /etc/profile.d/enable

echo 'export PATH=/opt/rh/qt48/root/usr/lib64/qt4/bin/${PATH:+:${PATH}}' >> /etc/profile.d/qt.sh 

source /etc/profile.d/qt.sh

if [ ! -d /usr/local/rbenv ];then
    cd /usr/local
    git clone git://github.com/sstephenson/rbenv.git rbenv
    mkdir rbenv/shims rbenv/versions rbenv/plugins
    git clone git://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build

    # Setup rbenv for all user
    echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile.d/rbenv.sh
    echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh
    echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh
    
    source /etc/profile.d/rbenv.sh;

    # Install ruby
    rbenv install 2.1.1
    rbenv rehash
    rbenv global 2.1.1  # default ruby version

    #rbenv(add user to rbenv group if you want to use rbenv)
    useradd rbenv
    chown -R rbenv:rbenv rbenv
    chmod -R 775 rbenv

    # install withou ri,rdoc
    echo 'install: --no-ri --no-rdoc' >> /etc/.gemrc
    echo 'update: --no-ri --no-rdoc' >> /etc/.gemrc
    echo 'install: --no-ri --no-rdoc' >> /.gemrc
    echo 'update: --no-ri --no-rdoc' >> /.gemrc

    # install bundler
    gem install bundler
    gem install rehash
fi
