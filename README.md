# YARV Instructions

Below is a list of the YARV instructions that this project has documented so far.

- [leave](#leave)
- [opt_plus](#opt_plus)
- [opt_send_without_block](#opt_send_without_block)
- [putobject](#putobject)
- [putself](#putself)

## leave

### Summary

`leave` exits the current frame.

### TracePoint

`leave` does not dispatch any events.

### Usage

```ruby
;;

# == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,2)> (catch: FALSE)
# 0000 putnil
# 0001 leave
```

## opt_plus

### Summary

`opt_plus` is a specialization of the `opt_send_without_block` instruction
that occurs when the `+` operator is used. In CRuby, there are fast paths
for if both operands are integers, floats, strings, or arrays.

### TracePoint

`opt_plus` can dispatch both the `c_call` and `c_return` events.

### Usage

```ruby
2 + 3

# == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,5)> (catch: FALSE)
# 0000 putobject                              2                         (   1)[Li]
# 0002 putobject                              3
# 0004 opt_plus                               <calldata!mid:+, argc:1, ARGS_SIMPLE>[CcCr]
# 0006 leave
```

## opt_send_without_block

### Summary

`opt_send_without_block` is a specialization of the send instruction that
occurs when a method is being called without a block.

### TracePoint

`opt_send_without_block` does not dispatch any events.

### Usage

```ruby
puts "Hello, world!"

# == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,20)> (catch: FALSE)
# 0000 putself                                                          (   1)[Li]
# 0001 putstring                              "Hello, world!"
# 0003 opt_send_without_block                 <calldata!mid:puts, argc:1, FCALL|ARGS_SIMPLE>
# 0005 leave
```

## putobject

### Summary

`putobject` pushes a known value onto the stack.

### TracePoint

`putobject` can dispatch the line event.

### Usage

```ruby
5

# == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,1)> (catch: FALSE)
# 0000 putobject                              5                         (   1)[Li]
# 0002 leave
```

## putself

### Summary

`putself` pushes the current value of self onto the stack.

### TracePoint

`putself` can dispatch the line event.

### Usage

```ruby
puts "Hello, world!"

# == disasm: #<ISeq:<main>@-e:1 (1,0)-(1,20)> (catch: FALSE)
# 0000 putself                                                          (   1)[Li]
# 0001 putstring                              "Hello, world!"
# 0003 opt_send_without_block                 <calldata!mid:puts, argc:1, FCALL|ARGS_SIMPLE>
# 0005 leave
```

