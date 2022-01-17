#!/bin/bash

# Repo update script using repo-add, rsync, and git
# written by Nathaniel Maia for ArchLabs, December 2017-2020

path="$(realpath "${0%/*}")"

if ! hash git >/dev/null 2>&1; then
    echo "ERROR: Script requires git installed"
    exit 1
fi

if [[ -d $path ]]; then
    cd "$path" || exit
    rm -f archlabs-testing.* archlabs-testing.db.tar.gz
    repo-add archlabs-testing.db.tar.gz ./*.pkg.tar.xz ./*.pkg.tar.zst || exit
	rm -f archlabs-testing.db archlabs-testing.files
    cp -f archlabs-testing.db.tar.gz archlabs-testing.db || exit
	cp -f archlabs-testing.files.tar.gz archlabs-testing.files || exit


	echo -e "\nPushing to git origin"
    if [[ -e $HOME/.gitconfig ]]; then
        cd .. || exit
        git add . || exit
        git commit -m "Repo update $(date +%a-%D)" || exit
        git push origin master || exit
    else
        echo "ERROR: You must setup git to use this"
        exit 1
    fi
else
    echo -e "\nCannot find repo directory: '$path'"
    exit 1
fi

echo -e "\nRepo updated!!"
exit 0
