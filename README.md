# Jenson Nano AI / ML Experiments

This repository is mainly for documenting my personal experiments on Jetson platform.

Current setup is Jetson Nano Developement Kit version B01 with Intel Dual Band Wireless-AC 3168 card
and two IMX219 sensor cameras in in neat metal case from Waveshare.

None of existing start points suited my purposed as I want to run experiments in headless environment ie. from Jupyter notebooks.
JetPack version when writing these is 4.4.1.

I recommend at least 128Gb sdcard.

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

### Bootstrapping environment
Setup tasks needed for nice working environment are collected from history into `bootstrap.sh` - just running it *should* work.

```bash
./bootstrap.sh
```
These days I don't want to maintain 'dotfile' configurations among lot of enviroments. Thus I always install
[OhMyZsh](https://ohmyz.sh/) and [SpaceVim](https://spacevim.org/) on all new systems.

```bash
curl -sLf https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
curl -sLf https://spacevim.org/install.sh | bash
````

`install_jupyterlab.sh` installs and enables JupyterLab, needed dependencies and many nice and usable plugins.

```bash
./install_jupyterlab.sh
```
Now base system is ready.
At this point it is good to make backup snapshot of the sdcard on computer sdcard was initialized:
```bash
sudo /bin/dd if=/dev/sdb bs=1M | zip jetson_backup.zip -
```

## Hello World experiment

Install `libjetson-inference` library from the "Hello AI World"
This comes with handy pretained models.

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

Then start jupyterlab on terminal and browse to notebooks
```bash
jupyter-lab --no-browser
```

