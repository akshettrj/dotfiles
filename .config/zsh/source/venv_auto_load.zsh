function cd() {
  builtin cd "$@"
  check_and_load_venv
}

function check_and_load_venv() {
  if [[ -z "$VIRTUAL_ENV" ]] ; then
    ## If venv folder is found then activate the vitualenv
      if [[ -d ./venv ]] ; then
        source ./venv/bin/activate
      fi
  else
    ## check the current folder belong to earlier VIRTUAL_ENV folder
    # if yes then do nothing
    # else deactivate
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        deactivate
      fi
  fi
}

check_and_load_venv
