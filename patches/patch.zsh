#!/bin/zsh

curdir=$(pwd)
repo=/home/vagrant/lsm/camflow-dev/build/linux-stable
base_commit=c33791d1ceb7652d15a1582091edf38adc4e1164

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
