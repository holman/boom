# B O O M

## About

boom manages your text snippets. On the command line. I just blew your mind.

For more details about what boom is and how it works, check out
[boom's website](http://holman.github.com/boom). For full usage details
(including a complete list of commands), check out
[boom's wiki](https://github.com/holman/boom/wiki).

## Install

    gem install boom

## Quick and Dirty

    $ boom gifs
    Boom! Created a new list called "gifs".

    $ boom gifs melissa http://cl.ly/3pAn/animated.gif
    Boom! "melissa" in "gifs" is "http://cl.ly/3pAn/animated.gif". Got it.

    $ boom melissa
    Boom! Just copied http://cl.ly/3pAn/animated.gif to your clipboard.

## Remote boom
You can even have a remote boom using config in ~/.boom.remote.conf
    $ boomr "a sandwich" cheese "mighty fine"
    Boom! cheese in a sandwich is mighty fine. Got it.

e.g. have a shared redis instance in the office for pinging around snippets to
each others command lines
    # me:
    $ boomr config ackrc < ~/.ackrc

    # you:
    $ boomr config ackrc > ~/.ackrc


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
includes appropriate tests. Bonus points if you're not updating the gemspec or
bumping boom's version.

All good? Cool! Then [send me a pull request](https://github.com/holman/boom/pull/new/master)!

## I love you

[Zach Holman](http://zachholman.com) made this. Ping me on Twitter —
[@holman](http://twitter.com/holman) — if you're having issues, want me to
merge in your pull request, or are using boom in a cool way. I'm kind of hoping
this is generic enough that people do some fun things with it. First one to use
`boom` to calculate their tax liability wins.
