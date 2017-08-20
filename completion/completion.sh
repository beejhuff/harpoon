cmplt() {
	prefix=""

	if [ ${2:-} ]; then
		prefix="$2:"
	fi

	completions=$(grep -E '^\t[a-zA-Z0-9:|_-]+\)\s##\s.*$' ${1} | sed $'s/\t//' | sort | awk -v prefix="$prefix" 'BEGIN {FS = "\\).*?## |%%"}; {printf "%s\n", prefix$1}') || true
	echo -e "$completions"
}

service_c_cmds() {
	S=$(parse_cmd ${1})
	echo -e "${S}:clean\n${S}:clean-if-up"
}

service_d_cmds() {
	S=$(parse_cmd ${1})
	echo -e "${S}:down\n${S}:down-if-up\n${S}:destroy\n${S}:destroy-if-up"
}

service_e_cmds() {
	S=$(parse_cmd ${1})
	echo -e "${S}:exec"
}

service_k_cmds() {
	S=$(parse_cmd ${1})
	echo -e "${S}:kill"
}

service_l_cmds() {
	S=$(parse_cmd ${1})
	echo -e "${S}:logs"
}

service_p_cmds() {
	S=$(parse_cmd ${1})
	echo -e "${S}:pause\n${S}:port\n${S}:port:primary\n${S}:ps"
}

service_s_cmds() {
	S=$(parse_cmd ${1})
	echo -e "${S}:stop\n${S}:start\n${S}:sh\n${S}:status"
}

service_r_cmds() {
	S=$(parse_cmd ${1})
	echo -e "${S}:restart\n${S}:reset\n${S}:rm\n${S}:run"
}

service_u_cmds() {
	S=$(parse_cmd ${1})
	echo -e "${S}up\n${S}:up-if-down\n${S}unpause"
}

case "${2:-}" in
	*:*)
		TASK_NAME=$(parse_cmd ${args})

		task_exists ${TASK_NAME}

		if [ -v TASK_ROOT ]; then
			cmplt ${TASK_ROOT}/handler.sh
			echo -e "\n"
		else
			service_exists ${TASK_NAME}

			if [ -v SERVICE_ROOT ]; then
				service_c_cmds ${TASK_NAME}
				echo -e "\n"
				service_d_cmds ${TASK_NAME}
				echo -e "\n"
				service_e_cmds ${TASK_NAME}
				echo -e "\n"
				service_k_cmds ${TASK_NAME}
				echo -e "\n"
				service_l_cmds ${TASK_NAME}
				echo -e "\n"
				service_p_cmds ${TASK_NAME}
				echo -e "\n"
				service_s_cmds ${TASK_NAME}
				echo -e "\n"
				service_r_cmds ${TASK_NAME}
				echo -e "\n"
				service_u_cmds ${TASK_NAME}
				echo -e "\n"
				cmplt ${SERVICE_ROOT}/handler.sh;
			fi
		fi
		;;
	*)
		cmplt ${HARPOON_ROOT}/harpoon
		echo ""

		tasks
		echo ""

		services
		echo ""

		if [ -v ROOT_TASKS_FILE ]; then
			cmplt ${ROOT_TASKS_FILE} ${PROJECT_TASK_PREFIX}

			if [ -v ADDITIONAL_TASK_FILES ]; then
				IFS=',' read -ra ATFS <<< "$ADDITIONAL_TASK_FILES"
				for i in "${ATFS[@]}"; do
					cmplt ${i} ${PROJECT_TASK_PREFIX}
				done
			fi
		fi
esac
