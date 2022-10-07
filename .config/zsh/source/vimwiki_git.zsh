vimwiki () {
    if [[ $# == 0 ]]
    then
        nvim +'VimwikiUISelect'
    elif [[ $1 == 'cd' ]]
    then
        cd ~/work/vimwiki_notes
    else
        git -C ~/work/vimwiki_notes ${@:1}
    fi
}
