# Reasoning for the Predictions Table

Write one entry under every heading below, then commit this file together with
`predictions.tsv`, before you run a case or open `tests/expected.tsv`.

Each entry names the rule that produces the four predicted fields for that
case. One to three sentences is enough. The grader checks structure only. It
does not judge quality, and it sets no word minimum.

After you run the cases, add a short correction under each case you predicted
wrongly. Say what you predicted, what CLISP printed, and which rule you
misread. Those entries belong in the correction commits.

## P01
Function arguments are evaluated before the function call, so (* 2 3) produces 6 and (+ 1 6) produces 7. The outer operator is +, a function.

## P02
Two quote forms prevent evaluation of the inner expression, producing (quote (+ 1 2)). quote is a special operator, and the resulting list has two elements.

## P03
nil evaluates to NIL, which is both the empty list and the false value. Its kind is null and its length is 0.

## P04
t evaluates to the symbol T. Symbols are not lists, so it has no length and no operator.

## P05
symbolp tests whether its argument is a symbol, and NIL is a symbol. The function therefore returns T.

## P06
The quoted empty list evaluates to NIL, and car of an empty list returns NIL. car is a function and NIL has length 0.

## P07
cons adds 1 to the front of the list (2 3), producing (1 2 3). The result is a cons list of length 3.

## P08
null returns T for NIL, so the if condition is true and the quoted symbol empty is returned. if is a special operator.

## P09
`and` evaluates its arguments left to right and stops at the first false (`nil`) value, so `3` is never evaluated. The result is `nil`, so the kind is `null` and the length is 0. The standard calls `and` a macro, but CLISP also implements it as a special operator, and the course checks for a special operator first, so the operator is `special-operator`.

## P10
`defvar` makes `*ps3-rate*` special. When `let` rebinds a special variable, every function sees the new binding while the `let` runs, so `ps3-scale` reads 10 and not the 2 from when it was defined. The result is 30, an integer, so its length is `none`, and the head `progn` is a special operator and returns the value of its last subform.

## P11
`defun` is a macro and it defines the function as a side effect and returns the function's name, a symbol. A symbol other than `nil` has kind `symbol`, and its length is `none` because it is not a sequence.

## P12
`labels` is a special operator that binds `down` locally so it can call itself. `down` recurses until the base case returns `nil`, and each level uses `cons` to put `n` in front of the list from the level below. The result is `(3,2,1)`, so the kind is `cons` and the length is 3.

## P13
`mapcar` is a function, so its arguments are evaluated first. It applies `length` to each element: 2 for `(1 2)`, 0 for the empty list (a sequence, so not `none`), and 1 for `(3)`. The result is `(2,0,1)`, so its kind is `cons` and its length is 3.

## P14
`mapcar` is the head of the whole form, so the operator is `function`. The `lambda` only supplies the function to apply. The results are 1, 4 and 9, so the value is `(1,4,9)`, its kind is `cons` and its length is 3.

## P15
`lambda` is a macro that expands into a `function` form. Evaluating it returns a function object without running the body. The grader writes that as `#<function>`, and a function is not a sequence, so its length is `none`.

## P16
All the `factor` bindings come from plain `let`, so they are lexical. The lambda captures the binding that exists when it is created, which holds 2, and the later `factor` bound to 10 is a separate binding the function never sees, so the call returns 6, an integer with length `none`. This differs from P10 because a `defvar` variable is special, so a rebinding is visible to every function while the `let` runs and the head `let` is a special operator.
