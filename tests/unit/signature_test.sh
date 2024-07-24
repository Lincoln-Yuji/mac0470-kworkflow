#!/usr/bin/env bash

include './src/signature.sh'
include './tests/unit/utils.sh'

# The variables below are holding the correct trailers
# with the outputs of the following command:
# git log --max-count <N> --format="%(trailers)"
#
# Where N is the number of commits to be printed.
# The above command's behavior is to print only the
# trailers. Also trailers from different commits are
# divided by an empty line.
#
# It's also important to mention that most variables holding
# trailer lines contain one additional trailer of a past commit
# that should not be affected by the operations, helping to
# indicate that we are not affecting older commits accidentaly.

# Correct trailers for --add-signed-off-by and -s
#
# This variable holds the trailers lines of the last 2 commits.
# The last one was reviewed as the first one was not.
CORRECT_SIGNED_HEAD='Signed-off-by: kw <kw@kwkw.xyz>
Signed-off-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

# This variable holds the trailer lines of the last 4 commits.
# The last 3 were reviewed while the first one was not.
CORRECT_SIGNED_LOG='Signed-off-by: kw <kw@kwkw.xyz>
Signed-off-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Signed-off-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Signed-off-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

# Correct trailers for --add-reviewed-by and -r
CORRECT_REVIEWED_HEAD='Signed-off-by: kw <kw@kwkw.xyz>
Reviewed-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

CORRECT_REVIEWED_LOG='Signed-off-by: kw <kw@kwkw.xyz>
Reviewed-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Reviewed-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Reviewed-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

# Often a maintainer will write both 'Reviewed-by' and
# 'Signed-off-by' trailer lines when they apply the changes
# presented in a patchset or pull/merge request. The two following
# variables are used to test this usual operation.
CORRECT_FULL_REVIEW_HEAD='Signed-off-by: kw <kw@kwkw.xyz>
Reviewed-by: Jane Doe <janedoe@mail.xyz>
Signed-off-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

CORRECT_FULL_REVIEW_LOG='Signed-off-by: kw <kw@kwkw.xyz>
Reviewed-by: Jane Doe <janedoe@mail.xyz>
Signed-off-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Reviewed-by: Jane Doe <janedoe@mail.xyz>
Signed-off-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Reviewed-by: Jane Doe <janedoe@mail.xyz>
Signed-off-by: Jane Doe <janedoe@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

# Correct trailers for --add-acked-by and -a
CORRECT_ACKED_HEAD='Signed-off-by: kw <kw@kwkw.xyz>
Acked-by: Michael Doe <michaeldoe@kwkw.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

CORRECT_ACKED_LOG='Signed-off-by: kw <kw@kwkw.xyz>
Acked-by: Michael Doe <michaeldoe@kwkw.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Acked-by: Michael Doe <michaeldoe@kwkw.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Acked-by: Michael Doe <michaeldoe@kwkw.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

# Correct trailers for --add-fixes and -f
#
# Writting the correct hash is needed. This has
# to be done during test runs, since hashes
# are randomly generated.
CORRECT_FIXES_HEAD='Signed-off-by: kw <kw@kwkw.xyz>
Fixes: <hash>

Signed-off-by: kw <kw@kwkw.xyz>'

# Correct trailers for --add-tested-by and -t
CORRECT_TESTED_HEAD='Signed-off-by: kw <kw@kwkw.xyz>
Tested-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

CORRECT_TESTED_LOG='Signed-off-by: kw <kw@kwkw.xyz>
Tested-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Tested-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Tested-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

# Correct trailers for --add-co-developed-by and -C
CORRECT_CO_DEVELOPED_HEAD='Signed-off-by: kw <kw@kwkw.xyz>
Co-developed-by: Bob Brown <bob.brown@mail.xyz>
Signed-off-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

CORRECT_CO_DEVELOPED_LOG='Signed-off-by: kw <kw@kwkw.xyz>
Co-developed-by: Bob Brown <bob.brown@mail.xyz>
Signed-off-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Co-developed-by: Bob Brown <bob.brown@mail.xyz>
Signed-off-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Co-developed-by: Bob Brown <bob.brown@mail.xyz>
Signed-off-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

# Correct trailers for --add-reported-by and -R
CORRECT_REPORTED_HEAD='Signed-off-by: kw <kw@kwkw.xyz>
Reported-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

CORRECT_REPORTED_LOG='Signed-off-by: kw <kw@kwkw.xyz>
Reported-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Reported-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Reported-by: Bob Brown <bob.brown@mail.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

# Correct trailers when using once each:
# --add-acked-by    or -a
# --add-reviewed-by or -r
# --add-fixes       or -f
#
# This also requires a hash while running tests, assuming
# only the last commit fixes another one.
CORRECT_MULTI_CALL_LOG='Signed-off-by: kw <kw@kwkw.xyz>
Acked-by: Michael Doe <michaeldoe@kwkw.xyz>
Reviewed-by: John Doe <johndoe@kwkw.xyz>
Fixes: <hash>

Signed-off-by: kw <kw@kwkw.xyz>
Acked-by: Michael Doe <michaeldoe@kwkw.xyz>
Reviewed-by: John Doe <johndoe@kwkw.xyz>

Signed-off-by: kw <kw@kwkw.xyz>
Acked-by: Michael Doe <michaeldoe@kwkw.xyz>
Reviewed-by: John Doe <johndoe@kwkw.xyz>

Signed-off-by: kw <kw@kwkw.xyz>'

# Hold the original directory to go back in every tear down
ORIGINAL_DIR="$PWD"

function setUp()
{
  cp --force 'tests/unit/samples/signature_patch_samples/patch_model.patch' "${SHUNIT_TMPDIR}/"
  cp --force 'tests/unit/samples/signature_patch_samples/patch_model_signed_off.patch' "${SHUNIT_TMPDIR}/"
  cp --force 'tests/unit/samples/signature_patch_samples/patch_model_full_review.patch' "${SHUNIT_TMPDIR}/"
  cp --force 'tests/unit/samples/signature_patch_samples/patch_model_reviewed.patch' "${SHUNIT_TMPDIR}/"
  cp --force 'tests/unit/samples/signature_patch_samples/patch_model_acked.patch' "${SHUNIT_TMPDIR}/"
  cp --force 'tests/unit/samples/signature_patch_samples/patch_model_fixes.patch' "${SHUNIT_TMPDIR}/"
  cp --force 'tests/unit/samples/signature_patch_samples/patch_model_tested.patch' "${SHUNIT_TMPDIR}/"
  cp --force 'tests/unit/samples/signature_patch_samples/patch_model_co_developed.patch' "${SHUNIT_TMPDIR}/"
  cp --force 'tests/unit/samples/signature_patch_samples/patch_model_reported.patch' "${SHUNIT_TMPDIR}/"
  cp --force 'tests/unit/samples/signature_patch_samples/patch_model_complete.patch' "${SHUNIT_TMPDIR}/"

  cd "$SHUNIT_TMPDIR" || {
    fail "(${LINENO}) It was not possible to move to temporary directory"
    return
  }

  # Setup git repository for test
  mk_fake_git

  # Start repository
  git config user.name kw
  git config user.email kw@kwkw.xyz
  mkdir fs
  touch fs/some_file
  git add patch_model.patch patch_model_reviewed.patch patch_model_acked.patch \
    patch_model_fixes.patch patch_model_tested.patch patch_model_co_developed.patch \
    patch_model_reported.patch patch_model_complete.patch
  git add fs/
  git commit --quiet --signoff --message 'Create files'

  # Simulate wrong change
  printf 'Wrong text' > fs/some_file
  git add fs/some_file
  git commit --quiet --signoff \
    --message 'fs: some_file: Fill file' \
    --message 'First'

  # Regular change
  touch fs/new_driver
  git add fs/new_driver
  git commit --quiet --signoff \
    --message 'fs: new_driver: Add new driver' \
    --message 'Second'

  # Bug fix
  printf 'Correct text' > fs/some_file
  git add fs/some_file
  git commit --quiet --signoff \
    --message 'fs: some_file: Fix bug' \
    --message 'Third'
}

function tearDown()
{
  cd "$ORIGINAL_DIR" || {
    fail "(${LINENO}) It was not possible to go back to original directory"
    return
  }
  if is_safe_path_to_remove "$SHUNIT_TMPDIR"; then
    rm --recursive --force "$SHUNIT_TMPDIR"
    mkdir --parents "$SHUNIT_TMPDIR"
  else
    fail "(${LINENO}) It was not possible to safely remove temporary directory"
    return
  fi
}

function test_signature_patch_signed_off_by()
{
  local output_msg
  local return_status

  # Long option
  signature_main --add-signed-off-by='Jane Doe <janedoe@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_signed_off.patch'
  git restore patch_model.patch

  # Short option
  signature_main -s'Jane Doe <janedoe@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_signed_off.patch'
  git restore patch_model.patch

  # Test repetition avoidance by checking the result and warning message
  output_msg="$(signature_main -s'Jane Doe <janedoe@mail.xyz>' -s'Jane Doe <janedoe@mail.xyz>' patch_model.patch)"
  assertFileEquals 'patch_model.patch' 'patch_model_signed_off.patch'
  assertEquals "(${LINENO})" "Skipping repeated trailer line: 'Signed-off-by: Jane Doe <janedoe@mail.xyz>'" "$output_msg"
  git restore patch_model.patch

  # Testing default behavior with git config
  git config user.name 'Jane Doe'
  git config user.email 'janedoe@mail.xyz'

  signature_main -s patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_signed_off.patch'
  git restore patch_model.patch

  # Simulating non-configured user.name and user.email by setting local empty values.
  # This has to be tested this way because we CAN NOT unset git config using:
  # 'git config --global --unset ( user.name | user.email )'
  # Since this would affect user's global git configuration outside tests.
  git config user.name ''
  git config user.email ''

  output_msg="$(signature_main --add-signed-off-by)"
  return_status="$?"
  assertEquals "(${LINENO})" 22 "$return_status"
  assertEquals "(${LINENO})" \
    "You must configure your user.name and user.email with git to use --add-signed-off-by or -s without an argument" \
    "$output_msg"
}

function test_signature_patch_reviewed_by()
{
  local output_msg

  # Long option
  signature_main --add-reviewed-by='Jane Doe <janedoe@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_reviewed.patch'
  git restore patch_model.patch

  # Short option
  signature_main -r'Jane Doe <janedoe@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_reviewed.patch'
  git restore patch_model.patch

  # Test repetition avoidance by checking the result and warning message
  output_msg="$(signature_main -r'Jane Doe <janedoe@mail.xyz>' -r'Jane Doe <janedoe@mail.xyz>' patch_model.patch)"
  assertFileEquals 'patch_model.patch' 'patch_model_reviewed.patch'
  assertEquals "(${LINENO})" "Skipping repeated trailer line: 'Reviewed-by: Jane Doe <janedoe@mail.xyz>'" "$output_msg"
  git restore patch_model.patch
}

function test_signature_patch_full_review()
{
  local output_msg

  # Long option
  signature_main --add-reviewed-by='Jane Doe <janedoe@mail.xyz>' patch_model.patch
  signature_main --add-signed-off-by='Jane Doe <janedoe@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_full_review.patch'
  git restore patch_model.patch

  # Short option
  signature_main -r'Jane Doe <janedoe@mail.xyz>' patch_model.patch
  signature_main -s'Jane Doe <janedoe@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_full_review.patch'
  git restore patch_model.patch

  # Setting different local git config to test default behavior
  git config --local user.name 'Jane Doe'
  git config --local user.email 'janedoe@mail.xyz'

  # Simulating how usually a maintainer will sign a review before applying the changes
  signature_main -r -s patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_full_review.patch'
  git restore patch_model.patch

  # Test repetition avoidance by checking the result and warning message
  output_msg="$(signature_main -r -s -r patch_model.patch)"
  assertFileEquals 'patch_model.patch' 'patch_model_full_review.patch'
  assertEquals "(${LINENO})" "Skipping repeated trailer line: 'Reviewed-by: Jane Doe <janedoe@mail.xyz>'" "$output_msg"
  git restore patch_model.patch

  output_msg="$(signature_main -r -s -s patch_model.patch)"
  assertFileEquals 'patch_model.patch' 'patch_model_full_review.patch'
  assertEquals "(${LINENO})" "Skipping repeated trailer line: 'Signed-off-by: Jane Doe <janedoe@mail.xyz>'" "$output_msg"
  git restore patch_model.patch
}

function test_signature_patch_acked_by()
{
  local output_msg

  # Long option
  signature_main --add-acked-by='Michael Doe <michaeldoe@kwkw.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_acked.patch'
  git restore patch_model.patch

  # Short option
  signature_main -a'Michael Doe <michaeldoe@kwkw.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_acked.patch'
  git restore patch_model.patch

  # Test repetition avoidance by checking the result and warning message
  output_msg="$(signature_main -a'Michael Doe <michaeldoe@kwkw.xyz>' -a'Michael Doe <michaeldoe@kwkw.xyz>' patch_model.patch)"
  assertFileEquals 'patch_model.patch' 'patch_model_acked.patch'
  assertEquals "(${LINENO})" "Skipping repeated trailer line: 'Acked-by: Michael Doe <michaeldoe@kwkw.xyz>'" "$output_msg"
  git restore patch_model.patch
}

function test_signature_patch_fixes()
{
  local head2_msg

  # Store the correct message's format
  head2_msg="$(git rev-parse --short=12 HEAD~2) (\"fs: some_file: Fill file\")"

  # Long option
  signature_main --add-fixes='HEAD~2' patch_model.patch

  # Write trailer value with correct hash
  sed --in-place "s/<hash>/${head2_msg}/g" patch_model_fixes.patch

  assertFileEquals 'patch_model.patch' 'patch_model_fixes.patch'
  git restore patch_model.patch patch_model_fixes.patch

  # Short option
  signature_main -f'HEAD~2' patch_model.patch

  # Write trailer value with correct hash
  sed --in-place "s/<hash>/${head2_msg}/g" patch_model_fixes.patch

  assertFileEquals 'patch_model.patch' 'patch_model_fixes.patch'
  git restore patch_model.patch patch_model_fixes.patch
}

function test_signature_patch_tested_by()
{
  local output_msg

  # Long option
  signature_main --add-tested-by='Bob Brown <bob.brown@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_tested.patch'
  git restore patch_model.patch

  # Short option
  signature_main -t'Bob Brown <bob.brown@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_tested.patch'
  git restore patch_model.patch

  # Test repetition avoidance by checking the result and warning message
  output_msg="$(signature_main -t'Bob Brown <bob.brown@mail.xyz>' -t'Bob Brown <bob.brown@mail.xyz>' patch_model.patch)"
  assertFileEquals 'patch_model.patch' 'patch_model_tested.patch'
  assertEquals "(${LINENO})" "Skipping repeated trailer line: 'Tested-by: Bob Brown <bob.brown@mail.xyz>'" "$output_msg"
  git restore patch_model.patch
}

function test_signature_patch_co_developed_by()
{
  local output_msg

  # Long option
  signature_main --add-co-developed-by='Bob Brown <bob.brown@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_co_developed.patch'
  git restore patch_model.patch

  # Short option
  signature_main -C'Bob Brown <bob.brown@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_co_developed.patch'
  git restore patch_model.patch

  # Test repetition avoidance by checking the result and warning message
  output_msg="$(signature_main -C'Bob Brown <bob.brown@mail.xyz>' -s'Bob Brown <bob.brown@mail.xyz>' patch_model.patch)"
  assertFileEquals 'patch_model.patch' 'patch_model_co_developed.patch'
  assertEquals "(${LINENO})" "Skipping repeated trailer line: 'Signed-off-by: Bob Brown <bob.brown@mail.xyz>'" "$output_msg"
  git restore patch_model.patch
}

function test_signature_patch_reported_by()
{
  local output_msg

  # Long option
  signature_main --add-reported-by='Bob Brown <bob.brown@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_reported.patch'
  git restore patch_model.patch

  # Short option
  signature_main -R'Bob Brown <bob.brown@mail.xyz>' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_reported.patch'
  git restore patch_model.patch

  # Test repetition avoidance by checking the result and warning message
  output_msg="$(signature_main -R'Bob Brown <bob.brown@mail.xyz>' -R'Bob Brown <bob.brown@mail.xyz>' patch_model.patch)"
  assertFileEquals 'patch_model.patch' 'patch_model_reported.patch'
  assertEquals "(${LINENO})" "Skipping repeated trailer line: 'Reported-by: Bob Brown <bob.brown@mail.xyz>'" "$output_msg"
  git restore patch_model.patch
}

function test_signature_patch_multi_call()
{
  local output_msg
  local head2_msg

  # Store the correct message's format
  head2_msg="$(git rev-parse --short=12 HEAD~2) (\"fs: some_file: Fill file\")"

  # Write trailer line with correct hash
  sed --in-place "s/<hash>/${head2_msg}/g" patch_model_complete.patch

  # Use each option once
  signature_main --add-reviewed-by='John Doe <johndoe@kwkw.xyz>' patch_model.patch
  signature_main --add-acked-by='Michael Doe <michaeldoe@kwkw.xyz>' patch_model.patch
  signature_main --add-fixes='HEAD~2' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_complete.patch'
  git restore patch_model.patch

  # Use each option once in the same command
  signature_main -r'John Doe <johndoe@kwkw.xyz>' -a'Michael Doe <michaeldoe@kwkw.xyz>' -f'HEAD~2' patch_model.patch
  assertFileEquals 'patch_model.patch' 'patch_model_complete.patch'
  git restore patch_model.patch

  git config --local user.name 'John Doe'
  git config --local user.email 'johndoe@kwkw.xyz'

  # Test repetition avoidance by checking the result and warning message
  output_msg="$(signature_main -r -a'Michael Doe <michaeldoe@kwkw.xyz>' -r -f'HEAD~2' patch_model.patch)"
  assertFileEquals 'patch_model.patch' 'patch_model_complete.patch'
  assertEquals "(${LINENO})" "Skipping repeated trailer line: 'Reviewed-by: John Doe <johndoe@kwkw.xyz>'" "$output_msg"
  git restore patch_model.patch

  output_msg="$(signature_main -r -a'Michael Doe <michaeldoe@kwkw.xyz>' -a'Michael Doe <michaeldoe@kwkw.xyz>' -f'HEAD~2' patch_model.patch)"
  assertFileEquals 'patch_model.patch' 'patch_model_complete.patch'
  assertEquals "(${LINENO})" "Skipping repeated trailer line: 'Acked-by: Michael Doe <michaeldoe@kwkw.xyz>'" "$output_msg"
  git restore patch_model.patch
}

function test_signature_commit_signed_off_by()
{
  local original_commit
  local current_log

  # Save SHA from current commit allowing tests to reset the repository
  original_commit="$(git rev-parse HEAD)"

  # Long option while modifying only the last commit
  signature_main --add-signed-off-by='Jane Doe <janedoe@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_SIGNED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Short option while modifying only the last commit
  signature_main -s'Jane Doe <janedoe@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_SIGNED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Modifying the last 3 commits
  signature_main -s'Jane Doe <janedoe@mail.xyz>' 'HEAD~3'
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_SIGNED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Setting up a different local config to test default behavior
  git config --local user.name 'Jane Doe'
  git config --local user.email 'janedoe@mail.xyz'

  # Modifying the last 3 commits with default behavior
  signature_main -s HEAD~3
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_SIGNED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"
}

function test_signature_commit_reviewed_by()
{
  local original_commit
  local current_log

  # Save SHA from current commit allowing tests to reset the repository
  original_commit="$(git rev-parse HEAD)"

  # Long option while modifying only the last commit
  signature_main --add-reviewed-by='Jane Doe <janedoe@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_REVIEWED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Short option while modifying only the last commit
  signature_main -r'Jane Doe <janedoe@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_REVIEWED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Modifying the last 3 commits
  signature_main -r'Jane Doe <janedoe@mail.xyz>' 'HEAD~3'
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_REVIEWED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Setting up a different local config to test default behavior
  git config --local user.name 'Jane Doe'
  git config --local user.email 'janedoe@mail.xyz'

  # Modifying the last 3 commits with default behavior
  signature_main -r HEAD~3
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_REVIEWED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"
}

function test_signature_commit_full_review()
{
  local original_commit
  local current_log

  # Save SHA from current commit allowing tests to reset the repository
  original_commit="$(git rev-parse HEAD)"

  # Long options
  signature_main --add-reviewed-by='Jane Doe <janedoe@mail.xyz>'
  signature_main --add-signed-off-by='Jane Doe <janedoe@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_FULL_REVIEW_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Short options
  signature_main -r'Jane Doe <janedoe@mail.xyz>'
  signature_main -s'Jane Doe <janedoe@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_FULL_REVIEW_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Modifying the last 3 commits
  signature_main -r'Jane Doe <janedoe@mail.xyz>' HEAD~3
  signature_main -s'Jane Doe <janedoe@mail.xyz>' HEAD~3
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_FULL_REVIEW_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Setting up a different local config to test default behavior
  git config --local user.name 'Jane Doe'
  git config --local user.email 'janedoe@mail.xyz'

  # Modifying the last 3 commits with default behavior
  signature_main -r -s HEAD~3
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_FULL_REVIEW_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"
}

function test_signature_commit_acked_by()
{
  local original_commit
  local current_log

  # Save SHA from current commit allowing tests to reset the repository
  original_commit="$(git rev-parse HEAD)"

  # Long option while modifying only the last commit
  signature_main --add-acked-by='Michael Doe <michaeldoe@kwkw.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_ACKED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Short option while modifying only the last commit
  signature_main -a'Michael Doe <michaeldoe@kwkw.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_ACKED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Modifying the last 3 commits
  signature_main -a'Michael Doe <michaeldoe@kwkw.xyz>' 'HEAD~3'
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_ACKED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Setting up a different local config to test default behavior
  git config --local user.name 'Michael Doe'
  git config --local user.email 'michaeldoe@kwkw.xyz'

  # Modifying the last 3 commits with default behavior
  signature_main -a HEAD~3
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_ACKED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"
}

function test_signature_commit_fixes()
{
  local original_commit
  local current_log
  local correct_fixed_value
  local correct_output

  # Save SHA from current commit allowing tests to reset the repository
  original_commit="$(git rev-parse HEAD)"

  # Long option
  signature_main --add-fixes=HEAD~2

  # Get the current modified log
  current_log="$(git log --max-count 2 --format="%(trailers)")"

  # Get the fixed commit using the correct format and update the correct output
  correct_fixed_value="$(git rev-parse --short=12 HEAD~2) (\"fs: some_file: Fill file\")"
  correct_output="${CORRECT_FIXES_HEAD//<hash>/$correct_fixed_value}"

  assertEquals "(${LINENO})" "$correct_output" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Short option
  signature_main -fHEAD~2

  # Get the current modified log
  current_log="$(git log --max-count 2 --format="%(trailers)")"

  # Get the fixed commit using the correct format and update the correct output
  correct_fixed_value="$(git rev-parse --short=12 HEAD~2) (\"fs: some_file: Fill file\")"
  correct_output="${CORRECT_FIXES_HEAD//<hash>/$correct_fixed_value}"

  assertEquals "(${LINENO})" "$correct_output" "$current_log"
  git reset --quiet --hard "$original_commit"
}

function test_signature_commit_tested_by()
{
  local original_commit
  local current_log

  # Save SHA from current commit allowing tests to reset the repository
  original_commit="$(git rev-parse HEAD)"

  # Long option while modifying only the last commit
  signature_main --add-tested-by='Bob Brown <bob.brown@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_TESTED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Short option while modifying only the last commit
  signature_main -t'Bob Brown <bob.brown@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_TESTED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Modifying the last 3 commits
  signature_main -t'Bob Brown <bob.brown@mail.xyz>' 'HEAD~3'
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_TESTED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Setting up a different local config to test default behavior
  git config --local user.name 'Bob Brown'
  git config --local user.email 'bob.brown@mail.xyz'

  # Modifying the last 3 commits with default behavior
  signature_main -t HEAD~3
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_TESTED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"
}

function test_signature_commit_co_developed_by()
{
  local original_commit
  local current_log

  # Save SHA from current commit allowing tests to reset the repository
  original_commit="$(git rev-parse HEAD)"

  # Long option while modifying only the last commit
  signature_main --add-co-developed-by='Bob Brown <bob.brown@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_CO_DEVELOPED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Short option while modifying only the last commit
  signature_main -C'Bob Brown <bob.brown@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_CO_DEVELOPED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Modifying the last 3 commits
  signature_main -C'Bob Brown <bob.brown@mail.xyz>' 'HEAD~3'
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_CO_DEVELOPED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Setting up a different local config to test default behavior
  git config --local user.name 'Bob Brown'
  git config --local user.email 'bob.brown@mail.xyz'

  # Modifying the last 3 commits with default behavior
  signature_main -C HEAD~3
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_CO_DEVELOPED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"
}

function test_signature_commit_reported_by()
{
  local original_commit
  local current_log

  # Save SHA from current commit allowing tests to reset the repository
  original_commit="$(git rev-parse HEAD)"

  # Long option while modifying only the last commit
  signature_main --add-reported-by='Bob Brown <bob.brown@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_REPORTED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Short option while modifying only the last commit
  signature_main -R'Bob Brown <bob.brown@mail.xyz>'
  current_log="$(git log --max-count 2 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_REPORTED_HEAD" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Modifying the last 3 commits
  signature_main -R'Bob Brown <bob.brown@mail.xyz>' 'HEAD~3'
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_REPORTED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Setting up a different local config to test default behavior
  git config --local user.name 'Bob Brown'
  git config --local user.email 'bob.brown@mail.xyz'

  # Modifying the last 3 commits with default behavior
  signature_main -R HEAD~3
  current_log="$(git log --max-count 4 --format="%(trailers)")"
  assertEquals "(${LINENO})" "$CORRECT_REPORTED_LOG" "$current_log"
  git reset --quiet --hard "$original_commit"
}

function test_signature_commit_multi_call()
{
  local original_commit
  local current_log
  local correct_fixed_value
  local correct_output

  # Save SHA from current commit allowing tests to reset the repository
  original_commit="$(git rev-parse HEAD)"

  # Using each option once
  signature_main --add-acked-by='Michael Doe <michaeldoe@kwkw.xyz>' 'HEAD~3'
  signature_main --add-reviewed-by='John Doe <johndoe@kwkw.xyz>' 'HEAD~3'
  signature_main --add-fixes='HEAD~2'

  # Get the current modified log trailers
  current_log="$(git log --max-count 4 --format="%(trailers)")"

  # Get the fixed commit using the correct format and update the correct output
  correct_fixed_value="$(git rev-parse --short=12 HEAD~2) (\"fs: some_file: Fill file\")"
  correct_output="${CORRECT_MULTI_CALL_LOG//<hash>/$correct_fixed_value}"

  assertEquals "(${LINENO})" "$correct_output" "$current_log"
  git reset --quiet --hard "$original_commit"

  # Using two options in the same command end then fixes
  signature_main -a'Michael Doe <michaeldoe@kwkw.xyz>' \
    -r'John Doe <johndoe@kwkw.xyz>' HEAD~3
  signature_main -f'HEAD~2'

  # Get the current modified log trailers
  current_log="$(git log --max-count 4 --format="%(trailers)")"

  # Get the fixed commit using the correct format and update the correct output
  correct_fixed_value="$(git rev-parse --short=12 HEAD~2) (\"fs: some_file: Fill file\")"
  correct_output="${CORRECT_MULTI_CALL_LOG//<hash>/$correct_fixed_value}"

  assertEquals "(${LINENO})" "$correct_output" "$current_log"
  git reset --quiet --hard "$original_commit"
}

invoke_shunit
