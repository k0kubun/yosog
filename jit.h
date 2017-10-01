enum rb_jit_iseq_func {
    NOT_ADDED_JIT_ISEQ_FUNC = 0,
    NOT_READY_JIT_ISEQ_FUNC = 1,
    NOT_COMPILABLE_JIT_ISEQ_FUNC = 2,
    LAST_JIT_ISEQ_FUNC = 3,
};

#define JIT_MIN_TOTAL_CALLS 5
#define JIT_MAX_ISEQ_SIZE 1000

typedef VALUE (*jit_func_t)(rb_thread_t *, rb_control_frame_t *);

extern int jit_enabled;

extern void jit_init();
extern void jit_finalize();
extern void jit_enqueue(const rb_iseq_t *iseq);
extern void jit_gc_start_hook();
extern void jit_gc_finish_hook();
void * jit_compile(const rb_iseq_t *iseq); /* test*/

static inline VALUE
jit_exec(rb_thread_t *th)
{
    const rb_iseq_t *iseq;
    struct rb_iseq_constant_body *body;
    long unsigned total_calls;
    jit_func_t func;

    if (!jit_enabled)
	return Qundef;

    iseq = th->ec.cfp->iseq;
    body = iseq->body;
    total_calls = ++body->total_calls;

    func = body->jit_func;
    if (UNLIKELY((ptrdiff_t)func <= (ptrdiff_t)LAST_JIT_ISEQ_FUNC)) {
	switch ((enum rb_jit_iseq_func)func) {
	  case NOT_ADDED_JIT_ISEQ_FUNC:
	    if (total_calls == JIT_MIN_TOTAL_CALLS
		&& (body->type == ISEQ_TYPE_METHOD || body->type == ISEQ_TYPE_BLOCK)
		&& body->iseq_size < JIT_MAX_ISEQ_SIZE) {
		body->jit_func = (void *)NOT_READY_JIT_ISEQ_FUNC;
		jit_enqueue(iseq);
		//func = body->jit_func = jit_compile(iseq);
	    }
	    return Qundef;
	  case NOT_READY_JIT_ISEQ_FUNC:
	  case NOT_COMPILABLE_JIT_ISEQ_FUNC:
	    return Qundef;
	  default: /* to avoid warning with LAST_JIT_ISEQ_FUNC */
	    break;
	}
    }

    return func(th, th->ec.cfp);
}
