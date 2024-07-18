include "${KW_LIB_DIR}/lib/kw_config_loader.sh"
include "${KW_LIB_DIR}/lib/kwlib.sh"

declare -gA options_values

# Define trailer tags
declare -gA TRAILER_TAGS

TRAILER_TAGS['SIGNED_OFF_BY']='Signed-off-by:'
TRAILER_TAGS['REVIEWED_BY']='Reviewed-by:'
TRAILER_TAGS['ACKED_BY']='Acked-by:'
TRAILER_TAGS['TESTED_BY']='Tested-by:'
TRAILER_TAGS['REPORTED_BY']='Reported-by:'
TRAILER_TAGS['CO_DEVELOPED_BY']='Co-developed-by:'
TRAILER_TAGS['FIXES']='Fixes:'

# Defining an array to store the order trailers are written
declare -ga all_trailers

# Defining the format a legit email should follow
declare -gr email_regex='[A-Za-z0-9_\.-]+@[A-Za-z0-9_-]+(\.[A-Za-z0-9]+)+'

# This function performs operations over trailers in
# either patches or commits. It checks if given argument
# is a valid commit reference or patch path and uses the
# correct command to perform the task.
# If that's not the case, a warning message will tell
# the user this argument was ignored.
#
# Also, if no operation option is given, then an error message
# followed by a helper message is printed to the user.
#
# @patch_or_sha_args Holds either patch paths or commit references.
function signature_main()
{
  local patch_or_sha_args
  local flag

  if [[ "$1" =~ -h|--help ]]; then
    signature_help "$1"
    exit 0
  fi

  parse_signature_options "$@"
  if [[ "$?" -gt 0 ]]; then
    complain "${options_values['ERROR']}"
    return 22 # EINVAL
  fi

  [[ -n "${options_values['VERBOSE']}" ]] && flag='VERBOSE'
  flag=${flag:-'SILENT'}

  read -ra patch_or_sha_args <<< "${options_values['PATCH_OR_SHA']}"

  if [[ "${#all_trailers[@]}" -eq 0 ]]; then
    complain 'An option is required to use this command.'
    signature_help
    return 22 # EINVAL
  fi

  for arg in "${patch_or_sha_args[@]}"; do
    write_all_trailers "$arg" "$flag"
  done
}

# This function validates the signature. If the passed signature
# does not follow the format 'NAME <EMAIL>' with a valid EMAIL, then
# it returns an error.
#
# @signature Holds the string that is validated
#
# Return:
# Returns 0 if signature is valid; returns 22 otherwise.
function is_valid_signature()
{
  local signature="$1"
  local signature_regex='^[^<]+ <'"$email_regex"'>$'

  if ! [[ "$signature" =~ $signature_regex ]]; then
    return 22 # EINVAL
  fi
}

# This function parses and adds a new trailer line into
# @all_trailers that will be properly written later, however
# the trailer isn't added if there's another identical one.
# It attempts to use the user's name and email configured
# if a signature is not passed as argument and gives
# an error if they are not properly set with git config.
#
# @keyword Holds a string that is a keyword for a specific operation.
# @signature Holds a string like 'NAME <EMAIL>' defining the signature.
#
# Return:
# In case of successful return 0 adding the parsed operation;
# It returns 1 if either user.name or user.email are not configured properly;
# It returns 22 if the signature does not follow 'NAME <EMAIL>' format;
function parse_and_add_trailer()
{
  local keyword="$1"
  local signature="$2"
  local formated_output
  local trailer
  local repeated_trailer=false

  trailer="${TRAILER_TAGS[$keyword]} "

  # Use default from git config if no argument was given
  if [[ ! "$signature" ]]; then
    formated_output="$(format_name_email_from_user)"
    if [[ "$?" -gt 0 ]]; then
      return 1
    fi
    trailer+="$formated_output"
  else
    signature="$(str_strip "$signature")"
    if [[ "$keyword" != 'FIXES' ]] && ! is_valid_signature "$signature"; then
      return 22 # EINVAL
    fi
    trailer+="$signature"
  fi

  # Check for trailer repetition, do not add the trailer if it's repeated
  for item in "${all_trailers[@]}"; do
    if [[ "$item" == "$trailer" ]]; then
      repeated_trailer=true
      warning "Skipping repeated trailer line: '${trailer}'"
      break
    fi
  done

  if [[ "$repeated_trailer" = false ]]; then
    all_trailers+=("$trailer")
  fi
}

# This function receives a commit SHA and verifies if it's
# a valid commit reference. If it is, then it outputs the
# appropriate formatted message. Else it returns an error code.
#
# @sha Holds either a commit hash or pointer
#
# Return:
# In case of successful return 0 and prints the formatted message,
# otherwise, return 22.
function format_fixes_message()
{
  local sha="$1"
  local formatted_message

  # Check if given value is a valid commit reference
  if [[ $(git cat-file -t "$sha" 2> /dev/null) != 'commit' ]]; then
    return 22 # EINVAL
  fi

  # The 'Fixes:' trailer line must follow a format defined by Linux Kernel developers.
  # Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")
  formatted_message=$(git log -1 "$sha" --oneline --abbrev-commit --abbrev=12 \
    --format="%h (\\\"%s\\\")")

  printf '%s' "$formatted_message"
}

# It gets user.name and user.email from git's configuration.
# If either the name or email are not configured then this
# function will return an error code. Otherwise it will output
# the formatted name and email.
#
# Return:
# In case of successful return 0 and prints a properly formatted
# output, otherwise, return 1.
function format_name_email_from_user()
{
  local user_name
  local user_email

  user_name="$(git config user.name)"
  user_email="$(git config user.email)"

  # If user doesn't have either a name or email configured with
  # git then they must provide an argument
  if [[ -z "$user_name" || -z "$user_email" ]]; then
    return 1
  fi

  printf '%s' "${user_name} <${user_email}>"
}

# This function writes all the trailer lines stored in @all_trailers
# into either a patch file or commit. It prints a warning if the
# given argument is neither a valid patch path nor a commit reference
# and then ignores it.
#
# @patch_or_sha Holds either a patch path or commit SHA
# @flag Used to specify how 'cmd_manager' will be executed
function write_all_trailers()
{
  local patch_or_sha="$1"
  local flag="$2"
  local cmd

  for trailer in "${all_trailers[@]}"; do
    # Check if given argument is either a patch or valid commit reference,
    # then build the correct command.
    if [[ "$(git cat-file -t "$patch_or_sha" 2> /dev/null)" == 'commit' ]]; then
      cmd="git commit --quiet --amend --no-edit --trailer \"${trailer}\""
      # Only call 'git rebase' if user is trying to write multiple commits
      if [[ "$(git rev-parse "$patch_or_sha")" != "$(git rev-parse HEAD)" ]]; then
        cmd="git rebase ${patch_or_sha} --exec '${cmd}' 2> /dev/null"
      fi
    elif is_a_patch "$patch_or_sha"; then
      cmd="git interpret-trailers ${patch_or_sha} --in-place --trailer \"${trailer}\""
    else
      warning "Unmatched patch or commit. Ignoring: ${patch_or_sha}"
      continue
    fi

    cmd_manager "$flag" "$cmd"
  done
}

# This function gets raw data and based on that fill out the options values to
# be used in another function.
#
# Return:
# In case of successful return 0, otherwise, return 22.
function parse_signature_options()
{
  local long_options='add-signed-off-by::,add-reviewed-by::,add-acked-by::,add-fixes::'
  long_options+=',add-tested-by::,add-reported-by::,add-co-developed-by::,verbose'
  local short_options='s::,r::,a::,f::,t::,R::,C::'

  options="$(kw_parse "$short_options" "$long_options" "$@")"

  if [[ "$?" -gt 0 ]]; then
    options_values['ERROR']="$(kw_parse_get_errors 'kw signature' \
      "$short_options" "$long_options" "$@")"
    return 22 # EINVAL
  fi

  # Reset the operation buffer array
  all_trailers=()

  options_values['PATCH_OR_SHA']='HEAD'

  options_values['VERBOSE']=''

  eval "set -- ${options}"

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --add-signed-off-by | -s)
        parse_and_add_trailer 'SIGNED_OFF_BY' "$2"
        return_status="$?"

        if [[ "$return_status" -eq 1 ]]; then
          options_values['ERROR']='You must configure your user.name and user.email with git '
          options_values['ERROR']+='to use --add-signed-off-by or -s without an argument'
          return 22 # EINVAL
        elif [[ "$return_status" -eq 22 ]]; then
          options_values['ERROR']="Invalid signature format: ${2}; It should follow 'NAME <EMAIL>'"
          return 22 # EINVAL
        fi

        [[ ! "$2" ]] || shift
        shift
        ;;

      --add-reviewed-by | -r)
        parse_and_add_trailer 'REVIEWED_BY' "$2"
        return_status="$?"

        if [[ "$return_status" -eq 1 ]]; then
          options_values['ERROR']='You must configure your user.name and user.email with git '
          options_values['ERROR']+='to use --add-reviewed-by or -r without an argument'
          return 22 # EINVAL
        elif [[ "$return_status" -eq 22 ]]; then
          options_values['ERROR']="Invalid signature format: ${2}; It should follow 'NAME <EMAIL>'"
          return 22 # EINVAL
        fi

        [[ ! "$2" ]] || shift
        shift
        ;;

      --add-acked-by | -a)
        parse_and_add_trailer 'ACKED_BY' "$2"
        return_status="$?"

        if [[ "$return_status" -eq 1 ]]; then
          options_values['ERROR']='You must configure your user.name and user.email with git '
          options_values['ERROR']+='to use --add-acked-by or -a without an argument'
          return 22 # EINVAL
        elif [[ "$return_status" -eq 22 ]]; then
          options_values['ERROR']="Invalid signature format: ${2}; It should follow 'NAME <EMAIL>'"
          return 22 # EINVAL
        fi

        [[ ! "$2" ]] || shift
        shift
        ;;

      --add-tested-by | -t)
        parse_and_add_trailer 'TESTED_BY' "$2"
        return_status="$?"

        if [[ "$return_status" -eq 1 ]]; then
          options_values['ERROR']='You must configure your user.name and user.email with git '
          options_values['ERROR']+='to use --add-tested-by or -t without an argument'
          return 22 # EINVAL
        elif [[ "$return_status" -eq 22 ]]; then
          options_values['ERROR']="Invalid signature format: ${2}; It should follow 'NAME <EMAIL>'"
          return 22 # EINVAL
        fi

        [[ ! "$2" ]] || shift
        shift
        ;;

      --add-co-developed-by | -C)
        parse_and_add_trailer 'CO_DEVELOPED_BY' "$2"
        return_status="$?"

        if [[ "$return_status" -eq 1 ]]; then
          options_values['ERROR']='You must configure your user.name and user.email with git '
          options_values['ERROR']+='to use --add-co-developed-by or -C without an argument'
          return 22 # EINVAL
        elif [[ "$return_status" -eq 22 ]]; then
          options_values['ERROR']="Invalid signature format: ${2}; It should follow 'NAME <EMAIL>'"
          return 22 # EINVAL
        fi

        [[ ! "$2" ]] || shift
        shift
        ;;

      --add-reported-by | -R)
        parse_and_add_trailer 'REPORTED_BY' "$2"
        return_status="$?"

        if [[ "$return_status" -eq 1 ]]; then
          options_values['ERROR']='You must configure your user.name and user.email with git '
          options_values['ERROR']+='to use --add-reported-by or -R without an argument'
          return 22 # EINVAL
        elif [[ "$return_status" -eq 22 ]]; then
          options_values['ERROR']="Invalid signature format: ${2}; It should follow 'NAME <EMAIL>'"
          return 22 # EINVAL
        fi

        [[ ! "$2" ]] || shift
        shift
        ;;

      --add-fixes | -f)
        if [[ ! "$2" ]]; then
          options_values['ERROR']='The option --add-fixes or -f demands an argument'
          return 22 # EINVAL
        fi

        formatted_message="$(format_fixes_message "$(str_strip "$2")")"
        if [[ "$?" -gt 0 ]]; then
          options_values['ERROR']="Invalid commit reference with --add-fixes or -f: ${2}"
          return 22 # EINVAL
        fi

        parse_and_add_trailer 'FIXES' "$formatted_message"
        shift 2
        ;;

      --verbose)
        options_values['VERBOSE']=1
        shift
        ;;

      --)
        # End of options, beginning of arguments.
        # Overwrite default value if at least one argument is given.
        [[ -n "$2" ]] && options_values['PATCH_OR_SHA']=''
        shift
        ;;
      *)
        # Get all passed arguments each loop
        if [[ "$1" == *"*"* ]]; then
          # Expand the glob and loop through each resulting file
          for arg in $1; do
            options_values['PATCH_OR_SHA']+=" $arg"
          done
        else
          options_values['PATCH_OR_SHA']+=" $1"
        fi
        shift
        ;;
    esac
  done
}

function signature_help()
{
  if [[ "$1" == --help ]]; then
    include "${KW_LIB_DIR}/help.sh"
    kworkflow_man 'signature'
    return
  fi
  printf '%s\n' 'kw signature:' \
    '  signature (--add-signed-off-by | -s) (<name>) [<patchset> | <sha>] - Add Signed-off-by' \
    '  signature (--add-reviewed-by | -r) (<name>) [<patchset> | <sha>] - Add Reviewed-by' \
    '  signature (--add-acked-by | -a) (<name>) [<patchset> | <sha>] - Add Acked-by' \
    '  signature (--add-tested-by | -t) (<name>) [<patchset> | <sha>] - Add Tested-by' \
    '  signature (--add-co-developed-by | -C) (<name>) [<patchset> | <sha>] - Add Co-developed-by' \
    '  signature (--add-reported-by | -R) (<name>) [<patchset> | <sha>] - Add Reported-by' \
    '  signature (--add-fixes | -f) [<fixed-sha>] [<patchset> | <sha>] - Add Fixes' \
    '  signature (--verbose) - Show a detailed output'
}

load_kworkflow_config
