## This is the rakegem gemspec template. Make sure you read and understand
## all of the comments. Some sections require modification, and others can
## be deleted if you don't need them. Once you understand the contents of
## this file, feel free to delete any comments that begin with two hash marks.
## You can find comprehensive Gem::Specification documentation, at
## http://docs.rubygems.org/read/chapter/20
Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'boom'
  s.version           = '0.2.1'
  s.date              = '2011-07-16'
  s.rubyforge_project = 'boom'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "boom lets you access text snippets over your command line."
  s.description = "God it's about every day where I think to myself, gadzooks,
  I keep typing *REPETITIVE_BORING_TASK* over and over. Wouldn't it be great if
  I had something like boom to store all these commonly-used text snippets for
  me? Then I realized that was a worthless idea since boom hadn't been created
  yet and I had no idea what that statement meant. At some point I found the
  code for boom in a dark alleyway and released it under my own name because I
  wanted to look smart."

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["Zach Holman"]
  s.email    = 'github.com@zachholman.com'
  s.homepage = 'https://github.com/holman/boom'

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]

  ## This sections is only necessary if you have C extensions.
  #s.require_paths << 'ext'
  #s.extensions = %w[ext/extconf.rb]

  ## If your gem includes any executables, list them here.
  s.executables = ["boom"]
  s.default_executable = 'boom'

  ## Specify any RDoc options here. You'll want to add your README and
  ## LICENSE files to the extra_rdoc_files list.
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.markdown LICENSE.markdown]

  ## List your runtime dependencies here. Runtime dependencies are those
  ## that are needed for an end user to actually USE your code.
  s.add_dependency('json_pure', "~> 1.5.1")

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  s.add_development_dependency('mocha', "~> 0.9.9")
  s.add_development_dependency('rake', "~> 0.9.2")

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    CHANGELOG.markdown
    Gemfile
    Gemfile.lock
    LICENSE.markdown
    README.markdown
    Rakefile
    bin/boom
    boom.gemspec
    completion/README.md
    completion/boom.bash
    completion/boom.zsh
    lib/boom.rb
    lib/boom/color.rb
    lib/boom/command.rb
    lib/boom/config.rb
    lib/boom/core_ext/symbol.rb
    lib/boom/item.rb
    lib/boom/list.rb
    lib/boom/platform.rb
    lib/boom/storage.rb
    lib/boom/storage/base.rb
    lib/boom/storage/json.rb
    lib/boom/storage/keychain.rb
    lib/boom/storage/mongodb.rb
    lib/boom/storage/redis.rb
    test/examples/config_json.json
    test/examples/test_json.json
    test/examples/urls.json
    test/helper.rb
    test/test_color.rb
    test/test_command.rb
    test/test_config.rb
    test/test_item.rb
    test/test_list.rb
    test/test_platform.rb
  ]
  # = MANIFEST =

  ## Test files will be grabbed from the file list. Make sure the path glob
  ## matches what you actually use.
  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
