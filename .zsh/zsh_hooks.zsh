function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd {
  # vcs_info
  # Put the string "hostname::/full/directory/path" in the title bar:
  echo -ne "\e]2;$PWD\a"

  # Put the parentdir/currentdir in the tab
  echo -ne "\e]1;$PWD:h:t/$PWD:t\a"

  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    export RPROMPT="%F{cyan}${timer_show}s %{$reset_color%}"
    unset timer
  fi
}

# function set_running_app {
#   printf "\e]1; $PWD:t:$(history $HISTCMD | cut -b7- ) \a"
# }

# function preexec {
#   set_running_app
# }

# function postexec {
#   set_running_app
# }
