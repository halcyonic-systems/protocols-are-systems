---
layout: default
title: Questions
description: Questions from Protocol Symposium 2026 and the October 2 SIGFPT session, with short answers and sources.
---

# Questions

From the symposium talk (September 24, 2026) and the SIGFPT session (October 2, 2026).

### Is a protocol just the rules?

> Yes. Rules are relations, and in Klir's definition the relation is where systemhood resides. A protocol defined over its participants forms a system.

See [The core]({{ '/core/' | relative_url }}#protocols). A protocol is a relation defined over a set of roles. Actual participants taking it up form what Walch calls a protocol system.

### Isn't Klir's relation more fundamental than a dependency?

> It is, and the shared arrow already says so. The arrow is not inside the relation. It runs from the relation to the things it is defined over.

Klir's relation may be directed, like an ordering, or symmetric, like a partition. The arrow every definition shares is one level up: a relation cannot be stated without its things. That arrow is the shape of Klir's own definition, and it is the shape that embeds into all eight. See [The core]({{ '/core/' | relative_url }}).

### Can arrows go both ways, directly or through something in between?

> Among things, yes: a relation may run both ways. Among the parts of a definition, the shared floor is one arrow in one direction.

<details markdown="1">
<summary>Details</summary>

Each definition has parts, such as Joslyn's controller, effector, and controlled variable, or Willems's time, signal, and behavior. A way back between two parts, direct or through a third, means following one arrow and then another. Willems's definition, as encoded, never has two arrows in a row (`no_two_chain`), so no way back fits inside it, and the floor shared by every definition stays one arrow (`connected_is_single_arrow`).

Two-way dependency between parts does appear in individual definitions. Joslyn's encoded shape has one: the effector acts on the controlled variable, and the controlled variable feeds back to the effector. It is not shared by every definition. This is a result about the definitions as encoded. Willems's interconnection layer, for one, is not encoded yet.

Rosen marks an outer edge. His 1978 definition relates states by whether every observable agrees on them, a relation that always runs both ways. A kernel whose relation has some pair without its converse has no Rosen view at all (`rosen_no_view_of_asymmetric`, [ViewGeneration.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Klir/ViewGeneration.lean)).

</details>

### Can time and environment be built from the primitive?

> The core can hold places for time and environment, but it cannot fill them.

*Derived from the core alone?* No. When the kernel generates a richer view, the time and environment slots come out empty, and the generated energy view is provably static. Real time and real environment are content supplied from outside.

*Represented as parts of a definition?* Yes. Willems encodes time as a part that behavior depends on (`indexed_by`, [ShapeWillems.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Category/ShapeWillems.lean)). Bunge and Mobus each give environment its own part of the definition, the E in their tuples.

<details markdown="1">
<summary>Details</summary>

[ViewGeneration.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Klir/ViewGeneration.lean) generates each tradition's view from the kernel: the things, the relation, and the arrow between them. Each generated view projects back to the same kernel, and distinct kernels give distinct views. Each view has a price:

- Klir: free.
- Bunge: at least one bonded pair of distinct things.
- Mobus: no thing is related to itself.
- Rosen: the relation is an equivalence.

The generated views fill environment, external flows, boundary, history, and timescale with empty or trivial values. Spivak's energy-driven view always exists but is provably static (`Kernel.toSpivak_static`, [SpivakSystem.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Klir/SpivakSystem.lean)), so motion needs value data from outside the kernel. Generating non-trivial time and environment content is open.

</details>

### Where do dynamics enter?

> Not at the floor. Relational structure alone is static. Bunge's mechanism and Mobus's transformations, history, and timescale carry the dynamics.

The kernel's generated energy view is provably static (`Kernel.toSpivak_static`). Bunge's mechanism (the M in his system tuple) and Mobus's transformation, history (H), and timescale (Δt) are where change enters.

### What about emergence?

> Not yet engaged here. Bunge gives a set-theoretic definition.

Bunge, *Treatise on Basic Philosophy*, vol. 4 (1979), chapter 1, Definitions 1.13 and 1.14: the properties a thing gains over an interval are emergent relative to it, and absolutely emergent if no thing had them before. Whether the core can state emergence without building it in is open.

### On reading arrows as time

> Here an arrow means "depends on," not "comes before."

Read as temporal links, two-way arrows raise hard questions of causality and simultaneity. [ShapeWillems.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Category/ShapeWillems.lean) states the convention as "`dep_on` is predication, not causation." Time is a separate part (Mobus's history and timescale).

### Where to start with Lean?

> Read [Challenge.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Challenge.lean). It states every claim without the proofs.

Each headline claim appears there with its full type, so a reader can check the result without reading the proofs. For learning Lean: [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/). The [Instances]({{ '/instances/' | relative_url }}) page walks through reading one theorem.

### Pointers from the sessions, not yet engaged

- HyperLTL and hyperproperties, which state properties across runs and so can describe how a system or metasystem evolves.
- Milner's formalisms.
- Pebble automata.
- Wardley maps, with an evolution axis from emergence to ossification.
- International relations parallels: Klir and Wendt, Bunge and Gilpin, Mobus and Jervis.
- Notebooks that mix languages, as an analogy for handing work between formalisms.
- A model's descriptive, computational, and prescriptive powers, as three separate tests.
