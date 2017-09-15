#!/usr/bin/env bash

printFunc() {
	local envs=$(grep -r -E '^# @func\s.*$' ${1} | sort | awk 'BEGIN {FS = ": |# @func|%%"}; {c=$2" "$3; printf "    \033[36m%-35s\033[0m %s\n", c, $4}') || true
	if [[ "${envs}" != "" ]]; then
		echo -e "$envs"
	fi
}

printAllFunc() {
	echo "  Core:"
	printFunc "${HARPOON_ROOT}/harpoon"
	printFunc "${HARPOON_ROOT}/core"
	projectTasksFunc
	echo ""
	exit 0
}

projectTasksFunc() {
	if [ -v ROOT_TASKS_FILE ]; then
		printf "\n${PROJECT_TITLE} Tasks:\n"
		printFunc ${ROOT_TASKS_FILE}
		if [ -v ADDITIONAL_TASK_FILES ]; then
			IFS=',' read -ra ATFS <<< "$ADDITIONAL_TASK_FILES"
			for i in "${ATFS[@]}"; do
				printFunc ${i}
			done
		fi
	fi
}

funcdoc() {
	echo -e "\nHarpoon Functions:"
	if [[ "$args" == "" ]]; then printAllFunc; fi

	# try tasks
	taskExists ${args}

	if [ -v TASK_ROOT ]; then
		printModuleInfo "${TASK_ROOT}/info.txt" "${args}"
		printFunc ${TASK_ROOT}
	else
		# try services
		svcRoot=$(serviceRoot ${args})

		if [[ "$svcRoot" != "" ]]; then
			printModuleInfo "${svcRoot}/info.txt" "${args}"
			printFunc ${svcRoot};
		elif [ -v ROOT_TASKS_FILE ]; then
			# try custom task handler in working directory
			projectTasksFunc
		fi
	fi
	echo ""
}