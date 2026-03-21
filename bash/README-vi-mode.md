# Cross-Terminal Vi Mode Indicator

## Problem
Terminal emulator shell integration features conflict with readline vi mode configuration, causing broken mode indicators, cursor shape issues, or complete failure of vi mode visual feedback.

## Solution
A bash script that detects terminal capabilities and provides appropriate visual feedback:
- **Modern terminals**: Use DECSCUSR cursor shape changes (block for command mode, bar for insert mode)
- **Minimal terminals**: Use prompt indicators "(cmd)" and "(ins)"
- **Fallback**: Disable visual indicators to avoid breaking shell integration

## Files Changed
1. `bash/vi-mode-indicator.sh` - Main implementation
2. `bash/bashrc` - Integration point
3. `bash/README-vi-mode.md` - This documentation

## Usage
The script automatically runs when bash starts interactively. It:
1. Detects terminal type and capabilities
2. Configures appropriate vi mode indicators
3. Sets common vi bindings that work across terminals

## Testing
1. Open a terminal and start bash
2. Press `Esc` to enter command mode - cursor should change shape or prompt should show "(cmd)"
3. Press `i` to enter insert mode - cursor should change back or prompt should show "(ins)"
4. Test common bindings: `Ctrl+a` (beginning of line), `Ctrl+e` (end of line)

## Compatibility
Tested with:
- xterm, rxvt, screen, tmux (cursor shape changes)
- Alacritty, Kitty (cursor shape changes)
- Minimal terminals (prompt indicators)
- Terminals with shell integration features (fallback to avoid conflicts)

## Source Reference
Based on research from: 2026-03-20 | https://github.com/ghostty-org/ghostty/issues/10953 | GitHub/ghostty | bash: ghostty shell-integration doesn't work with readline mode indicator on OSX