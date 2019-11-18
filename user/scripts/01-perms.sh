#!/bin/bash
# adjust groups / permissions

USER_GROUPS=(wheel docker users sambashare)

function do_configure() {
	# add the user to some useful groups
	local ADD_GROUPS=
	for group in "${USER_GROUPS[@]}"; do
		if ! _check_user_group $group; then
			ADD_GROUPS="${ADD_GROUPS}${group},"
		fi
	done
	[[ -n "$ADD_GROUPS" ]] && { 
		echo "Adding user '$USER' to groups: $ADD_GROUPS"
		sudo usermod -aG "${ADD_GROUPS%,}" $USER
	}

	# in any case, ensure correct permissions for the secure folders
	chmod 700 ~/.ssh -R
	[[ -d ~/.secure ]] && chmod 700 ~/.secure -R

    true
}

function _check_user_group() {
	if getent group "$2" | grep &>/dev/null "\b${USER}\b"; then
		return 0
	fi
	return 1
}

