Unix v6 Install Scripts
===

This directory contains tools that install Unix v6 from images of the
original distribution tapes.  All operations are normally controlled by
the top-level Makefile.

Pristine
---

To install a "pristine" v6 image from the original distribution tape,
run `make pristine`.  This will create three RK05 images in `images/`,
containing the root, source, and documentation images.
