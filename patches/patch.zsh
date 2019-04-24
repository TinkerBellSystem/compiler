#!/bin/zsh

curdir=$(pwd)
repo=/home/vagrant/lsm/camflow-dev/build/linux-stable
base_commit=56a6222ef4bd7a2bc14553f4c3b0782ff63990e7

pushd $repo
while read -A line; do
	syscall=${line[1]}
	# branch=${line[2]}
	# commit=${line[3]}
	commit=${line[2]}
	patch_file=$curdir/$syscall.patch
	# git checkout $branch
	git diff -p $base_commit $commit -- . > $patch_file
done
popd
