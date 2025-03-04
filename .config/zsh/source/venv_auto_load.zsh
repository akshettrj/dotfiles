function check_and_load_venv() {
  if [[ -z "$VIRTUAL_ENV" ]] ; then
    ## If venv folder is found then activate the vitualenv
      if [[ -d ./venv ]]; then
        source ./venv/bin/activate
      elif [[ -d ./.venv ]]; then
        source ./.venv/bin/activate
      fi
  else
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        deactivate
      fi
  fi
}

chpwd_functions=(${chpwd_functions[@]} check_and_load_venv)

check_and_load_venv
