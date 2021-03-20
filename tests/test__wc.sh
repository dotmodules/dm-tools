#==============================================================================
title='wc :: lines'

expected='3'

if result="$( \
  ( \
    dm_tools__echo 'a'; \
    dm_tools__echo 'b'; \
    dm_tools__echo 'c' \
  ) | dm_tools__wc --lines \
)"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi

#==============================================================================
title='wc :: chars'

expected='12' # 11 character + 1 newline

if result="$( dm_tools__echo 'this is ok!' | dm_tools__wc --chars)"
then
  tool_assert "$title" "$expected" "$result"
else
  status="$?"
  tool_failure "$title" "$status"
fi
