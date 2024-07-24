===================================================
kw-signature - Write commit and patch trailer lines
===================================================

.. _signature-doc:

SYNOPSIS
========
| *kw* *signature* (-s(<string>) | \--add-signed-off-by=(<string>)) [\--verbose] [<sha> | <patch>]
| *kw* *signature* (-r(<string>) | \--add-reviewed-by=(<string>)) [\--verbose] [<sha> | <patch>]
| *kw* *signature* (-a(<string>) | \--add-acked-by=(<string>)) [\--verbose] [<sha> | <patch>]
| *kw* *signature* (-t(<string>) | \--add-tested-by=(<string>)) [\--verbose] [<sha> | <patch>]
| *kw* *signature* (-C(<string>) | \--add-co-developed-by=(<string>)) [\--verbose] [<sha> | <patch>]
| *kw* *signature* (-R(<string>) | \--add-reported-by=(<string>)) [\--verbose] [<sha> | <patch>]
| *kw* *signature* (-f(<sha>) | \--add-fixes=(<sha>)) [\--verbose] [<sha> | <patch>]

DESCRIPTION
===========
This is a wrapper to some useful usage of the 'git commit --amend',
'git rebase' and the 'git interpret-trailers' commands. This kw command
is able to perform usual operations over trailer lines of commits and patches.
By default, it uses the commit currently pointed by `HEAD` as the target
of the operation if user does not specify one. At least one operation option
must be given.

Using multiple options combined is possible. For instance, the following
command will add **Reviewed-by** and **Signed-off-by**, in this order,
to the commit's trailers pointed by `HEAD` using `user.name` and
`user.email` from git config::

  $ kw signature -r -s

The order the trailer lines are written follows the general sequence:

.. code-block:: text

   Reported-by
   Co-developed-by
   Acked-by
   Tested-by
   Reviewed-by
   Signed-off-by
   Fixes

Such that trailer lines are grouped by their signatures. That means using either
``kw signature -r -s`` or ``kw signature -s -r`` will generate the same result:

.. code-block:: text

   Reviewed-by: Some Name <somemail@mail.xyz>
   Signed-off-by: Some Name <somemail@mail.xyz>

More examples can be found in **EXAMPLES** section.

Another important aspect of this command is that, since it uses ``git rebase``
as its backend, if we run it using a SHA like ``kw signature -s HEAD~3`` then
only commits refered by ``HEAD~2``, ``HEAD~1`` and ``HEAD`` will be affected.
This is similar to what happens if you execute ``git rebase --interactive HEAD~3``.

OPTIONS
=======
-s, \--add-signed-off-by:
  Adds a **Signed-off-by** trailer line to either commits or patchsets.
  By default it uses `user.name` and `user.email` from git config to
  write these lines if no argument is given to this option.
  
-r, \--add-reviewed-by:
  Adds a **Reviewed-by** trailer line to either commits or patchsets.
  By default it uses `user.name` and `user.email` from git config to
  write these lines if no argument is given to this option.

-a, \--add-acked-by:
  Adds a **Acked-by** trailer line to either commits or patchsets.
  By default it uses `user.name` and `user.email` from git config to
  write these lines if no argument is given to this option.

-t, \--add-tested-by:
  Adds a **Tested-by** trailer line to either commits or patchsets.
  By default it uses `user.name` and `user.email` from git config to
  write these lines if no argument is given to this option.

-C, \--add-co-developed-by:
  Adds a **Co-developed-by** immediately followed by a **Signed-off-by**
  trailer line to either commits or patchsets. By default it uses
  `user.name` and `user.email` from git config to write these lines if
  no argument is given to this option.

-R, \--add-reported-by:
  Add a **Reported-by** trailer line to either commits or patchsets.
  By default it uses `user.name` and `user.email` from git config to
  write these lines if no argument is given to this option.

-f, \--add-fixes:
  Adds a **Fixes** trailer line to either commits or patchsets.
  It requires an argument, which must be a valid commit reference, to
  define the fixed commit's hash that follows this tag.

\--verbose:
  Displays commands executed under the hood.

EXAMPLES
========
Adding a **Reviewed-by** line to commit pointed by ``HEAD``::

  $ kw signature --add-reviewed-by='Reviewer Name <reviewer@mail.org>'

Adding an **Acked-by** line starting from ``HEAD~2`` until ``HEAD``::

  $ kw signature --acked-by='Some Name <example@mail.com>' HEAD~3

Adding **Fixes** line to commit pointed by ``HEAD``, which fixes another
previous commit ``90a7ba23340d``::

  $ kw signature --add-fixes='90a7ba23340d'

All the above options can be used to perform operations over `.patch` files as well::

  $ kw signature -r'Reviewer Name <reviewer@mail.org>' example.patch

  $ kw signature -a'Some Name <example@mail.org>' example.patch

  $ kw signature -f'90a7ba23340d' example.patch

This command accepts multiples arguments, which means that multiple files
(both names and globs) and commits can be passed with one single command.

Adding **Signed-off-by** line to multiple `.patch` files::

  $ kw signature -s'Some Name <example@mail.org>' file1.patch file2.patch

This command also accepts globs to reference multiple `.patch` files::

  $ kw signature -s'Some Name <example@mail.org>' *.patch

One more complex example than the one seen in **DESCRIPTION** is::

  $ kw signature -s'Jane Doe <janedoe@mail.xyz>' \
    -t'Jane Doe <janedoe@mail.xyz>' \
    -R'Michael Doe <michaeldoe@mail.xyz>' \
    -C'John Doe <johndoe@mail.xyz>' \
    -C'Michael Doe <michaeldoe@mail.xyz>' \
    -r'Jane Doe <janedoe@mail.xyz>'

That will write these trailers like so:

.. code-block:: text

  Reported-by: Michael Doe <michaeldoe@mail.xyz>
  Co-developed-by: Michael Doe <michaeldoe@mail.xyz>
  Signed-off-by: Michael Doe <michaeldoe@mail.xyz>
  Co-developed-by: John Doe <johndoe@mail.xyz>
  Signed-off-by: John Doe <johndoe@mail.xyz>
  Tested-by: Jane Doe <janedoe@mail.xyz>
  Reviewed-by: Jane Doe <janedoe@mail.xyz>
  Signed-off-by: Jane Doe <janedoe@mail.xyz>
