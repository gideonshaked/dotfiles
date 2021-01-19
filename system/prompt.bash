#
# Initiate Starship prompt if it exists on this system
#

if command -v starship &> /dev/null
then
    eval "$(starship init bash)"
fi
