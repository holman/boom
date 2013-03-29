# B O O M

## About

boom manages your text snippets on your command line. You can stash away text
like URLs, canned responses, and important notes and then quickly copy them
onto your clipboard, ready for pasting.

For more details about what boom is and how it works, check out
[boom's website](http://holman.github.com/boom).

## Install

    gem install boom

## Quick and Dirty

    $ boom gifs
    Boom! Created a new list called "gifs".

    $ boom gifs shirt http://cl.ly/NwCS/shirt.gif
    Boom! "shirt" in "gifs" is "http://cl.ly/NwCS/shirt.gif". Got it.

    $ boom shirt
    Boom! Just copied http://cl.ly/NwCS/shirt.gif to your clipboard.

And that's just a taste! I know, you're salivating, I can hear you from here.
(Why your saliva is noisy is beyond me.) Check out the [full list of
commands](https://github.com/holman/boom/wiki/Commands).

## Contribute

Want to join the [Pantheon of
Boom'ers](https://github.com/holman/boom/contributors)? I'd love to include
your contributions, friend.

Clone this repository, then run `bundle install`. That'll install all the gem
dependencies. Make sure your methods are [TomDoc](http://tomdoc.org)'d
properly, that existing tests pass (`rake`), and that any new functionality
includes appropriate tests.

The tests are written in shell for
[roundup](https://github.com/bmizerany/roundup), since boom is basically just
Ruby pretending to be shell. `rake` should run them all for you just fine.

All good? Cool! Then [send me a pull request](https://github.com/holman/boom/pull/new/master)!

## I love you

[Zach Holman](http://zachholman.com) made this. Ping me on Twitter —
[@holman](http://twitter.com/holman) — if you're having issues, want me to
merge in your pull request, or are using boom in a cool way. I'm kind of hoping
this is generic enough that people do some fun things with it. First one to use
`boom` to calculate their tax liability wins.