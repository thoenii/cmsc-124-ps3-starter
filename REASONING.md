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
and evaluates its arguments from left to right and stops when it reaches NIL. Therefore the result is NIL, and and is classified as a special operator by CLISP.

## P10
*ps3-rate* is a special variable, so the temporary binding of 10 is visible inside ps3-scale. The function returns 3 * 10, or 30, and the outer progn is a special operator.

## P11
defun defines the function ps3-twice and returns its function name as a symbol. defun is classified as a macro.

## P12
labels creates a local recursive function, and down recursively builds the list (3 2 1). labels is a special operator and the resulting list has length 3.

## P13
mapcar applies length to each list, producing 2, 0, and 1. The result is therefore (2 0 1), and mapcar is a function.

## P14
mapcar applies the anonymous function lambda (n) (* n n) to 1, 2, and 3. Squaring each value produces (1 4 9).

## P15
A lambda expression in value position produces a function object rather than calling the function. Its printed value is #<function>, and lambda is classified as a macro.

## P16
The inner function closes over the outer lexical binding of factor, which is 2. The later binding of factor to 10 is a separate shadowing binding, so the result is 6.
