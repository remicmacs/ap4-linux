# Project Kernel

## Reference articles

[How to Compile and Install Linux Kernel v4.9.11 Source On a Debian / Ubuntu Linux](https://www.cyberciti.biz/faq/debian-ubuntu-building-installing-a-custom-linux-kernel/)

## Dependencies

* `make` (`build-essential`)
* `bc` (WTF)

## Helpers

* `ccache`
* `strace`
* `fakeroot`
* `ncurses-dev` (CLI menuconfig)
* `kernel-package` Utility for building Linux kernel related Debian packages.

fakeroot build-essential  debhelper dpkg-dev ncurses-dev

## Rodolphe

Get Debian kernel build dependencies and sources :

```bash
apt install build-essential fakeroot
apt build-dep linux
apt source linux
```

Get vanilla kernel sources :

```bash
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.9.162.tar.xz
tar xvf linux-4.9.162.tar.xz
```

Go into the Debian's kernel's sources and make a `make defconfig` to generate the config. Copy the *.config* file into the sources of the new kernel.Apply the Debian configuration to the new kernel by making a `make oldconfig`. You can then build the new kernel for Debian using `make bindeb-pkg`.Installing the resulting *.deb* with `dpkg -i` will add an entry into GRUB. (edited) 