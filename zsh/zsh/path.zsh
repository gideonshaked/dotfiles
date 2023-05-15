#
# Set path
#

# ~/.local/bin
path_prepend "$HOME/.local/bin"

# User-provided executables
path_prepend "$HOME/bin"
path_prepend "$HOME/scripts"

# Ruby
path_prepend "$HOME/.rbenv/bin"
path_prepend "$HOME/.rbenv/plugins/ruby-build/bin"

# Rust
path_append "$HOME/.cargo/bin"

# Anaconda
path_append "/opt/homebrew/anaconda3/bin"
