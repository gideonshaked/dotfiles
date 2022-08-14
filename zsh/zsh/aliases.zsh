#
# Useful aliases
#

# Show current DNS provider
alias dns="( nmcli dev list || nmcli dev show ) 2>/dev/null | grep DNS"

# Get battery charge status
alias batt="upower -i $(upower -e | grep BAT) | grep --color=never -E 'state|to\ full|to\ empty|percentage'"

# Make Python easier to use
alias python="python3"
alias pip="pip3"

# Pipe output of command to clipboard
alias clip="xclip -selection c"

# Something SFW
alias oops="fuck"

# Turn on/off fractional scaling
alias fracon="gsettings set org.gnome.mutter experimental-features \"['x11-randr-fractional-scaling']\""
alias fracoff="gsettings reset org.gnome.mutter experimental-features"
