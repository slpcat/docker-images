#!/bin/bash

source  /etc/profile.d/rvm.sh
rvm list known
rvm install 2.4.1
ruby -v
gem -v
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
gem install fpm
