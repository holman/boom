#!/usr/bin/env roundup
export BOOMFILE=test/examples/data.json
boom="./bin/boom"

describe "cli"

it_shows_help() {
  $boom help | grep "boom: help"
}

it_shows_a_version() {
  $boom --version | grep "running boom"
}