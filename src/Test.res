// There's a bug here on purpose
let isSubstring = (pattern, text) => Js.String2.indexOf(text, pattern) > 0

open Arbitrary
open Property

asserts(property(tuple3(string(), string(), string()), ((a, b, c)) => isSubstring(b, a ++ b ++ c)))
