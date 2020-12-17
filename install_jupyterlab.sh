#!/bin/sh

set -e

# install nodejs directly to get newest version
wget https://nodejs.org/dist/v14.15.1/node-v14.15.1-linux-arm64.tar.xz
tar -xJf node-v14.15.1-linux-arm64.tar.xz
cd node-v14.15.1-linux-arm64
sudo cp -R * /usr/local/
sudo npm config set unicode false
cd ..
rm -rf node-v14.15.1-linux-arm64
rm -f node-v14.15.1-linux-arm64.tar.xz

# install jupyter and jupyterlab
sudo pip3 install -U jupyter jupyterlab
jupyter lab --generate-config

# install traitlets @master
sudo pip3 install git+https://github.com/ipython/traitlets@master

# install lab extensions
sudo pip3 install jupyter-tensorboard
sudo pip3 install nbresuse==0.3.6
sudo jupyter nbextension install --py widgetsnbextension --sys-prefix
sudo jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build
sudo jupyter labextension install @jupyterlab/statusbar --no-build
sudo jupyter labextension install @jupyter-widgets/jupyterlab-sidecar --no-build
sudo jupyter labextension install jupyterlab_tensorboard --no-build
sudo jupyter labextension install @lckr/jupyterlab_variableinspector --no-build
sudo jupyter labextension install jupyterlab-topbar-extension jupyterlab-system-monitor --no-build
sudo jupyter labextension install jupyterlab-theme-solarized-dark --no-build
sudo jupyter labextension install @axlair/jupyterlab_vim --no-build

# this one does not support Jetson 
## sudo jupyter labextension install jupyterlab-nvdashboard

# it is nice to have autocompletion etc in Jupyter notebooks
sudo pip3 install 'python-language-server[all]' jupyter-lsp
sudo jupyter labextension install @krassowski/jupyterlab-lsp --no-build
sudo jupyter build

# install plotly plotting library for jupyter lab use
sudo pip3 install plotly
sudo jupyter labextension install jupyterlab-plotly plotlywidget