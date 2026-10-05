---
layout: default
title: The core
description: A system's relation is defined over its things. A protocol is the rules, so it is where systemhood lives.
---

# The core

<div class="box definition" markdown="1">
<p class="box-label">Definition 1 · System (Klir 2001, eq. 1.1)</p>

$$
S = (T, R), \qquad R \subseteq T \times T
$$

\\(T\\) is a set of things. \\(R\\) is a relation on \\(T\\).
</div>

A relation on \\(T\\) is a set of pairs drawn from \\(T\\). It cannot be stated without \\(T\\). That dependence is the arrow every definition shares.

<div class="box definition" markdown="1">
<p class="box-label">Definition 2 · The shape of Klir's definition</p>

$$
\mathcal{I}_{\mathrm{Klir}} : \qquad R \xrightarrow{\ \text{is defined over}\ } T
$$

Two objects, one arrow. The arrow joins the two **parts of the definition**, not two things.
</div>

<details markdown="1">
<summary>In Lean (ShapeKlir.lean)</summary>

```lean
inductive KlirPosition
  | things
  | relation

inductive KlirArrow : KlirPosition → KlirPosition → Type
  | relation_on_things : KlirArrow .relation .things
```

Source: [ShapeKlir.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Category/ShapeKlir.lean)
</details>

<div class="box remark" markdown="1">
<p class="box-label">Remark · two levels</p>

Among things, \\(R\\) can run either way. Among the parts of the definition, there is one arrow, \\(R \to T\\). The dependence concerns what \\(R\\) is defined over, not how many things exist: \\(\varnothing \subseteq T \times T\\) is a relation too.
</div>

<div class="box source" markdown="1">
<p class="box-label">Source · Klir, Facets of Systems Science (2001), p. 5</p>

"S, T, R denote, respectively, a system, a set of things distinguished within S, and a relation (or, possibly, a set of relations) defined on T. Clearly, the thinghood and systemhood properties of S reside in T and R, respectively."
</div>

Klir's examples on the same page admit both kinds of relation:

| Klir's example | Relation | Direction |
|---|---|---|
| Books ordered by author | an ordering on \\(T\\) | one way |
| Books partitioned by subject | an equivalence relation on \\(T\\) | both ways: \\(aRb \Rightarrow bRa\\) |

## Protocols

<div class="box definition" markdown="1">
<p class="box-label">Working definition · Protocol (not formalized)</p>

A protocol is a relation \\(R\\) over a set of roles \\(T\\). A protocol system is a protocol taken up by participants.

$$
\begin{aligned}
\text{protocol} &= R \ \text{over roles } T \\
\text{protocol system} &= \text{protocol} + \text{participants}
\end{aligned}
$$

</div>

A protocol is the rules, and rules are relations. By Klir, systemhood resides in \\(R\\), so a protocol is where systemhood lives. The TCP specification is a relation over the roles sender, receiver, and segment. It exists whether or not any host runs it.

<div class="box source" markdown="1">
<p class="box-label">Source · Walch, The Fundamentals of Protocol Systems (2023), p. 3</p>

"I think of protocols as oughts and of protocol systems as at least two people engaging with a protocol."
</div>

## What is proved

<div class="box theorem" markdown="1">
<p class="box-label">Theorem 1 · Existence · <span class="badge proved">Proved</span></p>

For each of eight definitions \\(j\\) (Klir, Bunge, Mobus, Mesarović, Wymore, Myers, Joslyn, Spivak), there is an embedding

$$
F_j : \mathcal{I}_{\mathrm{Klir}} \longrightarrow \mathcal{I}_j \qquad \text{injective on objects.}
$$

<p class="in-words">The arrow \(R \to T\) sits inside every one of the eight.</p>

<details markdown="1">
<summary>In Lean (Challenge.lean)</summary>

```lean
theorem klirToBunge_obj_injective : Function.Injective klirToBungePre.obj
-- likewise for Mobus, Myers, Wymore, Mesarovic, Joslyn, Spivak, Willems
```

Source: [Challenge.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Challenge.lean)
</details>
</div>

<div class="box theorem" markdown="1">
<p class="box-label">Theorem 2 · Only one shared arrow · <span class="badge proved">Proved</span></p>

Let \\(V\\) be a connected quiver that embeds in both the Joslyn and the Willems shapes, with an edge \\(e : x \to y\\). Then

$$
x \neq y, \qquad V = \{x, y\}, \qquad \text{every edge of } V \text{ is } x \to y.
$$

<p class="in-words">The only dependency every encoded definition directly asserts is one arrow. Relative to the encodings. Willems is a witness, not one of the eight.</p>

<details markdown="1">
<summary>In Lean (Challenge.lean)</summary>

```lean
theorem connected_is_single_arrow {V : Type*} [Quiver V]
    (eJ : SharedPrimitive.QuiverEmbedding V JoslynPosition)
    (eW : SharedPrimitive.QuiverEmbedding V WillemsPosition)
    (conn : ∀ a b : V, SharedPrimitive.Zigzag a b) {x y : V} (e : x ⟶ y) :
    x ≠ y ∧ (∀ w : V, w = x ∨ w = y) ∧ ∀ (u v : V) (_ : u ⟶ v), u = x ∧ v = y
```

Source: [Challenge.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Challenge.lean)
</details>
</div>

<div class="box refuted" markdown="1">
<p class="box-label">Refuted · Nothing larger is shared · <span class="badge false">False</span></p>

Compared as free categories, the three-object fork \\(\bullet \leftarrow \bullet \rightarrow \bullet\\) embeds injectively and faithfully into all eight. So "nothing larger than one arrow is shared" fails at that level, because every path counts as a morphism.

<p class="in-words">Machine-checked counterexample: <code>free_category_maximality_fails</code>, <a href="https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Challenge.lean">Challenge.lean</a>.</p>
</div>

The arrow is the same for a constructivist definition (Klir), a realist one (Bunge), and a perspectivist one (Mobus). It is a fact about how each definition is built.

## What the core cannot do

<div class="box remark" markdown="1">
<p class="box-label">Limit · holds places, cannot fill them</p>

Generating a richer view from the core leaves environment, flows, boundary, history, and timescale empty ([ViewGeneration.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Klir/ViewGeneration.lean)). The generated energy view is provably static (`Kernel.toSpivak_static`, [SpivakSystem.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Klir/SpivakSystem.lean)). Dynamics come from the richer definitions: Bunge's mechanism, and Mobus's transformations, history, and timescale.
</div>

<div class="box remark" markdown="1">
<p class="box-label">Correction on the record</p>

The symposium talk drew the shared arrow between things, such as a packet and its acknowledgment. The proved statement is between the parts of a definition, \\(R \to T\\). A question at the October 2 SIGFPT session prompted this sharper statement.
</div>
