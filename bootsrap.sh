#!/bin/sh

set -e

# install baseline dependecies and tools
sudo apt-get update
sudo apt-get install -y zsh git cmake htop gfortran locale curl wget
sudo apt-get install -y lsb-release build-essential libssl-dev
sudo apt-get install -y protobuf-compiler libprotobuf10 libprotoc-dev
sudo apt-get install -y libhdf5-serial-dev hdf5-tools libatlas-base-dev libxml2-dev libxslt1-dev
sudo apt-get install -y python-gi-dev python3-venv libpython3-dev python3-dev python3-setuptools cython3
# update gstreamer
sudo apt-get install -y libssl1.0.0 libgstreamer1.0-0 ngstreamer1.0-tools ngstreamer1.0-plugins-good ngstreamer1.0-plugins-bad ngstreamer1.0-plugins-ugly ngstreamer1.0-libav nlibgstrtspserver-1.0-0 nlibjansson4=2.11-1
sudo apt-get install -y --reinstall nvidia-l4t-gstreamer
# link for backwards compatibility to some old packages that expect to find xlocale.h
sudo ln -s /usr/include/locale.h /usr/include/xlocale.h

# update pip and install basic requirements
sudo pip3 install -U pip
sudo pip3 install -U -r base_requirements.txt
# install Jetson GPU optimized Tensorflow
sudo pip3 install --pre --no-cache-dir --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow==1.15.4
# install pytorch
wget https://nvidia.box.com/shared/static/veo87trfaawj5pfwuqvhl6mzc5b55fbj.whl -O torch-1.1.0a0+b457266-cp36-cp36m-linux_aarch64.whl
sudo pip3 install -y torch-1.1.0a0+b457266-cp36-cp36m-linux_aarch64.whl
sudo pip3 install -y torchvision
# install pycuda 
sudo pip3 install --global-option=build_ext --global-option="-I/usr/local/cuda/targets/aarch64-linux/include/" --global-option="-L/usr/local/cuda/targets/aarch64-linux/lib/" pycuda