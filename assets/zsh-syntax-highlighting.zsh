# One Dark Pro Theme (for zsh-syntax-highlighting) - Darker Variant

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

# Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#535965'   # One Dark darker grey

# Functions, commands, aliases
ZSH_HIGHLIGHT_STYLES[alias]='fg=#8ebd6b'   # green
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#8ebd6b'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#8ebd6b'
ZSH_HIGHLIGHT_STYLES[function]='fg=#8ebd6b'
ZSH_HIGHLIGHT_STYLES[command]='fg=#8ebd6b'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#8ebd6b,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#e2b86b,italic'  # yellow
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#e2b86b'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#e2b86b'

# Arguments quoted/backquoted
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#bf68d9'  # purple

# Keywords and built-ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#48b0bd'      # cyan
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#48b0bd'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#48b0bd'

# Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#e55561'          # red
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#a0a8b7'  # fg color
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#a0a8b7'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#a0a8b7'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#e55561'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#e55561'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#e55561'

# Strings (quoted)
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#8ebd6b'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#8ebd6b'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#8ebd6b'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#e55561'  # error red
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#8ebd6b'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#e55561'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#8ebd6b'

# Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#a0a8b7'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#e55561'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#a0a8b7'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#a0a8b7'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#a0a8b7'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#a0a8b7'

# Errors and unknown tokens
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#e55561'

# Paths
ZSH_HIGHLIGHT_STYLES[path]='fg=#a0a8b7'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#e55561'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#a0a8b7'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#e55561'

# Globbing
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#a0a8b7'

# History expansion
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#bf68d9'

# Errors with unclosed backquotes
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#e55561'

# I/O Redirection
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#a0a8b7'

# Command arguments and default text
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#a0a8b7'
ZSH_HIGHLIGHT_STYLES[default]='fg=#a0a8b7'

# Cursor style (standout)
ZSH_HIGHLIGHT_STYLES[cursor]='standout'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#535965"

export FZF_DEFAULT_OPTS=" \
  --color=bg:#1f2329,bg+:#30363f,fg:#a0a8b7,fg+:#a0a8b7 \
  --color=hl:#4fa6ed,hl+:#4fa6ed,info:#e2b86b,marker:#8ebd6b \
  --color=prompt:#bf68d9,spinner:#e55561,pointer:#bf68d9,header:#535965,border:#323641 \
"
