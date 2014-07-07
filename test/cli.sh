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

it_exports_json() {
  $boom --export | grep "lists"
}

it_imports_json() {
  #change the boom file to test import
  export BOOMFILE=test/examples/temp.json
  $boom --import < test/examples/data2.json | grep "Imporded data"
  $boom --export | grep "diditimport"

  #set it back
  rm test/examples/temp.json
  export BOOMFILE=test/examples/data.json

}
