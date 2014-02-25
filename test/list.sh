#!/usr/bin/env roundup
export BOOMFILE=test/examples/data.json
boom="./bin/boom"

describe "lists"

it_shows_all_lists_by_default() {
  $boom | grep "urls"
  $boom | grep "jokes"
}

it_adds_a_list() {
  $boom enemies | grep "Created a new list"
  $boom | grep "enemies (0)"
}

it_adds_a_list_with_a_duplicate_name() {
  $boom urls github 'http://github.com/about'
  $boom github | grep '/about'
}

it_shows_a_list() {
  $boom urls | grep 'zachholman'
}

it_deletes_a_list() {
  $boom | grep "enemies"
  yes | $boom delete enemies | grep "Deleted"
  ! $boom | grep "enemies"
}

it_handles_delete_on_nonexistent_list() {
  ! $boom | grep "enemies"
  $boom delete "enemies" | grep "We couldn't find that list"
}

it_handles_empty_boomfile() {
  cp /dev/null test/examples/empty.json
  export BOOMFILE=test/examples/empty.json
  $boom heynow | grep "Created a new list"
  export BOOMFILE=test/examples/data.json
}  
