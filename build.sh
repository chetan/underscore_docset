#!/bin/sh

cd UnderscoreJS.docset/Contents/Resources
ruby tokens.rb
cd -
/Developer/usr/bin/docsetutil index UnderscoreJS.docset/
