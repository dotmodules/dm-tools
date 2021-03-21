#==============================================================================
title='printf :: minimum width specifier'

expected=' 42'

if result="$(dm_tools__printf '%*s' 3 '42')"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='printf :: precision specifier'

expected='123'

if result="$(dm_tools__printf '%.*s' 3 '123456')"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi

#==============================================================================
title='printf :: combined minimum width and precision specifier'

expected=' 123'

if result="$(dm_tools__printf '%*.*s' 4 3 '123456')"
then
  dm_tools__assert "$title" "$expected" "$result"
else
  status="$?"
  dm_tools__failure "$title" "$status"
fi