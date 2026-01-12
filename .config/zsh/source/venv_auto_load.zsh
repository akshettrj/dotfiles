function check_and_load_venv() {

    if [[ "$VIRTUAL_ENV_AUTO_LOADED" == 1 ]] && [[ "$PWD"/ != "$VIRTUAL_ENV_ENABLED_DIR"/* ]]; then
        deactivate
        export VIRTUAL_ENV_AUTO_LOADED=""
        export VIRTUAL_ENV_ENABLED_DIR=""
    fi

    if [[ -z "$VIRTUAL_ENV" ]] ; then
        ## If venv folder is found then activate the vitualenv
        if [[ -d ./venv ]]; then
            source ./venv/bin/activate
            export VIRTUAL_ENV_AUTO_LOADED=1
            export VIRTUAL_ENV_ENABLED_DIR="$PWD"
        elif [[ -d ./.venv ]]; then
            source ./.venv/bin/activate
            export VIRTUAL_ENV_AUTO_LOADED=1
            export VIRTUAL_ENV_ENABLED_DIR="$PWD"
        fi
    fi
}

chpwd_functions=(${chpwd_functions[@]} check_and_load_venv)

check_and_load_venv
