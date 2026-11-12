;;;; evaluator.lisp -- Part 2. Write the eight functions below.
;;;;
;;;; The toy language is a Lisp-1. One namespace holds both variables and
;;;; functions, so a variable bound to a closure is callable in operator
;;;; position and (f 1) works with no FUNCALL. The CLISP hosting this file is a
;;;; Lisp-2, which is why the host needs FUNCALL and #' where the toy language
;;;; needs neither. ANALYSIS.md asks you about that difference.
;;;;
;;;; An environment is an association list: ((name . value) (name . value) ...).
;;;; The grader scores E1 to E4 separately, so finish them in order and keep
;;;; every group you get right.
;;;;
;;;; The grammar, in full:
;;;;
;;;;   expr := number
;;;;         | symbol
;;;;         | (+ expr expr) | (- expr expr) | (* expr expr)
;;;;         | (let ((name expr) ...) body)
;;;;         | (lambda (name ...) body)
;;;;         | (operator-expr argument-expr ...)

;;; E1 -- numbers and symbols.
(defun lookup (name env)
  "The value NAME is bound to in ENV. First match wins; error if unbound."
  (let ((binding (assoc name env)))
    (if binding
        (cdr binding)
        (error "Unbound variable: ~a" name))))

;;; E2 -- prefix arithmetic.

(defun eval-operands (exprs env)
  "Every expression in EXPRS, evaluated in the same ENV, as a list.

MAPCAR and a LAMBDA do this in one line. Watch the arity: EVAL-EXPR takes two
arguments and MAPCAR hands its function one."
  (mapcar (lambda (expr)
            (eval-expr expr env))
          exprs))

(defun apply-op (op values)
  "Apply the arithmetic operator OP to the two numbers in VALUES.

OP is the symbol +, -, or *. Signal an error for anything else."
  (cond
    ((eq op '+) (+ (first values) (second values)))
    ((eq op '-) (- (first values) (second values)))
    ((eq op '*) (* (first values) (second values)))
    (t (error "Unknown operator: ~A" op))))

;;; E3 -- let.

(defun extend-env (params args env)
  "ENV with PARAMS bound to ARGS in front of it. Does not modify ENV."
  (append (mapcar #'cons params args) env))

(defun eval-let (expr env)
  "Evaluate (let ((name init) ...) body) with parallel bindings."
  (let* ((bindings (second expr))
         (body     (third expr))
         (names    (mapcar #'first bindings))
         (inits    (mapcar #'second bindings)))
    ;; inits are evaluated in ENV, before any name is bound
    (eval-expr body (extend-env names (eval-operands inits env) env))))

;;; E4 -- lambda and application.

(defun make-closure (params body env)
  "A closure over ENV.

Return the list (:closure params body env). ENV is the environment the lambda
was written in, not the one it will later be called from. Saving the wrong one
is what makes the difference between 3 and 101 in the case the manual walks
through."
  (list :closure params body env))

(defun apply-closure (closure args)
  "Run CLOSURE on ARGS.

The parameters join the environment the closure captured. Signal an error when
CLOSURE is not a closure, and when the argument count does not match."
  (if (and (consp closure)
           (eq (first closure) :closure))
      (let ((params (second closure))
            (body (third closure))
            (env (fourth closure)))
        (if (= (length params) (length args))
            (eval-expr body (extend-env params args env))
            (error "Argument count mismatch")))
      (error "Not a closure: ~A" closure)))

;;; The dispatcher.

(defun eval-expr (expr env)
  "The value of EXPR in ENV.

Order the branches with care. NIL is a symbol as well as the empty list, and a
number is not a cons, so the atom tests come before the list tests."
  (cond
    ;; Numbers evaluate to themselves.
    ((numberp expr)
     expr)

    ;; Symbols are looked up in the environment.
    ((symbolp expr)
     (lookup expr env))

    ;; Everything else must be a compound expression.
    ((consp expr)
     (let ((op (first expr)))
       (cond
         ;; Arithmetic.
         ((member op '(+ - *))
          (apply-op op
                    (eval-operands (rest expr) env)))

         ;; LET.
         ((eq op 'let)
          (eval-let expr env))

         ;; LAMBDA.
         ((eq op 'lambda)
          (make-closure (second expr)
                        (third expr)
                        env))

         ;; Application.
         (t
          (let ((function (eval-expr op env))
                (args (eval-operands (rest expr) env)))
            (apply-closure function args))))))

    ;; Anything outside the grammar is invalid.
    (t
     (error "Invalid expression: ~A" expr))))
