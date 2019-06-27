#!/bin/bash
for x in *; do 
	# y = how many ebuilds
	y=$(ls $x/*.ebuild | wc -l)
	if [ $y -ge 2 ]; then
		( cd $x; git ls-files | grep -v / | grep .ebuild | xargs git rm )
	fi 
done
