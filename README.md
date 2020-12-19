# Jenson Nano AI / ML Experiments

This repository is mainly for documenting my personal experiments on Jetson platform.

Current setup is Jetson Nano Developement Kit (4GB) version B01 with Intel Dual Band Wireless-AC 3168 card
and two IMX219 sensor cameras in neat metal case from Waveshare.

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
```

`install_jupyterlab.sh` installs and enables JupyterLab, needed dependencies and many nice and usable plugins.

```bash
./install_jupyterlab.sh
```

Now base system is ready.
At this point it is good to make backup snapshot of the sdcard on computer sdcard was initialized:

```bash
sudo /bin/dd if=/dev/sdb bs=1M | zip jetson_backup.zip -
```

## Freeing up resources

As I am using Jetson only in headless mode with Jupyter Lab I don't need native GUI.
To remove it do:

```bash
sudo systemctl stop lightdm
sudo systemctl disable lightdm
sudo systemctl set-default multi-user.target
sudo apt remove --purge ubuntu-desktop lightdm gdm3
```

Also Docker can be disabled

```bash
sudo systemctl stop containerd
sudo systemctl disable containderd
```

This frees about 250M memory to more important stuff like ML models.


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

## TensorFlow models and NVIDIA TensorRT

[TensorFlow](https://www.tensorflow.org/) maintains nice gallery of [model implementations](https://github.com/tensorflow/models) for TensorFlow.

NVIDIA provides higly optimized [TensorRT](https://developer.nvidia.com/tensorrt) runtime and SDK with the Jetson Nano SDK.

TensorFLow models can be converted directly with included [trt_convert](https://docs.nvidia.com/deeplearning/frameworks/tf-trt-user-guide/index.html)


They also provide handy [converter](https://github.com/NVIDIA-AI-IOT/torch2trt) to convert [PyTorch](https://pytorch.org/)
models to TensorRT. Installation from GitHub:

```bash
git clone https://github.com/NVIDIA-AI-IOT/torch2trt
cd torch2trt
sudo python3 setup.py install --plugins
```

Many pretrained models can be found from [PyTorchGub](https://pytorch.org/hub/)