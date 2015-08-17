uname=`uname`

if [[ $uname == 'Darwin' ]]; then
	export PLPATH=`pip -V | grep pip | awk '{print $4}'`
else
	export PLPATH=`pip -V | grep pip | awk '{print $4}'`
fi

export LANG=ru_RU.UTF-8
export LC_ALL=ru_RU.UTF-8

export EDITOR=vim

export GEM_HOME=~/.gem/ruby/2.0.0
export GOPATH=$HOME/Sources/go
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$GEM_HOME/bin:$HOME/bin:/usr/local/opt/go/libexec/bin:$GOPATH/bin
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
