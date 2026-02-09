#!/usr/bin/env bash
# Installs XeLaTeX, fonts, and core packages

set -euo pipefail

echo "Installing LaTeX packages..."

apt-get update -qq

apt-get install -y -qq \
    texlive-xetex \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-lang-french \
    fonts-inter \
    make \
    parallel

echo "LaTeX installation complete."
