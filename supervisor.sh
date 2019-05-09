#!/bin/bash

LOG=/var/log/supervisor
RUN=/opt/run/

if [ -f "${LOG}" ]; then
	echo > "${LOG}";
else
	touch "${LOG}";
fi

if find "${RUN}" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
	echo "Starting supervisor";
else
	echo "No executables found in ${RUN}";
	exit 0;
fi

for file in "${RUN}/"*; do
	echo "Starting ${file}"
	"${file}" >> "${LOG}" &
done

tail -f "${LOG}"
