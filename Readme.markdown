# B O O M

See? Look, a tiny explosion: \*

## What's a boom?

boom lets you access text snippets over your command line. I aim currently
aiming for exactly two use cases, but I'm almost positive there are thirteen
more. The targeted use cases are:

- **A pile of funny URLs.** When I make [clever animated
  gifs](http://github.com/holman/dotfiles/blob/master/bin/gifme) of my
  coworkers, I tend to lose the URL, which is a total bummer since I want to
  repeatedly repost these images well past their funny expiration date. boom
  lets me easily access the good stuff for years to come.
- **Commonly-used email replies.** Everyone's got those stock replies in their
  pocket for a few common use cases. Rather than keep some files strewn about
  with the responses, boom gives me them on my ever-present command line.

We store everything in one JSON file in your home directory: `~/.boom`. The
structure is simple, too. Each individual item is tossed on a `list`, and you
can have multiple lists.

## Show me the boom

** Overview **

    $ boom
    gifs (5)
    email (4)

** Create a List **

    $ boom urls
    Boom! Created a new list called "urls".

** Add an item **

    # boom <list> <name> <value>
    $ boom urls github https://github.com
    Boom! "github" in "urls" is "https://github.com". Got it.

** List items in a list **

    $ boom urls
    blog   http://zachholman.com
    github http://github.com

** Copy an item's value to your clipboard **

    $ boom github
    Boom! Just copied https://github.com to your clipboard.

    $ boom urls github
    Boom! Just copied https://github.com to your clipboard.

** Delete a List **

    $ boom urls delete
    You sure you want to delete everything in "urls"? (y/n): y
    Boom! Deleted all your urls.

** Delete an item **

    # boom urls github delete
    Boom! "github" is gone forever.

** List everything **

    $ boom list
      urls
        blog:   http://zachholman.com
        github: https://github.com

## Install

    gem install boom

## I love you

- [@holman](http://twitter.com/holman)
