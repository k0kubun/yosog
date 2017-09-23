require 'test/unit'

class TestJIT < Test::Unit::TestCase
  TEST_ITERATIONS = 5

  def test_nop
    test_results { |k| def k._jit; nil rescue true; end }
  end

  # def test_getlocal
  # def test_setlocal
  # def test_getspecial
  # def test_setspecial
  # def test_getinstancevariable
  # def test_setinstancevariable
  # def test_getclassvariable
  # def test_setclassvariable
  # def test_getconstant
  # def test_setconstant
  # def test_getglobal
  # def test_setglobal

  def test_putnil
    test_results { |k| def k._jit; nil; end }
  end

  def test_putself
    test_results { |k| def k._jit; self; end }
  end

  def test_putobject
    test_results { |k| def k._jit; -1; end }
    test_results { |k| def k._jit; 2; end }
    test_results { |k| def k._jit; true; end }
    test_results { |k| def k._jit; false; end }
    test_results { |k| def k._jit; :hello; end }
    test_results { |k| def k._jit; (1..2); end }
  end

  # def test_putspecialobject
  # def test_putiseq
  # def test_putstring
  # def test_concatstrings
  # def test_tostring
  # def test_freezestring
  # def test_toregexp
  # def test_intern
  # def test_newarray
  # def test_duparray
  # def test_expandarray
  # def test_concatarray
  # def test_splatarray
  # def test_newhash
  # def test_newrange
  # def test_pop
  # def test_dup
  # def test_dupn
  # def test_swap
  # def test_reverse
  # def test_reput
  # def test_topn
  # def test_setn
  # def test_adjuststack
  # def test_defined
  # def test_checkmatch
  # def test_checkkeyword
  # def test_trace
  # def test_trace2
  # def test_defineclass
  # def test_send
  # def test_opt_str_freeze
  # def test_opt_str_uminus
  # def test_opt_newarray_max
  # def test_opt_newarray_min
  # def test_opt_send_without_block
  # def test_invokesuper
  # def test_invokeblock
  # def test_leave
  # def test_throw
  # def test_jump
  # def test_branchif
  # def test_branchunless
  # def test_branchnil
  # def test_branchiftype
  # def test_getinlinecache
  # def test_setinlinecache
  # def test_once
  # def test_opt_case_dispatch

  def test_opt_plus
    test_results { |k| def k._jit; 1+2; end }
  end

  def test_opt_minus
    test_results { |k| def k._jit; 5-3; end }
  end

  # def test_opt_mult
  # def test_opt_div
  # def test_opt_mod
  # def test_opt_eq
  # def test_opt_neq
  # def test_opt_lt
  # def test_opt_le
  # def test_opt_gt
  # def test_opt_ge
  # def test_opt_ltlt
  # def test_opt_aref
  # def test_opt_aset
  # def test_opt_aset_with
  # def test_opt_aref_with
  # def test_opt_length
  # def test_opt_size
  # def test_opt_empty_p
  # def test_opt_succ
  # def test_opt_not
  # def test_opt_regexpmatch1
  # def test_opt_regexpmatch2
  # def test_opt_call_c_function
  # def test_bitblt
  # def test_answer
  # def test_getlocal_OP__WC__0
  # def test_getlocal_OP__WC__1
  # def test_setlocal_OP__WC__0
  # def test_setlocal_OP__WC__1

  def test_putobject_OP_INT2FIX_O_0_C_
    test_results { |k| def k._jit; 0; end }
  end

  def test_putobject_OP_INT2FIX_O_1_C_
    test_results { |k| def k._jit; 1; end }
  end

  private

  def test_results
    klass = Class.new
    yield(klass) # This doesn't use block to define :_jit to make it JIT-ed

    expected = klass._jit
    TEST_ITERATIONS.times do
      assert_equal expected, klass._jit
    end
  end
end
