#!/usr/bin/env roundup

describe "cli: tests around boom the binary — help, version, and so on"

boom="JSON=test/examples/urls.json ./bin/boom"

it_shows_help() {
  $boom help | grep "boom: help"
}

it_shows_a_version() {
  $boom --version | grep "running boom"
}