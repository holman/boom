_boom_complete() {
    local cur prev lists curr_list items
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    curr_list=`eval echo "$prev"`
    local IFS=$'\n'

    if [ $COMP_CWORD -eq 1 ]; then
        lists=`boom | sed 's/^  \(.*\) ([0-9]\{1,\})$/\1/'`
        COMPREPLY=( $( compgen -W '${lists}' -- ${cur} ) )
    elif [ $COMP_CWORD -eq 2 ]; then
        items=`boom $curr_list | sed 's/^    \(.\{0,16\}\):.*$/\1/'`
        COMPREPLY=( $( compgen -W '${items}' -- ${cur} ) )
    fi
}
complete -o filenames -F _boom_complete boom
