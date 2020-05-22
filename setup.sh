#!/bin/bash
echo "Starting Setup"

sudo apt update
sudo apt upgrade -y

function test_cmd()
{
  if ! type "$@"; then
  return false
  else
  return true
  fi
}

# install compilers
if ! type "$clang++-9" > /dev/null; then
sudo apt install clang-9 -y
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/c++ 40
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-9 0
sudo update-alternatives --set c++ /usr/bin/clang++-9
fi


#install cmake 3.15
cmake_version=3.16
cmake_build=5

if type "$cmake" > /dev/null; then
touch /tmp/cmakev.txt
cmake --version >> /tmp/cmakev.txt
if ! grep "3.17" /tmp/cmakev.txt; then
sudo apt remove --purge --auto-remove cmake
sudo pip3 install cmake
fi
else
sudo pip3 install cmake
fi

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
rm /tmp/conanremotes.txt
# set libstdc++ to a modern ABI
conan profile update settings.compiler.libcxx=libstdc++11 default

# set env variable to avoid redoing this all
export WBUILD_RUNNER_SETUP=1>>~/.bashrc
export WBUILD_RUNNER_SETUP=1>>~/.profile
source ~/.bashrc
source ~/.profile

echo "Setup complete"