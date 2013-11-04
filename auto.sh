if [[ -z $GEMSET ]]; then
  # echo "The GEMSET is not set"
  if [ -z "$DEFAULT_GEM_HOME" ]; then
    export DEFAULT_GEM_HOME=$GEM_HOME
  fi

  if [ -z "$DEFAULT_GEM_PATH" ]; then
    export DEFAULT_GEM_PATH=$GEM_PATH
  fi

  if [ -z "$DEFAULT_PATH" ]; then
    export DEFAULT_PATH=$PATH
  fi
fi

function chruby_gemset() {
  # Save existing environment setup
  if [ -z "$DEFAULT_GEM_HOME" ]; then
    export DEFAULT_GEM_HOME=$GEM_HOME
  fi

  if [ -z "$DEFAULT_GEM_PATH" ]; then
    export DEFAULT_GEM_PATH=$GEM_PATH
  fi

  if [ -z "$DEFAULT_PATH" ]; then
    export DEFAULT_PATH=$PATH
  fi
  chruby_gemset=$1

  ruby_bin="`command -v unbundled_ruby || command -v ruby`"

eval `$ruby_bin - <<EOF
require 'rubygems'
puts "ruby_engine=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'}"
puts "ruby_version=#{RUBY_VERSION}"
puts "gem_path=\"#{Gem.path.join(':')}\""
EOF`

  gem_dir="$HOME/.gem/gemsets/$ruby_engine/$ruby_version/$chruby_gemset"

  export PATH="$gem_dir/bin:$PATH"
  export GEM_HOME="$gem_dir"
  export GEM_PATH="$gem_dir"
}

function reset_chruby_gemset() {
  if [[ -z "$DEFAULT_PATH" ]]; then
  else
    export PATH=$DEFAULT_PATH
    export GEM_HOME=$DEFAULT_GEM_HOME
    export GEM_PATH=$DEFAULT_GEM_PATH
  fi
}

function chruby_gemset_auto() {
	local dir="$PWD"
	local gemset

	until [[ -z "$dir" ]]; do
    # echo "Scanning $dir for gemset"
    if { read -r gemset <"$dir/.gemset"; } 2>/dev/null; then
      if [[ -z "$GEMSET" ]]; then
        # echo "Applying gemset: $gemset"
        chruby_gemset "$gemset"
        export GEMSET=$gemset
      fi
      # echo "Gemset found: $gemset - GLOBAL gemset is: $GEMSET"
      return $?
    fi
    if { read -r gemset <"$dir/.ruby-gemset"; } 2>/dev/null; then
      if [[ -z "$GEMSET" ]]; then
        chruby_gemset "$gemset"
        export GEMSET=$gemset
        return $?
      fi
    fi
    dir="${dir%/*}"
	done

  # echo "Finished scanning. Gemset is $gemset and GEMSET is $GEMSET"

	if [[ -z "$gemset" ]]; then
    # echo "Unsetting your gemset. Default path: $DEFAULT_PATH"
    unset GEMSET
    reset_chruby_gemset
    unset DEFAULT_GEM_PATH
    unset DEFAULT_GEM_HOME
    unset DEFAULT_PATH
  fi
}

if [[ -n "$ZSH_VERSION" ]]; then
	if [[ ! "$preexec_functions" == *chruby_gemset_auto* ]]; then
		preexec_functions+=("chruby_gemset_auto")
	fi
fi
