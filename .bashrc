alias ll="ls -l"

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
source $PLPATH/powerline/bindings/bash/powerline.sh

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
