Notes on RL11 Disks in v6
===

There are several RL11 drivers floating around the 'net for Unix v6.
They fall roughly into three categories: found artifacts of unknown
origin from vintage images (_e.g._, the Shoppa disk), drivers created
from whole cloth for RL disks in emulators, and drivers backported
from v7 Unix.  I've played with all three, and here are some notes.

The Shoppa Driver
---

Tim Shoppa's 11/23 disk images contain an RL driver that works
perfectly (as far as I can tell) on his image, but require a newer
version of the C compiler than is supported in the Wellsch v6
distribution.  The compiler on the Shoppa disk does not have any
associated sources, so I am not considering it a viable compiler for
my own use.  See [my notes on the C compiler](c.md) for some
information on the C compiler present in the distribution image and
some of its limitations.

My port of the Shoppa RL driver to the v6 distribution tape C compiler
appears to have some bugs.  I will freely admit that my porting effort
was a "make it compile" and then "get _something_ working" technique,
and not a careful port with examination of the implications of all of
the changes; in part because it's more fun to do the examination _in
situ_ once the system is running!  This appears to have left the
ported driver with some unfortunate limitations, including that it
does not work properly with RL02 disks (although it seems to work
more-or-less reliably with RL01 disks).  I suspect this is due to
choosing inappropriate types for `unsigned` replacements (depending on
context, either `int` or `char *` may be appropriate) and/or problems
in intermediate casts.  It is also possible that there are C
preprocessor problems that have not yet been identified; the Shoppa
driver used two function-like macros that had to be manually expanded,
there may be other incompatibilities.
