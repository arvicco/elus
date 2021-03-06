# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{elus}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["arvicco"]
  s.date = %q{2010-03-11}
  s.default_executable = %q{elus}
  s.description = %q{This is a support tool for winning SpaceRangers:Elus}
  s.email = %q{arvitallian@gmail.com}
  s.executables = ["elus"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/elus",
     "doc/dev_plan.htm",
     "doc/dev_plan_files/colorschememapping.xml",
     "doc/dev_plan_files/filelist.xml",
     "doc/dev_plan_files/themedata.thmx",
     "doc/user_stories.htm",
     "doc/user_stories_files/colorschememapping.xml",
     "doc/user_stories_files/filelist.xml",
     "doc/user_stories_files/themedata.thmx",
     "elus.gemspec",
     "features/gamer_inputs_state.feature",
     "features/gamer_starts_solver.feature",
     "features/gamer_updates_state.feature",
     "features/solver_shows_hints.feature",
     "features/step_definitions/elus_steps.rb",
     "features/support/env.rb",
     "features/support/stats.rb",
     "lib/elus.rb",
     "lib/elus/game.rb",
     "lib/elus/generator.rb",
     "lib/elus/piece.rb",
     "lib/elus/rule.rb",
     "lib/elus/solver.rb",
     "spec/cucumber/stats_spec.rb",
     "spec/elus/game_spec.rb",
     "spec/elus/generator_spec.rb",
     "spec/elus/piece_spec.rb",
     "spec/elus/rule_spec.rb",
     "spec/elus/solver_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/arvicco/elus}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{This is a support tool for winning SpaceRangers:Elus}
  s.test_files = [
    "spec/cucumber/stats_spec.rb",
     "spec/elus/game_spec.rb",
     "spec/elus/generator_spec.rb",
     "spec/elus/piece_spec.rb",
     "spec/elus/rule_spec.rb",
     "spec/elus/solver_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_development_dependency(%q<cucumber>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<cucumber>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<cucumber>, [">= 0"])
  end
end

