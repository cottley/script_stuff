#!/bin/sh
cd ~/site
bundle exec jekyll build
cd ~/github-site/cottley.github.io
sed -i -e 's/http:\/\/0.0.0.0:4000/https:\/\/cottley.github.io/g' sitemap.xml
git add -A
git commit -a -m "New Post"
git push
