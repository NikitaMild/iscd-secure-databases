#!/bin/bash

RUN=/opt/run/

if find "${RUN}" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
	echo "Starting supervisor";
else
	echo "No executables found in ${RUN}";
	exit 0;
fi

i=0
for file in "${RUN}"*; do
	chown mysql:mysql ${file}
	chmod 544 ${file}
	echo "Starting ${file}"

	su mysql -c "${file}" &
	pids[${i}]=$!
	i=$(( i + 1 ))
done

for pid in ${pids[*]}; do
	wait $pid;
done
