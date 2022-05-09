# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2022-05-09

### Added

- [#19](https://github.com/kddnewton/yarv/pull/19) - Add arm64 platform to Gemfile.lock for M1 macs.
- [#20](https://github.com/kddnewton/yarv/pull/20) - Configure Ruby Spec to run on GH Actions. Allowing it to fail for now since we're nowhere near passing, but it is running on every PR so we can see progress.
- [#24](https://github.com/kddnewton/yarv/pull/24) - Implement `opt_str_uminus`.
- [#26](https://github.com/kddnewton/yarv/pull/26) - Implement `opt_minus`.
- [#30](https://github.com/kddnewton/yarv/pull/33) - Implement `putstring`.
- [#34](https://github.com/kddnewton/yarv/pull/34) - Implement `getglobal`.
- [#39](https://github.com/kddnewton/yarv/pull/39) - Implement `setglobal` and `dup`.
- [#42](https://github.com/kddnewton/yarv/pull/42) - Implement `opt_and`.
- [#46](https://github.com/kddnewton/yarv/pull/46) - Implement `opt_getinlinecache`, `opt_setinlinecache`, and `getconstant`.
- [#49](https://github.com/kddnewton/yarv/pull/49) - Implement `opt_empty_p`.
- [#51](https://github.com/kddnewton/yarv/pull/51) - Implement `pop`.
- [#54](https://github.com/kddnewton/yarv/pull/54) - Implement `opt_div`.
- [#57](https://github.com/kddnewton/yarv/pull/57) - Implement `opt_or`.
- [#58](https://github.com/kddnewton/yarv/pull/58) - Implement `opt_nil_p`.
- [#59](https://github.com/kddnewton/yarv/pull/59) - Implement `opt_aref`.
- [#60](https://github.com/kddnewton/yarv/pull/60) - Implement `branchunless`. Also change the compilation process to append instructions instead of mapping everything so that we can track instruction index to jump properly. Additionally, `YARV::ExecutionContext` now has knowledge of which instruction sequence is currently being executed.
- [#61](https://github.com/kddnewton/yarv/pull/61) - Implement `definemethod`. This also changes the way we dispatch methods. Now in order to properly hook into our method definitions (including any monkey-patching), you need to call `context.call_method`. That way it will check for any redefined methods as well as hooking into the parent runtime to run the methods.
- [#67](https://github.com/kddnewton/yarv/pull/67) - Implement `opt_length`.
- [#69](https://github.com/kddnewton/yarv/pull/69) - Implement `putobject_INT2FIX_0_`.
- [#72](https://github.com/kddnewton/yarv/pull/72) - Implement `opt_succ`.
- [#76](https://github.com/kddnewton/yarv/pull/76) - Format the project with Syntax Tree. Add a check to CI that will run `rake syntax_tree:check` to verify everything is formatted. In order to run the format command locally, run `rake syntax_tree:format`.
- [#80](https://github.com/kddnewton/yarv/pull/80) - Implement `getlocal_WC_0` and `setlocal_WC_0`. Additionally begin tracking locals on the frame.
- [#83](https://github.com/kddnewton/yarv/pull/83) - Implement `putobject_INT2FIX_1_`.

### Changed

- [#27](https://github.com/kddnewton/yarv/pull/27) - Split up the test files and run the tests through `rake`.
- [#30](https://github.com/kddnewton/yarv/pull/30) - An execution context is now passed around to the different instructions instead of just a stack. This is going to allow saving much more information between instructions and allow jumping between instructions by manipulating the `program_counter` field.
- [#62](https://github.com/kddnewton/yarv/pull/62) - Change all of the instructions from calling `execute` to calling `call`. This should make it easier to prototype missing instructions as you can use a lambda without having to build out a whole class.
- [#63](https://github.com/kddnewton/yarv/pull/63) - Run the spec GitHub action in Ruby 3.1.
- [#70](https://github.com/kddnewton/yarv/pull/70) - Fix the value passed into mspec for `__FILE__`.

### Removed

- [#83](https://github.com/kddnewton/yarv/pull/83) - Remove the top-level `YARV.emulate` method in favor of `YARV.compile(...).eval`.

## [0.1.0] - 2022-05-09

### Added

- 🎉 Initial release! 🎉

[unreleased]: https://github.com/kddnewton/yarv/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/kddnewton/yarv/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/kddnewton/yarv/compare/002375...v0.1.0
