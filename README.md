# chruby_gemsets

Gemsets for [chruby](https://github.com/postmodern/chruby)

although there shouldn't be a reason this wouldn't work with any ruby version tool (RVM, rbenv etc)

## Installation

    git clone https://github.com/lengarvey/chruby_gemsets.git
    echo "source '`pwd`/chruby_gemsets/auto.sh'" >> ~/.zshenv
    source "'`pwd`/chruby_gemsets/auto.sh'"

## Creating a gemset

Just put the name of the gemset inside a `.gemset` file somewhere in your project tree.
So something like:

    echo my-new-gemset > .gemset

You can check that this works by running either `gem env` or `gem list` to see that you've got a fresh gemset.

## Tips for dealing with git

If you want to hide the fact you're using a particular gemset:

    echo ".gemset" > .git/info/exclude

This adds your `.gemset` file to a local only .gitignore.

# Boring stuff

## License

MIT. Do whatever you want with this

## Credits

Based on auto.sh from chruby

## Known Issues

* Only works with zsh. Should be easy to make it work with bash, but I don't have time to test it just yet :(
* Almost entirely untested. Use at own risk.

