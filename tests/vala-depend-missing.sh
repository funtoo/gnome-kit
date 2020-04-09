#!/bin/sh
for x in $(grep -r 'inherit.*vala' * | cut -f1 -d: | grep 'ebuild$'); do
	foo="$(grep vala_depend $x 2>/dev/null)"
	[ -z "$foo" ] && echo $x
done
