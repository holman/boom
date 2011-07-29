# boom changes

## head

## 0.2.2 (July 29, 2011)
- [@jimmycuadra](https://github.com/jimmycuadra) went to town on this beast and
  hooked up a Gist backend to boom. Killer.
- Small Windows fix.

## 0.2.1 (July 16, 2011)
- boom displays colors thanks to [@dandorman](https://github.com/dandorman).
- Windows support, brah. [@tombell](https://github.com/tombell).
- boom accepts piped-in data (like `cat admins.txt | boom groups admins`).
  Thanks [@brettbuddin](https://github.com/brettbuddin) and
  [@antonlindstrom](https://github.com/antonlindstrom). Tag-team action.
- `boom <newlist> <item> <value>` will actually create the list and item now.
  [@jmazzi](https://github.com/jmazzi).

## 0.2.0 (April 12, 2011)
- Add Keychain storage to store Boom data securely in OS X's Keychain.app.
  Thanks, [@davidtrogers](https://github.com/davidtrogers)!
- Switch from yajl-ruby because [OS X isn't for
  developers](http://zachholman.com/2011/03/osx-isnt-for-developers/). Thanks
  for finishing it up, [@antonlindstrom](https://github.com/antonlindstrom).
- Move dependencies to Bundler, because it's the One True Way™ at this point.
- Some README updates.
- `boom -v`.

## 0.1.2
- Copy to clipboard doesn't hang anymore. Sweet. Thanks,
  [mcollina](https://github.com/mcollina).
- Holy hell, [brettbuddin](https://github.com/brettbuddin) added completion for
  zsh. Pretty awesome too.
- [antonlindstrom](https://github.com/antonlindstrom) fixed up the MongoDB
  backend.

## 0.1.1
- Don't force Redis on everyone.

## 0.1.0
- boom has been rewritten to use multiple backends. Use `boom switch <backend>`
  to switch from the default JSON backend. Currently only Redis is supported.
  Pull Requests are welcome.

## 0.0.10
- `boom open` will open the Item's URL in a browser, or it'll open all the URLs
  in a List for you. Thanks [lwe](https://github.com/lwe).
- Values for item creation can have spaces, and then they get concat'ed as one
  value. Thanks [lwe](https://github.com/lwe).
- Replacing an item no longer dupes the item; it'll just replace the value.
  Thank god, finally. Thanks [thbishop](https://github.com/thbishop).
- Also started `completion/`, a place to drop in scripts to set up completion
  support for boom. Starting out with [thbishop](https://github.com/thbishop)'s
  bash script, but if anyone has something for zsh I'd kiss them a bit.
- `boom echo` (and `boom e`) just echos the value; great for command-line
  scripts and junk! Thanks [bschaeffer](https://github.com/bschaeffer).

## 0.0.9
- Backport `Symbol#to_proc` for 1.8.6 support (thanks 
  [kastner](https://github.com/kastner) and 
  [DeMarko](https://github.com/DeMarko)).

## 0.0.8
- Support for Ruby 1.9 (thanks [jimmycuadra](https://github.com/jimmycuadra)).

## 0.0.7
- Reverts item creation from stdin, since it broke regular item creation.

## 0.0.6
- Searching for an item that doesn't exist doesn't murder puppies anymore
  (thanks [jimmycuadra](https://github.com/jimmycuadra)).
- Output is a bit cleaner with a constrained `name` column.
- Adds items from stdin (thanks
  [MichaelXavier](https://github.com/MichaelXavier)). 

## 0.0.5
- Item deletes are now scoped by list rather than GLOBAL DESTRUCTION! (thanks
  [natebean](https://github.com/natebean)).
- Command line options, like `boop --help` are translated into `boom help`. In
  the future we play around with options a bit more.
- Non-Mac-based platforms get clipboard support with `xclip`. If it's
  problematic (which it almost certainly is; I'm breaking this more or less on
  purpose), please patch it and send me a pull request for your particular
  platform.

## 0.0.4
- Adds `boom help`. You know, for help.

## 0.0.3
- `boom edit` to edit your stuff in a friendly $EDITOR.
- Class-level accessors in List for ActiveRecordesque actions.

## 0.0.2
- Fix for list selection (thanks [bgkittrell](https://github.com/bgkittrell)).

## 0.0.1
- BOOM!
