# tmux-notify.zsh — red dot in session bar + desktop notification when a
# long-running command finishes. Clears on the next command (preexec).

_PROCESS_NOTIFY_THRESHOLD=10   # seconds; commands shorter than this are ignored

_process_preexec() {
  _cmd_start_time=$EPOCHSECONDS
  _cmd_name="${1%% *}"   # first word of the command line

  # Clear any existing done flag for this pane when a new command starts
  [[ -z "$TMUX" || -z "$TMUX_PANE" ]] && return
  local session window
  session=$(tmux display-message -p -t "$TMUX_PANE" '#{session_name}' 2>/dev/null) || return
  window=$(tmux display-message -p  -t "$TMUX_PANE" '#{window_index}'  2>/dev/null) || return
  local flag="/tmp/process-done/${session}_${window}"
  if [[ -f "$flag" ]]; then
    rm -f "$flag"
    tmux refresh-client -a -S 2>/dev/null || true
  fi
}

_process_precmd() {
  local elapsed=$(( EPOCHSECONDS - ${_cmd_start_time:-0} ))
  if [[ ${_cmd_start_time:-0} -gt 0 && $elapsed -ge $_PROCESS_NOTIFY_THRESHOLD && -n "$TMUX" && -n "$TMUX_PANE" ]]; then
    local session window
    session=$(tmux display-message -p -t "$TMUX_PANE" '#{session_name}' 2>/dev/null) || { _cmd_start_time=0; return; }
    window=$(tmux display-message -p  -t "$TMUX_PANE" '#{window_index}'  2>/dev/null) || { _cmd_start_time=0; return; }

    # Desktop notification
    notify-send "Done: $_cmd_name" "Finished in ${elapsed}s" 2>/dev/null || true

    # Flag for status bar red dot — cleared on next command (preexec above)
    mkdir -p /tmp/process-done
    touch "/tmp/process-done/${session}_${window}"
    tmux refresh-client -a -S 2>/dev/null || true
  fi
  _cmd_start_time=0
  _cmd_name=""
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _process_preexec
add-zsh-hook precmd  _process_precmd
