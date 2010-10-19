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
structure is simple, too. Each individual item is tossed on a `pile`, and you
can have multiple piles.

## Show me the boom

** List all the piles **

    $ boom
    urls (3)
    email (4)

** List the name and value of items in a pile **

    # boom <list-name>
    $ boom urls
    karaoke http://cl.ly/2X13/content
    tomwink http://cl.ly/2azg/content
    jayz    http://cl.ly/2U4n/content

** Copy an item's value to your clipboard **

    # boom <name-of-any-list-item>
    $ boom karaoke
    We just copied http://cl.ly/2X13/content to your clipboard.

** Add an item **

    # boom add <list> <name> <value>
    $ boom add urls jayz http://cl.ly/2U4n/content
    Cool. "jayz" => "http://cl.ly/2U4n/content" in "urls". Got it.

** Delete an item **

    # boom delete <name>
    $ boom delete jayz
    Boom! "jayz" => "http://cl.ly/2U4n/content" is gone forever.

## Install

    gem install boom

## I love you

- [@holman](http://twitter.com/holman)
