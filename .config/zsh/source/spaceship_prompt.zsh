SPACESHIP_PROMPT_ORDER=(
    user
    host
    dir
    git
    venv
    conda
    exec_time
    jobs
    exit_code
    char
)

SPACESHIP_CHAR_PREFIX=""
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_CHAR_SYMBOL=""

SPACESHIP_DIR_PREFIX="in "
SPACESHIP_DIR_SUFFIX=" "

SPACESHIP_TIME_SHOW=true
SPACESHIP_EXEC_TIME_SHOW=true

autoload -U promptinit && promptinit
prompt spaceship
