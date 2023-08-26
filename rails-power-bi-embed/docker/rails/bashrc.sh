# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
case "${RAILS_ENV}" in
  staging) color=33 ;;
  production) color=31 ;;
  *) color=36 ;;
esac
PS1="\[\e[1;${color}m\][rails-power-bi-embed][${RAILS_ENV:-development}][$(hostname -i)] \w \$\[\e[m\] "
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
