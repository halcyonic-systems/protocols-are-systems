#!/bin/sh
# Build the blueprint (web and PDF), the Lean declaration map, and the Jekyll site,
# then assemble them into _site/. Run from the repository root.
# blueprint.pdf is committed so the CI build needs no TeX.
set -e
cd "$(dirname "$0")/.."
export PATH="$PWD/.venv/bin:$PATH"
leanblueprint web
leanblueprint pdf
cp blueprint/print/print.pdf blueprint.pdf
python scripts/declmap.py
BUNDLE_PATH=vendor/bundle bundle exec jekyll build --quiet
rm -rf _site/blueprint
cp -R blueprint/web _site/blueprint
echo "site assembled in _site/"
