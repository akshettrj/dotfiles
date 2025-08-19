function check_and_load_venv() {
  if [[ -z "$VIRTUAL_ENV" ]] ; then
    ## If venv folder is found then activate the vitualenv
      if [[ -d ./venv ]]; then
        source ./venv/bin/activate
        export VIRTUAL_ENV_AUTO_LOADED=1
      elif [[ -d ./.venv ]]; then
        source ./.venv/bin/activate
        export VIRTUAL_ENV_AUTO_LOADED=1
      fi
  elif [[ "$VIRTUAL_ENV_AUTO_LOADED" == 1 ]]; then
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        deactivate
        export VIRTUAL_ENV_AUTO_LOADED=""
      fi
  fi
}

chpwd_functions=(${chpwd_functions[@]} check_and_load_venv)

check_and_load_venv
