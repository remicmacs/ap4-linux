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



Copy the old kernel config file (`/boot/.config-$(uname -r)` in Debian) in the new source directory.
Configure the new kernel source compilation with `make olddefconfig` that will take all values from old config and set to default any new flag. [Gentoo wiki reference](https://wiki.gentoo.org/wiki/Kernel/Upgrade#make_olddefconfig)
