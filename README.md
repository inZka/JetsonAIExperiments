# Jenson Nano AI / ML Experiments

This repository is mainly for documenting my personal experiments on Jetson platform.

Current setup is Jetson Nano Developement Kit version B01 with Intel Dual Band Wireless-AC 3168 card
and two IMX219 sensor cameras in in neat metal case from Waveshare.

None of existing start points suited my purposed as I want to run experiments in headless environment ie. from Jupyter notebooks.
JetPack version when writing these is 4.4.1

## Initial setup

Initial setup is done as described in [NVIDIAs guide](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit).
Getting WIFI working needs following additional steps to be done from console. Everything thereafter can be done over SSH connection.
AC 3168 card does not understand power management and don't turn on if it is used.

```bash
sudo sed -i -e '/APPEND/s/$/ pcie_aspm=off/' /boot/extlinux/extlinux.conf
sudo reboot
```

After reboot connect to your WIFI network.
```bash
sudo nmcli device wifi connect <SSID> password <PASSWORD>
```

### Bootstapping environment
Setup tasks needed for nice working environment are collected from history into `bootstrap.sh` - just running it *should* work.

```bash
./bootstrap.sh
```

### Install `libjetson-inference` library
This comes from GitHub.

```bash
git clone --recursive https://github.com/dusty-nv/jetson-inference
cd jetson-inference
mkdir build
cd build
cmake ../
make -j$(nproc)
sudo make install
sudo ldconfig
```

### Set up proper JupyterLab environment
TBD: `jupyterlab.sh`