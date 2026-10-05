---
layout: default
title: Instances
description: Three protocols formalized in Lean, one theorem each, stated in math, in Lean, and in words.
---

# Instances

Three protocols, formalized in Lean against [systems-science-foundations](https://github.com/halcyonic-systems/systems-science-foundations). One theorem each.

## Hand washing

<div class="box definition" markdown="1">
<p class="box-label">Model · contacts since the last wash</p>

The state is a count \\(c \in \mathbb{N}\\). One step is one contact, under the rule "wash every \\(N\\) contacts," with \\(N = 3\\):

$$
f(c) =
\begin{cases}
0 & \text{if } c + 1 \ge N \\
c + 1 & \text{otherwise}
\end{cases}
$$

</div>

<div class="box theorem" markdown="1">
<p class="box-label">Theorem · bounded contamination · <span class="badge proved">Proved</span></p>

$$
\forall\, n, c \in \mathbb{N}, \qquad c \le N \;\Longrightarrow\; f^{\,n}(c) \le N
$$

<p class="in-words">Start at or below N and the count never exceeds N, however many contacts follow.</p>

<details markdown="1">
<summary>In Lean</summary>

```lean
theorem handwashing_contamination_bounded (n c : ℕ)
    (hsafe : c ≤ sanitizePeriod) :
    contaminationStep^[n] c ≤ sanitizePeriod
```

Source: [HandWashing.lean](https://github.com/halcyonic-systems/protocols-are-systems/blob/main/lean/Protocols/HandWashing.lean)
</details>

<p class="in-words"><strong>Model limits.</strong> N = 3. Coarse model: hands and the rule, against surfaces and microbes. Assumes the rule is followed.</p>
</div>

### How to read the Lean

| Piece | Meaning |
|---|---|
| `theorem handwashing_contamination_bounded` | a named claim |
| `(n c : ℕ)` | for any whole numbers \\(n\\) (steps taken) and \\(c\\) (the starting count) |
| `(hsafe : c ≤ sanitizePeriod)` | assumption: \\(c \le N\\) |
| `contaminationStep^[n] c` | \\(f^{\,n}(c)\\), one step applied \\(n\\) times |
| `≤ sanitizePeriod` | conclusion: \\(\le N\\) |

The proof follows in the file, and Lean rejects the file unless every step checks. `sorry` would mark a gap, and none of these files contain one. `#print axioms` lists what a proof rests on, and here it is only Lean's standard axioms.

## TCP and HTTP

<div class="box definition" markdown="1">
<p class="box-label">Model · two layers as Bunge systems</p>

Each layer is a system with composition \\(C\\). A set \\(S\\) is organized when two distinct members are bonded:

$$
\mathrm{Org}(S) \iff \exists\, a, b \in S,\; a \neq b \;\wedge\; \mathrm{Bonded}(a, b)
$$

Composition joins disjoint layers that share at least one bond: \\(C_{\mathrm{HTTP}} \cap C_{\mathrm{TCP}} = \varnothing\\), and the HTTP client hands data to the TCP sender.
</div>

<div class="box theorem" markdown="1">
<p class="box-label">Theorem · the stack is organized · <span class="badge proved">Proved</span></p>

$$
\mathrm{Org}\big(C_{\mathrm{HTTP}} \cup C_{\mathrm{TCP}}\big)
$$

<p class="in-words">Two layers joined by one bond compose into a system, not a heap.</p>

<details markdown="1">
<summary>In Lean</summary>

```lean
theorem stack_organized : IsOrganized stack.composition
```

Source: [TCPIP.lean](https://github.com/halcyonic-systems/protocols-are-systems/blob/main/lean/Protocols/TCPIP.lean)
</details>

<p class="in-words"><strong>Model limits.</strong> Each layer is modeled as closed, with no network environment. This is Bunge's composition of two systems, not composition of arrows.</p>
</div>

## Bitcoin

<div class="box definition" markdown="1">
<p class="box-label">Model · difficulty retarget as a homeostat</p>

The state is the inter-block time \\(s \in \mathbb{Z}\\), in minutes, with set point \\(10\\). The sensor reads \\(s\\), the error is \\(s - 10\\), and the correction subtracts the error:

$$
\varphi(s) = s - (s - 10)
$$

</div>

<div class="box theorem" markdown="1">
<p class="box-label">Theorem · the target is a fixed point · <span class="badge proved">Proved</span></p>

$$
\varphi(10) = 10
$$

<p class="in-words">At the 10-minute target, the retarget rule leaves the interval where it is.</p>

<details markdown="1">
<summary>In Lean</summary>

```lean
def difficultyHomeostat : Homeostat ℤ ℤ where
  setPoint := 10
  sensor := id
  error := fun observed target => observed - target
  correct := fun err interval => interval - err

theorem difficulty_target_is_equilibrium :
    IsEquilibrium difficultyHomeostat.feedbackLaw 10
```

Source: [Bitcoin.lean](https://github.com/halcyonic-systems/protocols-are-systems/blob/main/lean/Protocols/Bitcoin.lean)
</details>

<p class="in-words"><strong>Model limits.</strong> An idealized one-step model of the 2016-block retarget. As written, \(\varphi\) returns 10 from any state, so the result is about the homeostat's structure, not Bitcoin's real dynamics. The real rule adjusts difficulty multiplicatively over a 2016-block window.</p>
</div>

## Build

```
cd lean
lake exe cache get
lake build
```

The proofs depend on systems-science-foundations at commit `7efa91b`, pinned in `lean/lakefile.lean`. Built from a clean checkout on 2026-10-02. `#print axioms` shows the three theorems use only Lean's standard axioms (`propext`, `Quot.sound`, `Classical.choice`).
