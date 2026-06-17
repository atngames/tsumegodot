#!/bin/bash

for d in ./*; do
	if [ -d "$d" ]; then
		cd "$d"
		pwd
		for f in ./*.svg; do
			sed -i '24,30d' "${f}"
			echo "${f}"
		done
		cd ..
	fi
done

