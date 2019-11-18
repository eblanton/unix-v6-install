Configuring Devices
===

While a wide variety of devices are available to me in simulation,
only a small number are available to me in hardware.  I have a deeper
interest in getting those devices working than the ones in
simulation, for obvious reasons.  Unfortunately, Unix v6 has limited
support for the later-model devices present in my late-70s to
early-80s PDP 11/34As.

Selecting Block Devices
---

When configuring the v6 kernel using `mkconf`, _the first block device
selected_ will be the boot device, by default.  This can be changed by
editing the variable `rootdev` in `/usr/sys/conf/c.c` after running
`mkconf`, but it's easier to simply list the boot block device first.

The generated configuration also assumes that the block device is the
_size_ of an RK05, which is not necessarily true.  The root device
also contains (by default) the swap partition (although this can be
changed by editing the variable `swapdev` in `c.c`), and by default it
starts at block 4000; this is immediately after the first block of the
4000 block root partition on the distribution tape, but is (for
example) wildly wrong for a nearly-5 MB or nearly-6 MB RL01/RL02
partition.  Adjust the variable `swplo` to indicate the first block of
the swap partition on your swap device, and make sure there are _at
least_ `nswap` available blocks between there and the end of the
disk.

After the first block device specified, the order of additional block
devices doesn't seem to matter.

Setting up Terminals
---

Several terminal drivers are supported by the v6 kernel, but the only
supported device I have on hand is additional KL/DL-11 boards.  In
particular, the DL-11W appears to v6 to be a KL-11, and I have several
Able Computer "Quad-E" boards that emulate four adjacent DL-11Ws sans
line clock; thus, I wish to configure with five KL-11s, one at 0177560
and interrupt vector 060, and four floating vector cards beginning
at 0177500.  Fortunately, this is a supported configuration by the v6
kernel.  To accomplish it, the device `4kl` should be provided to
`mkconf`.  This will actually configure _five_ KL-11 devices, one at
0177560 and four at 0177500-0177530, with floating interrupts starting
at 0300.

After configuring `l.s` and `c.c` thus, the additional KL-11 drivers
still will not be available until you edit and recompile
`/usr/sys/dmb/kl.c` and change `NKL11` to the total number of KL-11
compatible terminal boards _including the console_.  Thus, you will
want `#define NKL11 5` if you passed `4kl` to `mkconf`.

A peculiarity of the PDP-11 architecture, continued by the v6 kernel,
is that the primary console is logically the 8th KL-11 (or compatible)
terminal board by address, but with a strange fixed interrupt vector
at 060 (instead of, for example, 0320).  Thus, the console is
logically `/dev/tty8`, not `tty0`.  However, the console is character
device major 0 minor 0.  I therefore name my four additional KL
consoles tty9 through ttyc.  The fact that `/etc/ttys` doesn't even
have a `ttyc` leads me to believe this may not be the usual choice.
However, it also seems likely that most v6 users didn't have a
third-party quad-DL-11 terminal device.

The additional KL-11 terminal devices are major number 0, but minor
numbers 1 through `NKL11 - 1`.
