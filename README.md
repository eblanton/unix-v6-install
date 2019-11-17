Unix v6 Install Scripts
===

This directory contains tools that install Unix v6 from images of the
original distribution tapes.  All operations are normally controlled by
the top-level Makefile.

Requirements
---

In order to build this repository, you will need:

 * Bob Supnik's excellent SIMH simulator for the PDP-11 (and many
   other interesting architectures).  Your distribution probably has
   appropriate binaries, but you can find it at
   http://simh.trailing-edge.com/ as well.
 * curl
 * expect

Pristine-RK
---

To install a "pristine" v6 image from the original distribution tape
onto virtual RK05 disks, run `make pristine-rk`.  This will create three
RK05 images in `images/`, containing the root, source, and documentation
images.  The only difference between these images and the data taken
directly from the tape image is the creation of some necessary device
nodes in `/dev`, creation of the directory `/usr/doc`, and a
modification to `/etc/rc` to automatically mount `rk1` on `/usr/source`
and `rk2` on `/usr/doc`.

To boot the pristine install after its creation, run `pdp11
configs/pristine-rk.ini`.  At the `sim>` prompt, type `boot rk0` to load
the Unix boot loader.  It will prompt you with `@`, which is waiting for
the name of a kernel.  Type `rkunix` to boot the distribution kernel.
From there, you can log in as root with no password.  A sample
interaction follows.

```
$ pdp11 configs/pristine-rk.ini

PDP-11 simulator V3.8-1
Disabling XQ
sim> boot rk0
@rkunix

login: root
#
```

RL/RK
---

To create an RK05 image from the pristine distribution install that is
capable of booting on an 11/40-family machine and can mount an RL disk,
run `make rlrk`.  This will create a new RK05 image in `images/` called
`rlrk_root.rk05` that has a kernel `rlrkunix` with RL01 support (RL02
is currently broken).  To boot this kernel after its creation, run
`pdp11`, then `set cpu 11/34 256k` (or 11/40, if you prefer),
`attach rk0 images/rlrk_root.rk05` and then attach an RL01 image of
your choice on rl0.  After booting, you can use `/etc/mount /dev/rl0
/mnt` to mount the image on `/mnt`.

This image is otherwise the same as the pristine images.  The only
difference is the new kernel (and related artifacts) and RL device nodes
for `rl0` in `/dev`.

The RL driver in this image is taken from the "Tim Shoppa" 11/23 RL02
images from the TUHS archive.  Because it will not compile on the base
v6 distribution, the file `scripts/rl.ed` modifies the driver for the
older C syntax.  The file `scripts/mkconf.ed` augments the `mkconf`
kernel configuration program to understand RL configuration options.

Pristine-RL
---

To create an RL01 image from a pristine distribution install that is
capable for booting on an 11/40-family machine with an RL01 drive on
RL0 as its boot and root volume, run `make pristine-rl`.  This will
create a new RL01 image in `images/` called `pristine_root.rl01` that
has a kernel `rlunix` with RL01 support.

Like the Pristine-RK and RL/RK images, this image is as close to a
pristine image as possible.  It contains the sources for the RL
driver, the newly compiled RL-capable kernel, the appropriate device
nodes in `/dev`, and very little else.

This uses the same RL driver as RL/RK.
