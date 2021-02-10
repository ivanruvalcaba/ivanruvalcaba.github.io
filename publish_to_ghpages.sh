#! /bin/sh
#
# Filename: publish_to_ghpages.sh
# Author: Iván Ruvalcaba
# Contact: <ivanruvalcaba[at]disroot[dot]org>
# Created: 12 oct 2020 12:20:22
# Last Modified: 12 oct 2020 12:37:10
#
# Copyright (C) 2020  Iván Ruvalcaba <ivanruvalcaba[at]disroot[dot]org>
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program.  If not, see
# <http://www.gnu.org/licenses/>.

# Este script fue tomado directamente de la documentación oficial de Hugo, véase:
#
# https://gohugo.io/hosting-and-deployment/hosting-on-github/#deployment-of-project-pages-from-your-gh-pages-branch

if [ "`git status -s`" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publicar a gh-pages (publish_to_ghpages.sh)"

echo "Pushing to Github"
git push --all
