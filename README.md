# B O O M

See? Look, a tiny explosion: \*

## What's a boom?

boom lets you access text snippets over your command line. I'm personally
aiming for exactly two use cases, but I'm almost positive there are thirteen
more. Here's a couple examples:

- **Your own [del.icio.us](http://delicious.com)-esque URL tracker.** When I
  make [clever animated
  gifs](http://github.com/holman/dotfiles/blob/master/bin/gifme) of my
  coworkers, I tend to lose the URL, which is a total bummer since I want to
  repeatedly repost these images well past their funny expiration date. boom
  lets me easily access the good stuff for years to come.
- **Commonly-used email replies.** Everyone's got those stock replies in their
  pocket for a few common use cases. Rather than keep some files strewn about
  with the responses, boom gives me them on my ever-present command line.
- **Simple todos.** You can super-quickly drop items into lists and remove them
  when finished. I'm a big fan of simple, straightforward stuff. Plus, it's a
  Dropbox away from simple cloud syncing. Someone get Cultured Code on the line
  THIS MAY BE RELEVANT TO THEIR INTERESTS!

We store everything in one JSON file in your home directory: `~/.boom`. The
structure is simple, too. Each individual item is tossed on a `list`, and you
can have multiple lists.

## Show me the boom

** Overview **

    $ boom
    gifs (5)
    email (4)

** Create a list **

    $ boom urls
    Boom! Created a new list called "urls".

** Add an item **

    # boom <list> <name> <value>
    $ boom urls github https://github.com
    Boom! "github" in "urls" is "https://github.com". Got it.

** Copy an item's value to your clipboard **

    $ boom github
    Boom! Just copied https://github.com to your clipboard.

    $ boom urls github
    Boom! Just copied https://github.com to your clipboard.

** List items in a list **

    $ boom urls
    blog   http://zachholman.com
    github http://github.com

** Delete a list **

    $ boom urls delete
    You sure you want to delete everything in "urls"? (y/n): y
    Boom! Deleted all your urls.

** Delete an item **

    # boom urls github delete
    Boom! "github" is gone forever.

** List everything **

    $ boom all
      enemies
        @kneath:          he's got dreamy eyes. he must die.
        @rtomayko:        i must murder him for his mac and cheese recipe.
        @luckiestmonkey:  she hates recycling.
      urls
        blog:   http://zachholman.com
        github: https://github.com

** Help **

    $ boom help

** Manual edit **

If you want to edit the underlying JSON directly, make sure your `$EDITOR`
environment variable is set, and run:

    $ boom edit

** It's just the command line, silly **

So don't forget all your other favorites are there to help you, too:

    $ boom all | grep @luckiestmonkey
        @luckiestmonkey:  she hates recycling.

## Install

    gem install boom

## Current Status

Precarious. I'm starting to use this a bunch now, but if you're tossing in
important business information (say, a carefully cultivated list of animated
.gifs), you'd be sitting pretty if you made a backup of `~/.boom` every now and
then, just in case. We're living on the edge, baby.

Also, don't mistype anything. Everything should be 100% perfect if you type all
the commands correctly. If you don't, it'll probably ungracefully error out and
a puppy in Kansas will probably be murdered. You should be fine, though. As
long as you don't have butter fingers.

Soon enough, though, this'll be stable to the point where I can truthfully tell
myself that this time baby, `boom` will be, bulletttttttttttttproof ♫.

## I love you

[Zach Holman](http://zachholman.com) made this. Ping me on Twitter —
[@holman](http://twitter.com/holman) — if you're having issues, want me to
merge in your pull request, or are using boom in a cool way. I'm kind of hoping
this is generic enough that people do some fun things with it. First one to use
`boom` to calculate their tax liability wins.
