#!/bin/bash
#
# Authors: Michał Borzęcki
# Copyright (C) 2024 ACK CYFRONET AGH
# This software is released under the MIT license cited in 'LICENSE.txt'
#
# This script generates "oneicons" font from the icon images in the "src" directory.
# It requires one argument: target directory where the font should be placed.

OUTPUT=$1

# Generate icons font
npx --yes fantasticon@2.0.0 \
  $(dirname $0)/src \
  --output "$OUTPUT" \
  --name oneicons \
  --tag span \
  --prefix oneicon \
  --font-types woff2 woff \
  --asset-types css html scss \
  --font-height 1024

# Add file path prefix variable to .scss content
sed -i 's/url("./url("#{$icomoon-font-path}/g' "$OUTPUT/oneicons.scss"

# Remove anti-cache query string from file names
sed -i -E 's/(\.woff2|\.woff)\?[a-z0-9]+"/\1"/g' "$OUTPUT/oneicons.css" "$OUTPUT/oneicons.scss"

# Remove "span" tag selector from the main icon styles (to make it work with all tags)
sed -i 's/span\[class/\[class/g' "$OUTPUT/oneicons.css" "$OUTPUT/oneicons.scss"

# Remove ":before" pseudoselector from the main icon styles (it break existing styling)
sed -i 's/]:before/]/g' "$OUTPUT/oneicons.css" "$OUTPUT/oneicons.scss"

# Remove enforced "font-weight: normal" from the main icon styles (it breaks existing styling)
sed -i 's/font-weight: normal !important;/font-weight: normal;/g' "$OUTPUT/oneicons.css" "$OUTPUT/oneicons.scss"
