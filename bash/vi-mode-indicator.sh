#!/bin/bash
# Cross-terminal compatible vi mode indicator for bash
# Detects terminal capabilities and provides appropriate visual feedback
# without breaking shell integration features.

# Enable vi mode in bash
set -o vi

# Function to detect terminal capabilities
detect_terminal_capabilities() {
    local term="$TERM"
    local terminal_program=""
    
    # Detect common terminal programs
    case "$term" in
        xterm*|rxvt*|screen*|tmux*)
            # Xterm-compatible terminals usually support DECSCUSR
            echo "xterm-compatible"
            ;;
        alacritty*|kitty*)
            # Modern terminals with good DECSCUSR support
            echo "modern"
            ;;
        *)
            # Unknown or minimal terminal
            echo "minimal"
            ;;
    esac
}

# Function to set vi mode indicators based on terminal capabilities
setup_vi_mode_indicators() {
    local capabilities=$(detect_terminal_capabilities)
    
    case "$capabilities" in
        xterm-compatible|modern)
            # These terminals support DECSCUSR cursor shape changes
            # Use cursor shape to indicate vi mode
            bind 'set show-mode-in-prompt on'
            bind "set vi-cmd-mode-string \1\e[2 q\2"    # Steady block cursor for command mode
            bind "set vi-ins-mode-string \1\e[6 q\2"    # Steady bar cursor for insert mode
            ;;
        minimal)
            # Minimal terminals - use prompt indicator only
            bind 'set show-mode-in-prompt on'
            bind "set vi-cmd-mode-string \1(cmd)\2"
            bind "set vi-ins-mode-string \1(ins)\2"
            ;;
        *)
            # Fallback - no visual indicator
            bind 'set show-mode-in-prompt off'
            ;;
    esac
    
    # Additional vi mode improvements
    bind 'set editing-mode vi'
    bind 'set keymap vi-command'
    
    # Common vi mode bindings that work across terminals
    bind -m vi-command '"\C-l": clear-screen'
    bind -m vi-command '"\C-a": beginning-of-line'
    bind -m vi-command '"\C-e": end-of-line'
    bind -m vi-insert '"\C-a": beginning-of-line'
    bind -m vi-insert '"\C-e": end-of-line'
}

# Only run if we're in an interactive shell
if [[ $- == *i* ]]; then
    setup_vi_mode_indicators
fi

# Export function for manual reconfiguration
export -f detect_terminal_capabilities setup_vi_mode_indicators