#!/usr/bin/env bash

if [ ! ${JP_IMAGE_VERSION:-} ]; then
	export JP_IMAGE_VERSION=latest
fi

#todo
if [ ! ${JP_IMAGE:-} ]; then
	export JP_IMAGE=fixme:${JP_IMAGE_VERSION}
fi

if [ ! ${JP_CMD:-} ]; then
	export JP_CMD=""
fi

jp_cli() {
	print_debug "jp args: $@"
	docker_run -i ${JP_IMAGE} ${JP_CMD} $@
}