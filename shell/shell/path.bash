#
# Set path
#

# User-provided executables
path_prepend "$HOME/bin:$HOME/.local/bin"

# Ruby
path_prepend "$HOME/.rbenv/bin"
path_prepend "$HOME/.rbenv/plugins/ruby-build/bin"

# Rust
path_append "$HOME/.cargo/bin"
