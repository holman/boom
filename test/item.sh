#!/usr/bin/env roundup
export BOOMFILE=test/examples/data.json
boom="./bin/boom"

describe "items"

it_adds_an_item() {
  $boom urls google 'http://google.com'
  $boom urls | grep google.com
}

it_deletes_an_item() {
  yes | $boom urls google --delete | grep 'gone forever'
  $boom urls google | grep 'not found'
}

it_echos_an_item() {
  $boom echo site | grep 'zachholman.com'
}

it_handles_open_on_nonexistent_item() {
  $boom open nadda | grep "nadda"
}
