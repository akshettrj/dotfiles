vimwiki () {
    if [[ $# == 0 ]]
    then
        nvim +'VimwikiUISelect'
    elif [[ $1 == 'git' ]]
    then
        git -C ~/work/vimwiki_notes ${@:2}
    else
        echo 'Usage: vimwiki [git] [args ...]'
    fi
}
