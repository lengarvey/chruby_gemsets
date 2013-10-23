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

function chruby_gemset() {
  chruby_gemset=$1

eval `ruby - <<EOF
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
  export PATH=$DEFAULT_PATH
  export GEM_HOME=$DEFAULT_GEM_HOME
  export GEM_PATH=$DEFAULT_GEM_PATH
}

function chruby_gemset_auto() {
	local dir="$PWD"
	local gemset

	until [[ -z "$dir" ]]; do
		if { read -r gemset <"$dir/.chruby-gemset"; } 2>/dev/null; then
      CHRUBY_GEMSET="$version"
      chruby_gemset "$gemset"
      return $?
		fi

		dir="${dir%/*}"
	done

	if [[ -z "$gemset" ]]; then
    reset_chruby_gemset
		unset CHRUBY_GEMSET
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then
	if [[ ! "$preexec_functions" == *chruby_gemset_auto* ]]; then
		preexec_functions+=("chruby_gemset_auto")
	fi
fi
