# A supercongruence modulo p⁵ for OEIS A212334

A Lean 4 and Mathlib proof of a congruence that Peter Bala recorded in
[OEIS A212334](https://oeis.org/A212334), laid out for the
[Palomar registry](https://palomar-registry.org/).

## The result

For $n \ge 1$ let

$$a(n) = \sum_{k=0}^{n-1} \binom{n}{k} \binom{n-1}{k} \binom{n+k-1}{k}^{2}, \qquad a(0) = 1 .$$

**Theorem.** For every prime $p \ge 5$, $a(p) \equiv 1 \pmod{p^5}$.

The formal statement, in [`Challenge.lean`](Challenge.lean):

```lean
theorem OeisA212334.conjecture_1 (p : ℕ) (hp : p.Prime) (hp5 : 5 ≤ p) :
    a p % (p ^ 5) = 1
```

`%` is the remainder of a natural number. Since $p^5 > 1$, the equation says exactly
$a(p) \equiv 1 \pmod{p^5}$.

## Scope and limitations

- The Lean definition `a` is the binomial sum. OEIS defines the sequence by counting words
  over a 4-letter alphabet and records the sum as a formula. That equivalence is **not**
  formalized.
- Only the prime-level congruence is proved. The conjecture in the same entry that
  $a(p^r) \equiv a(p^{r-1}) \pmod{p^{3r+3}}$ for $r \ge 2$ is **not** addressed.
- **No novelty or priority is claimed.** An earlier informal proof is public (see below). No
  systematic literature search was made.
- No independent human mathematical review is claimed. The checks are mechanical.

## Context

The OEIS entry records that $a(n) = \tfrac{1}{12}\bigl(A(n) + 7A(n-1)\bigr)$ for $n \ge 1$,
where $A(n)$ are the Apéry numbers ([A005259](https://oeis.org/A005259)), and that
$a(np^k) \equiv a(np^{k-1}) \pmod{p^{3k}}$ for primes $p \ge 5$. At $n = k = 1$ the latter reads
$a(p) \equiv 1 \pmod{p^3}$; the theorem here has the modulus $p^5$. Congruences of this kind for
Apéry numbers are studied in I. Gessel,
[*J. Number Theory* 14 (1982)](https://doi.org/10.1016/0022-314X(82)90071-3), and F. Beukers,
[*J. Number Theory* 21 (1985)](https://doi.org/10.1016/0022-314X(85)90047-2). Neither the Apéry
identity nor these papers are used in the Lean proof.

## Proof summary

Write $T_k$ for the $k$-th summand of $a(p)$, so that $T_0 = 1$. Work in $\mathbb{Z}/p^5$.

1. `summand_succ`: $(k+1)^4 \, T_{k+1} = (p-k)(p-1-k)(p+k)^2 \, T_k$.
2. `pow_four_mul_summand`: by induction on this recurrence, $k^4 T_k = p^4 - p^3 k$ for
   $0 < k < p$.
3. `pow_four_mul_summand_add`: hence $k^4 (T_k + T_{p-k}) = 5p^4$.
4. `sum_summand`: so $2 \sum_{0<k<p} T_k = 5 p^4 \sum_{0<k<p} k^{-4}$. The right side vanishes,
   directly if $p = 5$, and for $p \ge 7$ because $\sum_{0<k<p} k^{-4} \equiv 0 \pmod p$
   (`sum_inv_pow_four`). Since 2 is a unit, $\sum_{0<k<p} T_k = 0$.
5. `conjecture_1`: therefore $a(p) = T_0 = 1$.

The whole proof is in [`Solution.lean`](Solution.lean) and depends only on Mathlib.

## Provenance and credit

- **Congruence:** Peter Bala, comment in OEIS A212334 dated 12 December 2021, stated as
  "It appears that for primes p >= 5, a(p) == 1 (mod p^5)".
- **Formal statement:** the definition `a` and the statement `conjecture_1`, with their
  docstrings, are copied from
  [`google-deepmind/formal-conjectures`](https://github.com/google-deepmind/formal-conjectures/blob/9097e2f90e66d2f6244209cb1c07f7120d17ec53/FormalConjectures/OEIS/212334.lean),
  Copyright 2026 The Formal Conjectures Authors, Apache-2.0.
- **Prior informal proof:** a separately authored write-up of this prime-level congruence is in
  [`rbajaj5/a183068-supercongruence`](https://github.com/rbajaj5/a183068-supercongruence/blob/51d8d7d7a136baf51bd5b55337fd29c698e23232/related-results/A212334EnhancedPrimeCongruence.md)
  (committed 12 August 2026). It reaches the same congruence for each summand as step 2, there
  by a product formula. Its conclusion is closely related to steps 3 and 4: it treats the sums
  of $k^{-3}$ and $k^{-4}$ separately, where this proof pairs the summands at $k$ and $p-k$.
  No priority and no independent discovery of the argument is claimed here.
- **AI assistance:** the Lean proof was produced with AI models (Claude Fable 5.2,
  Gemini 4 Neon and Codex GPT-6.2 Sol), directed by `EliaSupernova`. An AI agent
  (Claude Sonnet 5.5) ported it to the toolchain used here, assembled this repository from
  [PalomarTemplate](https://github.com/PalomarRegistry/PalomarTemplate), drafted the metadata
  and README, and ran the local checks.
- **Maintainer:** `EliaSupernova`.

The structured record is in [`formalization.yaml`](formalization.yaml).

## Repository map

| Path | Contents |
| --- | --- |
| `Challenge.lean` | The statement to audit, with one deliberate `sorry` |
| `Solution.lean` | The proof, with no `sorry` |
| `comparator.json` | The compared declaration and the permitted axioms |
| `formalization.yaml` | Sources, provenance, automation, scope and review status |
| `docbuild/` | Nested doc-gen4 project |
| `scripts/` | Checks taken unchanged from PalomarTemplate |

## Verification

Requirements: Linux, [`elan`](https://github.com/leanprover/elan), Git, Ruby, Python 3,
[bubblewrap](https://github.com/containers/bubblewrap) and a network connection, with several GiB
of free disk space. The toolchain is Lean `v4.35.0-rc2`, and `lake-manifest.json` pins Mathlib to
commit `065356127b1dc0016f66b7283ce0ce2c4055aa55`.

From the repository root:

```sh
python3 scripts/check-lean-sources.py
lake exe cache get
lake --wfail build
(cd docbuild && DISABLE_EQUATIONS=1 lake build Challenge:docs Solution:docs)
ruby scripts/validate-formalization.rb
./scripts/verify-comparator.sh
```

The documentation step needs several GiB of memory and a configured Git remote, which doc-gen4
uses for source links.

`--wfail` turns every warning into a failure. The one expected `sorry` warning, in
`Challenge.lean`, is switched off for that library only in `lakefile.toml`, so a `sorry` in the
proof still fails the build.

To print the axioms of the theorem:

```sh
printf 'import Solution\n#print axioms OeisA212334.conjecture_1\n' | lake env lean --stdin
```

Expected output:

```text
'OeisA212334.conjecture_1' depends on axioms: [propext, Classical.choice, Quot.sound]
```

A successful check shows that the proof proves the statement in `Challenge.lean` from these
axioms. Whether that statement matches the intended mathematics is for the reader to check.

Registry submissions go through <https://submit.palomar-registry.org/>.

## License

[Apache License 2.0](LICENSE).
