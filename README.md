# Wizzie Wizzie's own Debian derivative

An installer and live system for [Wizzie Wizzie Computer Coding Club](http://www.wizziewizzie.org/). It contains all the software identified as useful for our workshops.

## Contents

This repository contains a number of scripts to be used with Debian Live. When run, they will generate an OS image that can be loaded on a USB stick. The USB stick can then be used as both:

  * A live system: run the environment completely off the USB drive without installing to disk, or altering the host computer in any way

  * An installer: copy the system to a computer for use without the USB drive

## How to run a build

The [Debian Live manual](https://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html) has a pretty good "For the impatient" section. That's a good place to start learning what all this is about. Or you can just read this section for now.

### Setting up a virtual machine

You'll need a Debian system. A virtual machine is recommended because you'll have to run everything as root: `sudo` is not enough.

You can use [VirtualBox](https://www.virtualbox.org/) or any similar software. This is the process with VirtualBox:

  1. Download a Debian ISO (amd64) from [https://www.debian.org/distrib/netinst]. The "Small CD" one should make it.

  2. Install VirtualBox, downloading the appropriate version for your host OS: https://www.virtualbox.org/wiki/Downloads

  3. Create VM to run Linux Debian 64 bit. I recommend a 20GB hard drive. I'm also assigning it 1024 MB memory, but can't be sure what's better there

  4. Install and boot

  5. You'll need the Guest Additions package. On the menu bar, go to "Devices > Install Guest Additions CD image", and install as follows:

```
# cd /media/cdrom
# sh VBoxLinuxAdditions.run
```

Finally restart the VM and you'll be set.

### Installing required packages

As mentioned above, do everything as root. Using `sudo` is not enough.

First install live-build and git:

```
# apt-get install live-build git make
```

Next, clone this repository:

```
# git clone https://github.com/pablobm/w2c3-livecd.git
```

And finally, run a build:

```
# cd w2c3-livecd
# make
```

This will take a while! The first time it will download packages over the Internet and will take longer. Fortunately, these will be cached (under `cache/`) making this step faster in subsequent builds.

## Implementation details

There are some "special" customisations on these scripts, but mostly it's all pretty standard.

### The standard bits

Check out the [Debian Live manual](https://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html) to get familiar with the basics of creating a package. Some quick notes:

  * See `config/package-lists` for lists of packages that are included in the build

  * On `config/includes.chroot/etc` you can find some post-install configuration. Examples include desktop shortcuts (see `config/includes.chroot/etc/skel/Desktop/`) or a setting to automatically log the user in without asking for a password (see `config/includes.chroot/etc/lightdm/lightdm.conf`)

  * The file `config/includes.binary/install/preseed.cfg` lists pre-selected answers to some questions asked during the installation process. These questions will be skipped during install of the resulting distribution. This file is referred to from the config auto script (`auto/config`) with the option `--debian-installer-preseedfile preseed.cfg`

  * Again on `auto/config`, we enable the "contrib" and "non-free" archive areas. This is because some of our laptops require proprietary drivers not available in the main distribution.

### Proprietary drivers during installation

A strange problem with proprietary drivers is that they don't seem to apply during installation. They are OK after install, or when running the live system.

This means it's not possible to download updated packages from the Internet if you are installing on a laptop that requires proprietary network drivers, for example.

Initially I thought this would be a problem, and set out to fix it. I put together a writeup here: [http://blog.pablobm.com/post/125538410950/proprietary-drivers-on-a-custom-debian-installer]

However, it's not a problem anymore, because at present we include all the packages we need. We want to avoid using the Internet during installation, because we normally run our coding club on places where WiFi is spotty at best.

At some point I'll remove the changes I made to make this work.

## TODO

Add KidsRuby package.
