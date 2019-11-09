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

Pristine
---

To install a "pristine" v6 image from the original distribution tape,
run `make pristine`.  This will create three RK05 images in `images/`,
containing the root, source, and documentation images.  The only
difference between these images and the data taken directly from the
tape image is the creation of some necessary device nodes in `/dev`,
creation of the directory `/usr/doc`, and a modification to `/etc/rc`
to automatically mount `rk1` on `/usr/source` and `rk2` on `/usr/doc`.

To boot the pristine install after its creation, run `pdp11
configs/pristine.ini`.  At the `sim>` prompt, type `boot rk0` to load
the Unix boot loader.  It will prompt you with `@`, which is waiting
for the name of a kernel.  Type `rkunix` to boot the distribution
kernel.  From there, you can log in as root with no password.  A
sample interaction follows.

```
$ pdp11 configs/pristine.ini

PDP-11 simulator V3.8-1
Disabling XQ
sim> boot rk0
@rkunix

login: root
#
```
