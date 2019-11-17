The Unix Version 6 C Compiler
===

The Unix v6 C compiler on the Ken Wellsch tapes (which I believe is
essentially unchanged from Dennis Ritchie's tapes) is a rather older
dialect of C than I have previously used, or seen documented in detail
elsewhere.  It is documented to some degree in Richard Lions'
commentary, and appears in fragments in some Bell Labs papers and
research publications, but I'm not aware of a complete description.
Here are some things I've learned about it in porting these images
that may be helpful for future porters.

Magic Numbers
---

The C compiler doesn't seem to (exclusively?) use file extensions to
determine the type of code in a file.  In particular, if the first
character of a file is `/`, the compiler assumes that the file is
assembly language and passes it through `as`.  (This is presumably
because a bare `/` is the `as` comment character.)  This means that it
will not compile a C file starting with a comment correctly!  The
workaround for this (used extensively in the kernel source) is to make
the first line of the file a bare `#`.  The preprocessor appears to
ignore this line, but the compiler driver passes the file correctly
through the preprocessor and C compiler rather than the assembler.

You can see this in action in the backported Shoppa RL driver, which
will not compile until the leading comment is removed or a `#` is
inserted at the beginning of the file.

The Type System
---

The type system in this compiler is rather primitive even by C
standards, and it appears to know only the following types:

 * `int`
 * `char`
 * `struct`
 * various pointer types

In particular, it does not understand unsigned integers or the
unsigned keyword, and does not appear to have yet developed union
types.

Type casting is also either missing or different from later versions
of C.  Casts between different, incompatible types appears to be
effected by creating an intermediate variable which can receive an
assignment from the desired RHS and serve as the RHS for the desired
LHS.

Struct Behaviors
---

Structs, or perhaps just anonymous structs, behave unusually with
respect to non-struct types.  In particular, this idiom appears
frequently:

```c
struct {
    char d_minor;
    char d_major;
};
```

Then, later, in some code:

```c
int value;

if (value.d_minor == x)
    ;
```

The variable `value` is not of the structure type (and cannot be, as
the structure was anonymous with no instantiated variables!), yet the
compiler happily treats `value` as an instance of the unnamed
structure and extracts the equivalent location to `d_minor` from the
integer.  This is rather confusing the first time one sees it, but
occurs in many places in the code.

In particular, this can be used to dereference _compile time integer
constants_ as structures without casting.  This is used, for example,
in the RK driver to map the `RKADDR` constant (`0177400`) to the
anonymous RK registers structure.

The Preprocessor
---

The C preprocessor does not yet appear to have function-like macros
that accept arguments.  Exactly what the preprocessor does with such
macros is not entirely clear to me (I haven't yet figured out how to
successfully run it standalone; I need to consult the compiler
source), but it is clear that it does not perform argument
replacement.  This is a problem for backporting code from later
versions of the compiler that do have this feature.
