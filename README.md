# ROFI-MAN

rofi-man - rofi-script to search for executables by their name or functionality

**rofi-man** is best used with [rofi](https://github.com/davatorium/rofi) as a [rofi-script](https://github.com/davatorium/rofi/blob/next/doc/rofi-script.5.markdown).

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [ROFI-MAN](#rofi-man)
    - [The Problem](#the-problem)
    - [An Alternative](#an-alternative)
    - [What about other solutions ?](#what-about-other-solutions-)

<!-- markdown-toc end -->


## The Problem

A 3 am random search while attempting to looking for a certain utility, I accidentally stumbled upon this [video](https://www.youtube.com/watch?v=tc4ROCJYbm0), especially with the section by the chad [Brian Kernighan](https://en.wikipedia.org/wiki/Brian_Kernighan).

A lot of what is said in that video stuck to me, but the one that lead me to this project was the basic idea that unix was meant to *offer a toolset* that would let you combine
**very small** and **simple programs** to do something far more complicated; a very basic tenant of what drives programming design today.
Now to do this **successfully**, you would *need to know all the utilities and the functionalities they served*. [Man pages](https://en.wikipedia.org/wiki/Man_page) served this requirement
to certain extent, where they would tell you in great detail as to *what a certain program did* (of course they are used not only for executables, but for things like functions, constants
etc as well; the focus in this case is ready to use execs) i.e the user is already aware of the programs, and what they generally do. A lot of the time, what someone usually
has is *what needs to be done*, but is unaware of *which programs to use*.

What usually ends up happening in my experience is we end up googling for the solution online. This gets the job done, but does have a few side-effects:

1. You may end up installing a new set of programs for this particular use case:

    * These programs may be unused after this particular scenarios
    * These programs were merely duplicates of utilities that already existed within the user's system in some form or the other

2. If the solution is made up of several utilities, the user may end up missing the individual utilities. This would lead them to search for another
   bespoke solution next time, even if they already have the utilities to perform the task a large percentage of the way through.

## An Alternative

The simple idea behind this is that it natural to search for executables by either their names (if they're named appropriately) OR from their advertised functionality in their short descriptions.
Short descriptions are complete and are meant to communicate *exactly* what they are meant to be used for at the end of the day. What rofi offers is simply an interface to satisfy this objective.
You could have similar results with something like this:

``` shell
whatis -s 1,7 -r . | grep -E $1
```

What rofi offers up on top of something like this - is the incremental search. Sometimes I've found myself using different words, or not even the correct words or not being specific. Listing my
options may often change what I'm searching for or even select something different. This of course holds only if you don't have a search engine like google backing your index - otherwise my
argument falls flat and you have almost exactly what you want most of the time.

* **Side-effects**

  * *Not every utility has a corresponding manpage OR even a short description*
  * These lists could end up very large depending on what the user has installed within their system, so *performance definitely is a concern in some larger systems*.
    This of course depends entirely on the efficiency of rofi and the number of execs installed on the user's system

## What about other solutions ?

Very clearly this is not a new problem as the solution for it has existed for a while:

``` shell
# search by name or short description
man -k $1
# analogous
apropos $1

# search by name and yield a short description
whatis $1
```

* **Why did I use whatis instead of apropos ?**

  You could use `apropos` as well to list the executables. At the time of writing this script `whatis` seemed to a tad quicker.

``` shell
$ time whatis -s 1,7 -r . > /dev/null
  real	0m0.075s
  user	0m0.068s
  sys	0m0.007s
$ time apropos -s 1,7 -r . > /dev/null
  real	0m0.105s
  user	0m0.094s
  sys	0m0.011s
```

* **What about searching by any text in the entire man page ?**

  One of the side-effects of using this though is that descriptions tend to be very large most of the time, and they carry a certain
  train of thought, or they may even mention other utilities that could be compared to or used alongside that particular utility. This could lead to somewhat misleading search results, or sometimes even
  confuse the user.

* **What about using whatis**

  This only searches by name.

* **What about using something like a package manager ?**

  A package may contain multiple executables and the package as a whole may serve a *set of purposes* instead of serving a singular purpose that you're searching for. Consider `lxc-create` and it's package `lxc`.


At the end of the day this is a simple script and as a user of rofi I simply put it together. Feel free to change the script to your liking or use something else entirely.


## INSTALL

* requires `rofi`, `whatis`, `man` at runtime
* requires `pod2man` at build time to build the manpage from [PerlPod](https://perldoc.perl.org/perlpod)

Copy the bin `rofi-man` to a dir in your `$PATH`. For the corresponding manpage, copy into the corresponding mand directory and run `mandb` after.

``` shell
# copy to man directory
sudo cp docs/rofi-man.7.gz /usr/share/man/man7/
# update the man-db
sudo mandb
```

To build the docs

``` shell
# using perdocs to write the docs
pod2man --section 7 --center="ROFI-MAN" --release=$RELEASE docs/rofi-man.pod  > docs/rofi-man.7.gz
# to view the manpage
man -l docs/rofi-man.7.gz
```
