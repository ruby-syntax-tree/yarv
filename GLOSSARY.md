## abstract syntax tree

An intermediate data structure created by a compiler that is used as a representation of the source code.

## argc

Short for argument count. The number of values being sent as part of a method call to the receiver. This includes any kind of argument (positional, keyword, block, etc.).

## binding

An object that wraps a [control frame](#control-frame) in the YARV virtual machine and retains its context for future use.

## branch

A place in a list of instructions where the next instruction to execute may no longer be the next instruction in sequence.

## byte

The byte is a unit of digital information that most commonly consists of eight bits.

## bytecode

A programming language consisting of simple, low-level instructions which are designed to be easy and fast to execute.

## call data

Metadata about a specific call-site in the source. For example: `1.to_s` represents a single call-site. It has an `argc` of `0`, a `mid` (the ID of the method being called) of `:to_s`, and a `flag` value corresponding to `ARGS_SIMPLE`.

## call site

Any place in source code where a method is called.

## call stack

A stack of bindings used to track the scope of the program when a new method or block is called. Every time a new method is called, this call is pushed onto the stack. When that call returns, it is popped off the stack.

## calling convention

An low-level scheme for how methods receive parameters from their caller and how they return a result. 

## catch table

A list of pointers to instructions in the bytecode that represent where to continue execution when the `throw` instruction is executed. This happens as a result of control-flow keywords like `break` and `next`.

## cd hash

A Ruby hash used for handling optimized `case` statements. The keys are the conditions of `when` clauses in the `case` statement,
and the values are the labels to which to jump. This optimization can be applied only when the keys can be directly compared. For example:

~~~ruby
case 1
when 1
  puts "foo"
else
  puts "bar"
end
~~~

## control frame

An object that encapsulates the execution context at some particular place in the code. This includes things like local variables, the current value of `self`, etc.

## dispatch

Calling a method.

## execution context

The global information available to the running Ruby process. This includes global variables, defined methods, constants, etc.

## frame

See [control frame](#control-frame).

## instruction

One unit of work for the virtual machine to execute.

## instruction argument

Objects encoded into the bytecode that are used by an instruction that are known at compile-time.

## instruction operand

See [instruction argument](#instruction-argument).

## instruction sequence

A set of instructions to be performed by the virtual machine. Every method and block compiled in Ruby will have its own instruction sequence. When those methods or blocks are executed, a [control frame](#control-frame) will be created to wrap the execution of the instruction sequence with additional context. There are many different kinds of instruction sequences, including:

* `top` - the main instruction sequence executed when your program first starts running
* `method` - an instruction sequence representing the body of a method
* `block` - an instruction sequence representing the body of a block
* and many more

## iseq

See [instruction sequence](#instruction-sequence).

## jump

When the program counter is changed manually to dictate the next instruction for execution.

## local

A temporary variable that can only be read in the current [control frame](#control-frame) or its children.

## local table

A data structure that holds metadata about local variables and arguments declared within an instruction sequence.

## nop

Short for no-op. It means to perform nothing when this instruction is executed. Typically this is used to create a space for another operation to [jump](#jump) to when executed.

## operand

See [instruction argument](#instruction-argument).

## opt

Short for [optimization](#optimization).

## optimization

A specialized version of a more generic function. In the context of YARV, this entails special instructions that can be made faster than their more generic counterparts. For example, `opt_plus` is used whenever there is a single argument being passed through the `+` operator.

## pc

See [program counter](#program-counter).

## pop

Remove and return a value from the top of a stack.

## program counter

The offset from the start of the instruction sequence to the currently-executing instruction. This can be dynamically changed by various instructions to accommodate constructs like `if`, `unless`, `while`, etc.

## push

Add a value to the top of a stack (for example a frame, an instruction sequence, etc.).

## put

See [push](#push).

## receiver

The object receiving a message/method call.

## send

See [dispatch](#dispatch).

## source code

The human-readable representation of the code to be executed.

## sp

See [stack pointer](#stack-pointer).

## specialization

See [optimization](#optimization).

## stack

A data structure where the last object to be added is the first object to be removed. Objects are added ([pushed](#push)) onto the stack and removed ([popped](#pop)) off of the stack. In the context of YARV, stacks are used to represent [control frames](#control-frame) and the [value stack](#value-stack).

## stack pointer

A pointer to the next empty slot in the stack (i.e., the top).

## tracepoint

A publication/subscription system for virtual machine events. Users can create tracepoints to get notified when certain events occur.

## value stack

A data structure used to track return values, variables, and arguments.

## virtual machine

A software implementation of a computer. In the context of YARV, the virtual machine executes the [bytecode](#bytecode) that Ruby compiles.

## vm

See [virtual machine](#virtual-machine).

## yarv

Stands for Yet Another Ruby Virtual Machine. It came around in Ruby 1.9 and replaced MRI (Matz' Ruby Interpreter). Previously Ruby was a tree-walk interpreter (it walked the syntax tree to execute). YARV replaced that by compiling the syntax tree into a bytecode that it executes, which is must faster.
