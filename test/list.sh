#!/usr/bin/env roundup
export BOOMFILE=test/examples/data.json
boom="./bin/boom"

describe "lists"

it_shows_all_lists_by_default() {
  $boom | grep "urls (2)"
}