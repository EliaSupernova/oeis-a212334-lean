/-
Copyright 2026 The Formal Conjectures Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-/
/-
Adapted from `FormalConjectures/OEIS/212334.lean` in
https://github.com/google-deepmind/formal-conjectures (commit
9097e2f90e66d2f6244209cb1c07f7120d17ec53).

Changes: this file keeps only the definition `a` and the statement `conjecture_1`,
with their docstrings. The import of `FormalConjecturesUtil` is replaced by
Mathlib imports, the `category` attribute is removed and the module documentation
is rewritten.
-/
module

public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.Data.Nat.Choose.Basic
public import Mathlib.Data.Nat.Prime.Defs

/-!
# A supercongruence modulo $p^5$ for OEIS A212334

**Claim.** For $n \ge 1$ let
$$a(n) = \sum_{k=0}^{n-1} \binom{n}{k} \binom{n-1}{k} \binom{n+k-1}{k}^2,$$
and let $a(0) = 1$. Then $a(p) \equiv 1 \pmod{p^5}$ for every prime $p \ge 5$.

This congruence was recorded as an observation ("It appears that ...") by Peter Bala
on 12 December 2021 in the comments of OEIS A212334.

**Reading the statement.** `a p % (p ^ 5) = 1` is the remainder of a natural number.
Since $p^5 > 1$, it says exactly $a(p) \equiv 1 \pmod{p^5}$. The subtractions `n - 1`
and `n + k - 1` are truncated natural-number subtraction, which agrees with ordinary
subtraction in the branch `n ≠ 0` where they are used.

**Scope.** OEIS defines A212334 by counting words over a $4$-ary alphabet and records
the binomial sum above as a formula for it. This file takes the sum as the definition;
the equivalence with the word count is not formalized. The higher prime-power
congruences conjectured in the same OEIS entry are not claimed.

*References:*
- [A212334](https://oeis.org/A212334)
-/

@[expose] public section

namespace OeisA212334

/-- Number of words over a $4$-ary alphabet where each letter occurs $n$ times and adjacent
letters are equal or neighbors, given by
$a(n) = \sum_{k=0}^{n-1} \binom{n}{k} \binom{n-1}{k} \binom{n+k-1}{k}^2$ for $n \ge 1$ and
$a(0) = 1$. -/
def a (n : ℕ) : ℕ :=
  if n = 0 then 1
  else
    ∑ k ∈ Finset.range n, n.choose k * (n - 1).choose k * (n + k - 1).choose k ^ 2

/--
"It appears that for primes $p \ge 5$, $a(p) \equiv 1 \pmod{p^5}$."
- _Peter Bala_, Dec 12 2021
-/
theorem conjecture_1 (p : ℕ) (hp : p.Prime) (hp5 : 5 ≤ p) :
    a p % (p ^ 5) = 1 := by
  sorry

end OeisA212334
