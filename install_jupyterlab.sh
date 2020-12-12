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
sudo jupyter nbextension install --py widgetsnbextension --sys-prefix
sudo jupyter labextension install @jupyter-widgets/jupyterlab-manager
sudo jupyter labextension install @jupyterlab/statusbar
sudo jupyter labextension enable @jupyterlab/statusbar
sudo jupyter labextension install @jupyter-widgets/jupyterlab-sidecar
sudo jupyter labextension install jupyterlab_tensorboard
sudo pip3 install jupyter-tensorboard
sudo jupyter labextension install @lckr/jupyterlab_variableinspector
sudo jupyter labextension enable jupyterlab_variableinspector
sudo jupyter labextension install jupyterlab-topbar-extension jupyterlab-system-monitor
sudo jupyter labextension enable jupyter-topbar-extension
sudo jupyter labextension enable jupyter-system-monitor
sudo jupyter labextension install jupyterlab-theme-solarized-dark

## sudo jupyter labextension install jupyterlab-nvdashboard

# it is nice to have autocompletion etc in Jupyter notebooks
sudo pip3 install 'python-language-server[all]' jupyter-lsp
sudo jupyter labextension install @krassowski/jupyterlab-lsp