# frozen_string_literal: true

module YARV
  class Visitor < SyntaxTree::Visitor
    attr_reader :iseq

    def initialize
      @iseq = nil
    end

    def visit_binary(node)
      case node.operator
      in :+
        visit(node.left)
        visit(node.right)
        emit(OptPlus.new(call_data(node.operator, 1, %i[ARGS_SIMPLE])))
      in :-
        visit(node.left)
        visit(node.right)
        emit(OptMinus.new(call_data(node.operator, 1, %i[ARGS_SIMPLE])))
      in :*
        visit(node.left)
        visit(node.right)
        emit(OptMult.new(call_data(node.operator, 1, %i[ARGS_SIMPLE])))
      in :/
        visit(node.left)
        visit(node.right)
        emit(OptDiv.new(call_data(node.operator, 1, %i[ARGS_SIMPLE])))
      in :"||"
        visit(node.left)
        emit(Dup.new)
        emit_jump(BranchIf) do
          emit(Pop.new)
          visit(node.right)
        end
      in :"&&"
        visit(node.left)
        emit(Dup.new)
        emit_jump(BranchUnless) do
          emit(Pop.new)
          visit(node.right)
        end
      end
    end

    def visit_bodystmt(node)
      node.rescue_clause => nil
      node.else_clause => nil
      node.ensure_clause => nil
      visit(node.statements)
    end

    def visit_call(node)
      visit(node.receiver)

      name = node.message == :call ? :call : node.message.value.to_sym
      send = OptSendWithoutBlock.new(call_data(name, 0, %i[ARGS_SIMPLE]))

      if node.operator in SyntaxTree::Op[value: "&."]
        emit(Dup.new)
        emit_jump(BranchNil) { emit(send) }
      else
        emit(send)
      end
    end

    def visit_else(node)
      visit(node.statements)
    end

    def visit_float(node)
      emit(PutObject.new(node.value.to_f))
    end

    def visit_gvar(node)
      emit(GetGlobal.new(node.value.to_sym))
    end

    def visit_if(node)
      visit(node.predicate)

      branch_offset = current_offset
      emit(:branch_placeholder)
      visit(node.statements)

      if node.consequent
        emit(Pop.new)
        emit_jump(Jump) do
          iseq.insns[branch_offset] = BranchUnless.new(emit_label)
          visit(node.consequent)
          emit(Pop.new)
        end
      else
        iseq.insns[branch_offset] = BranchUnless.new(emit_label)
      end
    end

    def visit_if_mod(node)
      visit(node.predicate)
      emit_jump(BranchUnless) do
        visit(node.statement)
        emit(Pop.new)
      end
    end

    def visit_imaginary(node)
      emit(PutObject.new(node.value.to_c))
    end

    def visit_int(node)
      case (coerced = node.value.to_i)
      when 0
        emit(PutObjectInt2Fix0.new)
      when 1
        emit(PutObjectInt2Fix1.new)
      else
        emit(PutObject.new(coerced))
      end
    end

    def visit_paren(node)
      visit(node.contents)
    end

    def visit_program(node)
      @iseq = InstructionSequence.new(Main.new, [])
      visit(node.statements)
      emit(Leave.new)
      iseq
    end

    def visit_rational(node)
      emit(PutObject.new(node.value.to_r))
    end

    def visit_statements(node)
      visit_all(node.body)
    end

    def visit_string_concat(node)
      visit(node.left)
      visit(node.right)
      emit(ConcatStrings.new(2))
    end

    def visit_string_dvar(node)
      visit(node.variable)
      emit(Dup.new)
      emit(ObjToString.new(call_data(:to_s, 0, %i[FCALL ARGS_SIMPLE])))
      emit(AnyToString.new)
    end

    def visit_string_embexpr(node)
      visit(node.statements)
      emit(Dup.new)
      emit(ObjToString.new(call_data(:to_s, 0, %i[FCALL ARGS_SIMPLE])))
      emit(AnyToString.new)
    end

    def visit_string_literal(node)
      case node.parts
      in [SyntaxTree::TStringContent[value:]]
        emit(PutString.new(value))
      in [SyntaxTree::StringDVar => part]
        visit(SyntaxTree::TStringContent.new(value: "", location: nil))
        visit(part)
        emit(ConcatStrings.new(2))
      in [part]
        visit(part)
      else
        visit_all(node.parts)
        emit(ConcatStrings.new(node.parts.length))
      end
    end

    def visit_symbol_literal(node)
      emit(PutObject.new(node.value.value.to_sym))
    end

    def visit_tstring_content(node)
      emit(PutObject.new(node.value))
    end

    def visit_unless_mod(node)
      visit(node.predicate)
      emit_jump(BranchIf) do
        visit(node.statement)
        emit(Pop.new)
      end
    end

    def visit_vcall(node)
      cdata = call_data(node.value.value.to_sym, 0, %i[FCALL VCALL ARGS_SIMPLE])

      emit(PutSelf.new(iseq.selfo))
      emit(OptSendWithoutBlock.new(cdata))
    end

    def visit_void_stmt(node)
    end

    def visit_xstring_literal(node)
      emit(PutSelf.new(iseq.selfo))
      visit_all(node.parts)
      emit(ConcatStrings.new(node.parts.length)) if node.parts.length > 1
      emit(OptSendWithoutBlock.new(call_data(:`, 1, %i[FCALL ARGS_SIMPLE])))
    end

    private

    def call_data(mid, argc, flags)
      flag =
        flags.inject(0) { |sum, flag| sum | (1 << CallData::FLAGS.index(flag)) }

      CallData.new(mid, argc, flag)
    end

    def current_offset
      iseq.insns.length
    end

    def emit(insn)
      iseq << insn
    end

    def emit_jump(kind)
      offset = current_offset
      emit(:placeholder)

      yield
      iseq.insns[offset] = kind.new(emit_label)
    end

    def emit_label
      offset = current_offset
      label = :"label_#{offset}"

      iseq.labels[label] = offset
      label
    end
  end
end
