# Environments and the Toy Evaluator

Our evaluator uses lexical scoping by saving the environment when a lambda is evaluated. The important line is in the `lambda` branch of `eval-expr`:

```lisp
((eq op 'lambda)
 (make-closure (second expr)
               (third expr)
               env))
```

Here, the current `env` is passed to `make-closure`, which stores it in the closure as `(:closure params body env)`. For example, in the scope-discrimination case, when `(lambda (y) (+ x y))` is evaluated inside `(let ((x 2)) ...)`, the environment captured by the closure contains the binding `x = 2`. The later `(let ((x 100)) ...)` creates a new binding that shadows the outer `x`, but it does not change the environment already saved inside the closure.

When `(f 1)` is evaluated, the application branch of `eval-expr` first evaluates the operator with `(eval-expr op env)` and evaluates the arguments with `eval-operands`. The resulting closure and argument are passed to `apply-closure`. In `apply-closure`, the saved environment is extracted with `(fourth closure)` and used here:

```lisp
(eval-expr body (extend-env params args env))
```

Therefore, the function body uses the closure's defining environment, where `x = 2`, and `y = 1` is added to it. The expression `(+ x y)` becomes `(+ 2 1)`, so the scope-discrimination case returns **3**.

If `apply-closure` extended the caller's environment instead, the function would see the `x = 100` binding from the calling scope. The same case would then return **101** because `(+ x y)` would become `(+ 100 1)`. This would make the language use **dynamic scoping** rather than lexical scoping, since a function's variable lookup would depend on where the function was called instead of where it was defined.
