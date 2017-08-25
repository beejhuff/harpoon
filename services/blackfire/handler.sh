#!/usr/bin/env bash

case "${command}" in
	blackfire:curl) ## URL %% 🔥  Blackfire Client
		docker run -it --rm -e BLACKFIRE_CLIENT_ID -e BLACKFIRE_CLIENT_TOKEN blackfire/blackfire blackfire curl ${args} ;;

	*)
		serviceHelp blackfire
esac
