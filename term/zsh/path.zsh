#
# Set path
#

# ~/.local/bin
path_prepend "$HOME/.local/bin"

# User-provided executables
path_prepend "$HOME/bin"

# Anaconda
path_append "/opt/homebrew/anaconda3/bin"

# Homebrew
path_prepend "/opt/homebrew/bin"

# Java
path_prepend "/opt/homebrew/opt/openjdk/bin"
