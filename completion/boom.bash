_boom_complete() {
    local cur prev lists
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    lists=`boom | awk '{print $1}'`

    case "${prev}" in
      boom)
        COMPREPLY=( $(compgen -W "${lists}" -- ${cur}) )
        return 0
        ;;
      *)
        for ((i = 0; i < ${#lists}; i++)); do
          local items=`boom $prev | awk '{print $1}' | sed -e 's/://'`
          COMPREPLY=( $(compgen -W "${items}" -- ${cur}))
          return 0
        done
        ;;
    esac
}
complete -F _boom_complete boom
