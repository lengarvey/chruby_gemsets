# chruby_gemsets

Gemsets for [chruby](https://github.com/postmodern/chruby)

although there shouldn't be a reason this would work with any ruby version tool (RVM, rbenv etc)

## Installation

    git clone https://github.com/lengarvey/chruby_gemsets.git
    echo "source $PWD/chruby_gemsets/auto.sh" > ~/.zshenv
    source $PWD/chruby_gemsets/auto.sh

## Create a gemset

Just put the name of the gemset inside a `.chruby-gemset` file somewhere in your project tree.

## Tips for dealing with git

If you want to hide the fact you're using a particular gemset:

    echo ".chruby-gemset" > .git/info/exclude

This adds your `.chruby-gemset` file to a local only .gitignore.

# License

MIT. Do whatever you want with this

# Credits

Based on auto.sh from chruby

# Known Issues

Only works with zsh. Should be easy to make it work with bash, but I don't have time to test it just yet :(
