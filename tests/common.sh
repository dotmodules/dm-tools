#==============================================================================
# COLORS
#==============================================================================

# Checking the availibility and usability of tput. If it is available and
# usable we can set the global coloring variables with it by expecting a
# possibly missing color/modifier.
if command -v tput >/dev/null && tput init >/dev/null 2>&1
then
  if ! RED="$(tput setaf 1)"
  then
    RED=''
  fi
  if ! GREEN="$(tput setaf 2)"
  then
    GREEN=''
  fi
  if ! BLUE="$(tput setaf 4)"
  then
    BLUE=''
  fi
  if ! RESET="$(tput sgr0)"
  then
    RESET=''
  fi
  if ! BOLD="$(tput bold)"
  then
    BOLD=''
  fi
  if ! DIM="$(tput dim)"
  then
    DIM=''
  fi
else
  RED=''
  GREEN=''
  BLUE=''
  RESET=''
  BOLD=''
  DIM=''
fi

#==============================================================================
# PRETTY PRINTING
#==============================================================================

dm_tools__test__log_task() {
  ___log_message="$1"
  echo "${BOLD}[ ${BLUE}>>${RESET}${BOLD} ]${RESET} ${___log_message}"
}

dm_tools__test__log_success() {
  ___log_message="$1"
  echo "${BOLD}[ ${GREEN}OK${RESET}${BOLD} ]${RESET} ${___log_message}"
}

dm_tools__test__log_failure() {
  ___log_message="$1"
  echo "${BOLD}[ ${RED}!!${RESET}${BOLD} ]${RESET} ${___log_message}"
}

dm_tools__test__valid_case() {
  ___title="$1"
  printf '%s' "[ ${BLUE}${DIM}VALID${RESET} ] ${BOLD}${___title}${RESET}"
}

dm_tools__test__error_case() {
  ___title="$1"
  printf '%s' "[ ${BLUE}${DIM}ERROR${RESET} ] ${BOLD}${___title}${RESET}"
}

_dm_tools__test__test_case_succeeded() {
  printf '%s\n' " - ${BOLD}${GREEN}ok${RESET}"
}

_dm_tools__test__test_case_failed() {
  printf '%s\n' " - ${BOLD}${RED}not ok${RESET}"
}

dm_tools__test__line() {
  printf '%s' "${DIM}"
  printf '%s' '-----------------------------------------------------------------'
  printf '%s' '-------------------'
  printf '%s\n' "${RESET}"
}

#==============================================================================
# ASSERTIONS
#==============================================================================

DM_TOOLS__TEST__SUPPRESS_RESULT_PRINTOUT='0'

#==============================================================================
# Assertion function that compares two values.
#------------------------------------------------------------------------------
# Globals:
#   DM_TOOLS__TEST__SUPPRESS_RESULT_PRINTOUT
#   BOLD
#   RED
# Options:
#   None
# Arguments:
#   [1] expected - Expected value.
#   [2] result - Resulted value.
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Assertion result.
# STDERR:
#   None
# Status:
#   0 - Assertion succeeded.
#   1 - Assertion failed.
#------------------------------------------------------------------------------
# Tools:
#   printf exit
#==============================================================================
dm_tools__test__assert_equal() {
  ___expected="$1"
  ___result="$2"

  if [ "$___result" = "$___expected" ]
  then
    if [ "$DM_TOOLS__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
    then
      _dm_tools__test__test_case_succeeded
    fi

  else
    if [ "$DM_TOOLS__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
    then
      _dm_tools__test__test_case_failed
    fi

    printf '%s' "${BOLD}${RED}[ FAILURE ]${RESET}${RED} - "
    printf '%s' "dm_tools__test__assert_equal - "
    printf '%s\n' "${BOLD}Assertion failed!${RESET}"

    printf '  %s' "${RED}expected: "
    printf '%s\n' "'${BOLD}${___expected}${RESET}${RED}'${RESET}"

    printf '  %s' "${RED}result:   "
    printf '%s\n' "'${BOLD}${___result}${RESET}${RED}'${RESET}"

    exit 1
  fi
}

#==============================================================================
#
#  dm_tools__test__assert_invalid_parameters <status> <error_message>
#
#------------------------------------------------------------------------------
# Assertion function that checks if the status is the expected invalid
# parameters status code. If it is, it prints out the captured error message
# provided by the tool. If the status code doesn't match, it prints out an
# error message, then terminates the testing process.
#------------------------------------------------------------------------------
# Globals:
#   DM_TOOLS__STATUS__INVALID_PARAMETERS
#   DM_TOOLS__TEST__SUPPRESS_RESULT_PRINTOUT
#   DIM
#   BOLD
#   RED
#   RESET
# Options:
#   None
# Arguments:
#   [1] status - Resulted status that should be tested.
#   [2] error_message - Captured error message the tool outputted.
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Captured error printout from the command in case of success, or error
#   message in case of failure.
# STDERR:
#   None
# Status:
#   0 - Assertion succeeded.
#   1 - Assertion failed.
#------------------------------------------------------------------------------
# Tools:
#   printf exit
#==============================================================================
dm_tools__test__assert_invalid_parameters() {
  ___status="$1"
  ___error_message="$2"

  ___expected="$DM_TOOLS__STATUS__INVALID_PARAMETERS"

  if [ "$___status" -eq "$___expected" ]
  then
    if [ "$DM_TOOLS__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
    then
      _dm_tools__test__test_case_succeeded
    fi
    printf '%s\n' "${DIM}${___error_message}${RESET}"

  else
    if [ "$DM_TOOLS__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
    then
      _dm_tools__test__test_case_failed
    fi

    printf '%s' "${BOLD}${RED}[ FAILURE ]${RESET}${RED} - "
    printf '%s' "dm_tools__test__assert_invalid_parameters - "
    printf '%s' "${RED}${BOLD}The tested tool should have reported an invalid "
    printf '%s\n' "parameters error.${RESET}"

    printf '  %s' "${RED}expected exit status: "
    printf '%s\n' "${BOLD}${___expected}${RESET}"

    printf '  %s' "${RED}resulted exit status: "
    printf '%s\n' "${BOLD}${___status}${RESET}"

    exit 1
  fi
}

#==============================================================================
#
# dm_tools__test__test_case_failed <status>
#
#------------------------------------------------------------------------------
# Assertion function that should be called when a tested command returns an
# unexpected status code. This function will print out an error message then
# terminates the execution.
#------------------------------------------------------------------------------
# Globals:
#   DM_TOOLS__TEST__SUPPRESS_RESULT_PRINTOUT
#   BOLD
#   RED
#   RESET
# Options:
#   None
# Arguments:
#   [1] status - Status of the failed tool call.
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   Error message.
# STDERR:
#   None
# Status:
#   1 - Test case failed.
#------------------------------------------------------------------------------
# Tools:
#   printf exit
#==============================================================================
dm_tools__test__test_case_failed() {
  ___status="$1"

  if [ "$DM_TOOLS__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
  then
    _dm_tools__test__test_case_failed
  fi

  printf '%s' "${BOLD}${RED}[ FAILURE ]${RESET}${RED} - "
  printf '%s' 'dm_tools__test__test_case_failed - '
  printf '%s\n' "${BOLD}Unexpected status!${RESET}"

  printf '%s' "  ${RED}Failed with unexpected non zero status ${BOLD}"
  printf '%s' "${___status}${RESET}${RED}, possibly due to an unsupported "
  printf '%s\n' "call style.${RESET}"

  exit 1
}

#==============================================================================
#
# dm_tools__test__test_case_passed
#
#------------------------------------------------------------------------------
# Marks the test case as passed.
#------------------------------------------------------------------------------
# Globals:
#   DM_TOOLS__TEST__SUPPRESS_RESULT_PRINTOUT
# Options:
#   None
# Arguments:
#   None
# STDIN:
#   None
#------------------------------------------------------------------------------
# Output variables:
#   None
# STDOUT:
#   None
# STDERR:
#   None
# Status:
#   1 - Test case failed.
#------------------------------------------------------------------------------
# Tools:
#   printf exit
#==============================================================================
dm_tools__test__test_case_passed() {
  if [ "$DM_TOOLS__TEST__SUPPRESS_RESULT_PRINTOUT" -eq '0' ]
  then
    _dm_tools__test__test_case_succeeded
  fi
}
