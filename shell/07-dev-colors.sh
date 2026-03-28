#!/bin/bash
# Solarized Light developer tool colors

# GCC compiler output colors (warnings=yellow, errors=red, notes=cyan)
export GCC_COLORS='error=01;31:warning=01;33:note=01;36:caret=01;32:locus=01:quote=01'

# Grep match highlighting (cyan match, yellow filename, green line number)
export GREP_COLORS='ms=36:mc=36:sl=:cx=:fn=33:ln=32:bn=32:se=93'

# Less colors (reuse man page colors for consistency)
export LESS='-R --mouse'

# Podman/Docker buildkit colors
export BUILDKIT_COLORS='run=38;2;42;161;152:cancel=38;2;220;50;47:error=38;2;220;50;47:warning=38;2;181;137;0'
