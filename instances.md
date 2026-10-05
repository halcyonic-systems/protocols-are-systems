---
layout: default
title: Instances
description: Three protocols formalized in Lean, one theorem each, and how to read a Lean theorem.
---

# Instances

Three protocols are formalized in Lean against the systems core in [systems-science-foundations](https://github.com/halcyonic-systems/systems-science-foundations). Each has one theorem.

| Protocol | Theorem | Model limits | File |
|---|---|---|---|
| Hand washing | Under "wash every N contacts," a counter starting at or below N never exceeds N. | N = 3. Coarse model. Assumes the rule is followed. | [HandWashing.lean](https://github.com/halcyonic-systems/protocols-are-systems/blob/main/lean/Protocols/HandWashing.lean) |
| TCP and HTTP | Two layers joined by one bond compose into an organized system. | Each layer modeled as closed. | [TCPIP.lean](https://github.com/halcyonic-systems/protocols-are-systems/blob/main/lean/Protocols/TCPIP.lean) |
| Bitcoin | A 10-minute block interval is a fixed point of the difficulty feedback law. | Idealized one-step version of the 2016-block retarget. | [Bitcoin.lean](https://github.com/halcyonic-systems/protocols-are-systems/blob/main/lean/Protocols/Bitcoin.lean) |

## How to read a Lean theorem

The hand-washing result, as it appears in [HandWashing.lean](https://github.com/halcyonic-systems/protocols-are-systems/blob/main/lean/Protocols/HandWashing.lean):

```lean
theorem handwashing_contamination_bounded (n c : ℕ)
    (hsafe : c ≤ sanitizePeriod) :
    contaminationStep^[n] c ≤ sanitizePeriod
```

- `theorem handwashing_contamination_bounded` names a claim.
- `(n c : ℕ)` says the claim holds for any whole numbers `n`, the number of steps taken, and `c`, the starting count.
- `(hsafe : c ≤ sanitizePeriod)` is the assumption: the count starts at or below N.
- After the last colon comes the conclusion. Applying one step of the protocol `n` times (`^[n]`) leaves the count at or below N.
- The proof follows in the file. Lean rejects the file unless every step of the proof checks.
- `sorry` marks a gap in a proof. None of these files contain one.
- `#print axioms` lists what a proof rests on. Here it is only Lean's standard axioms.

## Build

```
cd lean
lake exe cache get
lake build
```

The proofs depend on systems-science-foundations at commit `7efa91b`, pinned in `lean/lakefile.lean`. Built from a clean checkout on 2026-10-02. `#print axioms` shows the three theorems use only Lean's standard axioms (`propext`, `Quot.sound`, `Classical.choice`).
