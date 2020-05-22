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
sudo ln -fs ~/.local/bin/conan /usr/bin/conan
# add remotes if they aren't already added
touch /tmp/conanremotes.txt
conan remote list >> /tmp/conanremotes.txt
# add bincrafters to conan remotes
if ! grep "conan-bincrafters" /tmp/conanremotes.txt > /dev/null
then
echo "Conan bincrafters not found. Adding..."
conan remote add conan-bincrafters https://api.bintray.com/conan/bincrafters/public-conan
fi
# add darcamo to conan remotes
if ! grep "darcamo-bintray" /tmp/conanremotes.txt > /dev/null
then
echo "Darcamo bintray not found. Adding..."
conan remote add darcamo-bintray https://api.bintray.com/conan/darcamo/cppsim
fi
eval $(echo -e rm /tmp/conanremotes.txt)
# set libstdc++ to a modern ABI
eval $(echo -e conan profile update settings.compiler.libcxx=libstdc++11 default)

# set env variable to avoid redoing this all
export WBUILD_RUNNER_SETUP=1>>~/.bashrc
export WBUILD_RUNNER_SETUP=1>>~/.profile
source ~/.bashrc
source ~/.profile

echo "Setup complete"