# YARV

[![Build Status](https://github.com/ruby-syntax-tree/yarv/workflows/Main/badge.svg)](https://github.com/ruby-syntax-tree/yarv/actions)

This project's aim is to provide an educational window into how CRuby's virtual machine works under the hood.

CRuby uses a stack-based virtual machine named YARV. You can see the bytecode that will be executed by running `RubyVM::InstructionSequence.compile(source).disasm` or by running `ruby --dump=insns -e source`. At last count, there were `202` instructions, though that number gets significantly smaller if you factor out tracepoint and specialized instructions. Most instructions look similar to their machine code counterparts.

There isn't really a canonical source for documentation for these instructions beyond the source code itself in [insns.def](https://github.com/ruby/ruby/blob/master/insns.def) or the original YARV [design document](http://www.atdot.net/yarv/yarvarch.ja.html). Because of this, this project aims to provide comprehensive documentation to make it easier to contribute to CRuby's development. The documentation is currently published at [https://ruby-syntax-tree.github.io/yarv/](https://ruby-syntax-tree.github.io/yarv/). It is generated by running `bin/doc`.

As a part of the documentation effort, this project also aims to provide an emulator of YARV behavior. This will ensure the documentation doesn't get out of date as it will need to reflect actual Ruby semantics. To run the emulator, after cloning the repository, run `exe/yarv <path_to_file>` from the command line.

## Getting started

To use this project as a CLI, you can execute the `exe/yarv` executable. That functions similarly to the `ruby` executable. You pass it the path to a Ruby file, and it will execute that file.

To use this project as a library, you start with the `YARV.compile` method. This method is similar to the `RubyVM::InstructionSequence.compile` method, in that it accepts a string that represents Ruby source code and compiles it into instruction sequences. Once the source is compiled, you can call `eval` on the result to get it to evaluate your code.

## Related content

To learn more about this kind of content, there are a number of articles and blog posts you can read. Most of them are in Japanese, so a translation tool may be necessary. Some of them are also quite old since a lot of them were written around the time YARV was created. They are listed below:

* http://www.atdot.net/yarv/yarvarch.ja.html - (Mar 2004) YARV design document
* https://i.loveruby.net/ja/rhg/book/ - (Jul 2004) Ruby source code complete explanation
* https://magazine.rubyist.net/articles/0006/0006-YarvManiacs.html - (May 2005) YARV maniacs
* http://graysoftinc.com/the-ruby-vm-interview/the-ruby-vm-serial-interview - (Feb 2007) The Ruby VM Serial Interview
* https://lifegoo.pluskid.org/upload/doc/yarv/yarv_iset.html - (Apr 2008) YARV instruction set
* https://patshaughnessy.net/2012/6/29/how-ruby-executes-your-code - (Jun 2012) How Ruby Executes Your Code (excerpt from _Ruby Under a Microscope_)
* http://www.atdot.net/~ko1/diary/201212.html#d1 - (Dec 2012) ko1's 2012 Ruby VM advent calendar
* https://qiita.com/sisshiki1969/items/3d25aa81a376eee2e7c2 - (Dec 2019) Ruby made with Rust
* https://iliabylich.github.io/2020/01/25/evaluating-ruby-in-ruby.html - (Jan 2020) Evaluating Ruby in Ruby

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ruby-syntax-tree/yarv. In this project's current form there are lots of opportunities to contribute. To get started, please check the issues on the project board.

CRuby contains tests that help with generating specific instructions, these are a good starting point when writing tests for our reimplemented instructions: [https://github.com/ruby/ruby/blob/master/bootstraptest/test_insns.rb](https://github.com/ruby/ruby/blob/master/bootstraptest/test_insns.rb).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
