_kube_contexts()
{
  local cur;
  # Context names often contain colons (e.g. AWS EKS ARNs). bash treats ':' as a
  # word-break character, so ${COMP_WORDS[COMP_CWORD]} holds only the fragment
  # after the last colon, which never matches a full context name and yields an
  # empty completion (#411). When bash-completion is available, rejoin the word
  # across colons and trim the already-typed prefix afterwards.
  if declare -F _get_comp_words_by_ref >/dev/null 2>&1; then
    _get_comp_words_by_ref -n : cur
  else
    cur=${COMP_WORDS[COMP_CWORD]}
  fi
  COMPREPLY=( $(compgen -W "- $(kubectl config get-contexts --output='name')" -- "$cur" ) );
  if declare -F __ltrim_colon_completions >/dev/null 2>&1; then
    __ltrim_colon_completions "$cur"
  fi
}

complete -F _kube_contexts kubectx kctx
