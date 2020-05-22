#!/bin/bash
echo "Starting Setup"

# install python 3
sudo apt install -y python3
# install python 3 setuptools
sudo apt install -y python3-setuptools
# install python 3 wheel
sudo pip3 install wheel
# install conan
sudo pip3 install conan
# refresh
source ~/.profile
# symlink for bash
sudo ln -s ~/.local/bin/conan /usr/bin/conan
# add bincrafters to conan remotes
conan remote add conan-bincrafters https://api.bintray.com/conan/bincrafters/public-conan
# add darcamo to conan remotes
conan remote add darcamo-bintray https://api.bintray.com/conan/darcamo/cppsim

# set env variable to avoid redoing this all
export WBUILD_RUNNER_SETUP=1>>~/.bashrc
export WBUILD_RUNNER_SETUP=1>>~/.profile
source ~/.bashrc
source ~/.profile

echo "Setup complete"