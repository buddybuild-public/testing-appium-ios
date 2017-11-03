#!/usr/bin/env bash

chruby 2.4.1

# # install brew, ant, maven
# if ! which brew >/dev/null; then
# 	echo "Installing brew..."
# 	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# fi

# if ! which ant >/dev/null; then
# 	echo "Installing ant..."
# 	brew install ant
# fi

# if ! which maven >/dev/null; then
# 	echo "Installing brew..."
# 	brew install maven
# fi

# install appium
echo 'Installing appium...'
npm install -g appium

# authorize for testing
echo 'Installing authorize-ios...'
npm install -g authorize-ios
sudo authorize-ios

# install rubygems
echo 'Installing rubygems...'
bundle install 

# start appium in background
echo 'Running appium in background task...'
nohup appium &
echo $! > $BUDDYBUILD_WORKSPACE/appium_pid.txt

export APP_PATH=$BUDDYBUILD_PRODUCT_DIR

echo 'Running appium tests...'
cd $BUDDYBUILD_WORKSPACE
bundle exec ruby simple_test.rb

# terminate 
jobs -l
kill -9 `cat $BUDDYBUILD_WORKSPACE/appium_pid.txt`
rm $BUDDYBUILD_WORKSPACE/appium_pid.txt

exit 0