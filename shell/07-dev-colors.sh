#!/bin/bash
# Solarized Light developer tool colors

# GCC compiler output colors (warnings=yellow, errors=red, notes=cyan)
export GCC_COLORS='error=01;31:warning=01;33:note=01;36:caret=01;32:locus=01:quote=01'

# Grep match highlighting (bold cyan match, bold blue filename, bold green line number)
export GREP_COLORS='ms=01;36:mc=01;36:sl=:cx=:fn=01;34:ln=01;32:bn=01;32:se=38;2;147;161;161'

# Less colors (reuse man page colors for consistency)
export LESS='-R --mouse'

# Podman/Docker buildkit colors
export BUILDKIT_COLORS='run=38;2;42;161;152:cancel=38;2;220;50;47:error=38;2;220;50;47:warning=38;2;181;137;0'
