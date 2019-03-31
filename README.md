# Wizzie Wizzie's own Debian derivative

An installer and live system for [Wizzie Wizzie Computer Coding Club](http://www.wizziewizzie.org/). It contains all the software identified as useful for our workshops.

## Contents

This repository contains a number of scripts to be used with Debian Live. When run, they will generate an OS image that can be loaded on a USB stick. The USB stick can then be used as both:

  * A live system: run the environment completely off the USB drive without installing to disk, or altering the host computer in any way

  * An installer: copy the system to a computer for use without the USB drive

## How to run a build

The final product of a build is a disk image that you can transfer to a USB drive. There are two different ways of running a build:

* With Docker: this is the simplest way and is preferred.
* Natively on Debian: takes longer to set up, but it's the only option if you are on a system that doesn't support Docker.

Independently of the chosen method, running a build will take a while. The first time it will download packages over the Internet and will take longer. Fortunately, many of these will be cached making this step faster in subsequent builds.

### Common setup steps

Start by cloning this repository if you haven't yet:

```
$ git clone https://github.com/pablobm/w2c3-livecd.git
```

We also need to manually provide the Flash plugin:

1. Go to Adobe Flash's website (https://get.adobe.com/flashplayer).
2. Download the Linux 64bit version.
3. Put this file in the folder `config/includes.chroot/tmp` in this project.

Next, follow the instructions on the section appropriate for your preferred build method.

## The Docker option

For this you need:

* A machine and operating system able to run Docker. Any modern computer should be able to run this, on Windows, Linux, or macOS. I'm not an expert though.
* Docker installed: https://www.docker.com/get-started.
* GNU Make. How to install this depends on your system. For example, on Debian it would be `sudo apt-get install make`. On macOS with Homebrew, you can do `brew install make`.

If everything is in place, you can now run a build:

```
$ make docker-build
```

The end results will appear in the `output/` folder.

## The native option

If your machine doesn't support Docker, or you otherwise prefer not to use it, follow this guide. You'll need a Debian Stretch (version 9) system.

Even though this section is called "the native option", a virtual machine is still recommended.

Note that you'll have to run everything as root: `sudo` doesn't appear to be enough.

### Setting up a virtual machine

If you choose to use a virtual machine, the setup might be different depending on the software you use. This is the process with VirtualBox:

  1. Download a Debian ISO. Version should be Stretch (v9) and architecture amd64: https://www.debian.org/distrib/netinst. The "Small CD" one should do it.

  2. Install VirtualBox, downloading the appropriate version for your host OS: https://www.virtualbox.org/wiki/Downloads.

  3. Create VM to run Linux Debian 64 bit. I recommend a 25GB hard drive. I'm also assigning it 1024 MB memory, but can't be sure what's better there.

  4. Install and boot.

  5. You'll need the Guest Additions package, which in turns requires some development packages. On the menu bar, go to "Devices > Install Guest Additions CD image", and install as follows (as root):

```
# apt-get install make gcc linux-headers-amd64
# cd /media/cdrom
# sh VBoxLinuxAdditions.run
```

Finally restart the VM and you'll be set.

### Installing required packages

As mentioned above, do everything as root. Using `sudo` is not enough.

First install the required packages:

```
# apt-get install live-build imagemagick
```

Finally, run a build:

```
# make
```

The end results will appear in the `output/` folder.

## Implementation details

There are some "special" customisations on these scripts, but mostly it's all pretty standard.

### The standard bits

Check out the [Debian Live manual](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html) to get familiar with the basics of creating a build. There's a pretty good "For the impatient" section to get started.

Some quick notes:

  * See `config/package-lists` for lists of packages that are included in the build

  * On `config/includes.chroot/etc` you can find some post-install configuration. Examples include desktop shortcuts (see `config/includes.chroot/etc/skel/Desktop/`) or a setting to automatically log the user in without asking for a password (see `config/includes.chroot/etc/lightdm/lightdm.conf`)

  * The file `config/includes.binary/install/preseed.cfg` lists pre-selected answers to some questions asked during the installation process. These questions will be skipped during install of the resulting distribution. This file is referred to from the config auto script (`auto/config`) with the option `--debian-installer-preseedfile preseed.cfg`

  * Again on `auto/config`, we enable the "contrib" and "non-free" archive areas. This is because some of our laptops require proprietary drivers not available in the main distribution.

### Proprietary drivers during installation

A strange problem with proprietary drivers is that they don't seem to apply during installation. They are OK after install, or when running the live system.

This means that, for example, it's not possible to download updated packages from the Internet if you are installing on a laptop that requires proprietary network drivers.

Initially I thought this would be a problem, and set out to fix it. I put together a writeup here: http://blog.pablobm.com/post/125538410950/proprietary-drivers-on-a-custom-debian-installer

However, this is not a problem anymore as at present we include all the packages we need. We want to avoid using the Internet during installation, because we normally run our coding club on places where WiFi is spotty at best.

At some point I'll remove the changes I made to make this work.

### Root access

For root access, use `sudo`. The password is just `password`. On older installs, use `su` with the same password. Feel free to tinker. The worst that can happen is that the machine has to be reinstalled again, so no problem.
