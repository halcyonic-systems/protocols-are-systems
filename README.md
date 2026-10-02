# Protocols are systems

This is the companion to *Protocols are Systems: Implications for a Grand Unified Protocol Modeling Theory*, a talk Shingai Thornton gave at Protocol Symposium 2026 on September 24, 2026, in response to the Protocol Institute's Grand Challenge 55.

- Slides: [slides.pdf](slides.pdf), 21 slides
- Lean proofs of the three protocol results: [lean/](REPO/tree/main/lean)
- The systems core these results build on: [systems-science-foundations](https://github.com/halcyonic-systems/systems-science-foundations)

In this work an arrow always means "depends on."

## The argument

1. Klir defines a system as things and the relations between them, S = (T, R). A protocol is a set of participants (T) and a set of rules that constrain them (R). So a protocol is a system in Klir's sense.
2. Hand washing, modeled three ways, shows what each definition adds. Klir gives things and relations. Bunge adds inside, outside, and a mechanism. Mobus adds a boundary, flows, a history, and a clock.
3. Eight formal definitions of "system" all contain one dependency arrow.
4. A state machine, a process calculus, a temporal logic, and a Petri net can each be drawn over the same four-state hand-washing skeleton. This is a sketch, not a proof.
5. Three protocols are formalized in Lean, with one theorem each.
6. Nostr fits the same model without changes, and drawing its dependencies shows where its hardness lives.

## What is proved, and where

| Claim | Status | Source |
|---|---|---|
| The two-object arrow embeds into each of eight definitions (Klir, Bunge, Mobus, Mesarović, Wymore, Myers, Joslyn, Spivak), injective on objects. | Proved | [Challenge.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Challenge.lean), `klirTo*_obj_injective` |
| Any connected pattern that embeds in both the Joslyn and the Willems shapes is exactly one arrow. This holds relative to the encoded presentations. Willems serves as a witness and is not one of the eight. | Proved | [SharedPrimitive.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Category/SharedPrimitive.lean), `connected_is_single_arrow` |
| "Nothing larger is shared," when the definitions are compared as free categories. | False. A three-object fork embeds into all eight. | [Challenge.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Challenge.lean), `free_category_maximality_fails` |
| Hand washing: under the rule "wash every N contacts" (N = 3 in the model), a contamination counter that starts at or below N never exceeds N. The model is coarse (hands and the rule, against contact surfaces and microbes) and assumes the rule is followed. | Proved | [HandWashing.lean](REPO/blob/main/lean/Protocols/HandWashing.lean), `handwashing_contamination_bounded` |
| TCP and HTTP: two disjoint layers joined by one bond compose into an organized system. Each layer is modeled as closed. | Proved | [TCPIP.lean](REPO/blob/main/lean/Protocols/TCPIP.lean), `stack_organized` |
| Bitcoin: a 10-minute block interval is a fixed point of the difficulty feedback law. The model is an idealized one-step version of the 2016-block retarget. | Proved | [Bitcoin.lean](REPO/blob/main/lean/Protocols/Bitcoin.lean), `difficulty_target_is_equilibrium` |
| Four protocol formalisms share the hand-washing skeleton. | Sketch | [slides.pdf](slides.pdf), slide 13 |
| Nostr fits the model, and its hardness sits at a relay that keeps a copy. | Drawn, not formalized | [slides.pdf](slides.pdf), slide 17 |

## Questions from the session

**Can arrows go both ways directly, or is the return path mediated through something else?**

Neither is part of the shared core. A direct pair x → y → x and a mediated return x → y → z → x both contain two arrows in a row. The Willems shape has no two arrows in a row (`no_two_chain`), so neither pattern embeds there, and the shared core stays one arrow in one direction. Feedback is real. It enters with the richer definitions, for example Mobus's flow networks.

One definition demands the opposite. Rosen (1978), encoded separately from the eight, requires the dependency to be symmetric. A kernel in which something depends on another thing without the converse has no Rosen view (`rosen_no_view_of_asymmetric`, [ViewGeneration.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Klir/ViewGeneration.lean)).

**Can the richer formalisms, with time and environment, be built from the primitive?**

Partly, and that part is proved. [ViewGeneration.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Klir/ViewGeneration.lean) generates each tradition's view from the kernel: the things, the relations, and the dependency between them. Each generated view projects back to the same kernel, and distinct kernels give distinct views. Each view has a price:

- Klir: free.
- Bunge: at least one bonded pair of distinct things.
- Mobus: nothing depends on itself.
- Rosen: the dependency is an equivalence.

The generated views fill environment, external flows, boundary, history, and timescale with empty or trivial values. Time and environment are slots the kernel does not supply. Spivak's energy-driven view always exists but is provably static (`Kernel.toSpivak_static`, [SpivakSystem.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Klir/SpivakSystem.lean)), so motion needs value data from outside the kernel. Generating non-trivial time and environment content is open.

**Read as time, do two-way arrows raise questions of causality and simultaneity?**

Yes, under a temporal reading. Here an arrow is dependency, not temporal order. [ShapeWillems.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Category/ShapeWillems.lean) states it as "`dep_on` is predication, not causation." Time is a separate slot (Mobus's history and timescale).

**Where to start with Lean?**

[Challenge.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Challenge.lean) restates every headline claim with its full type, so a reader can check the result without reading the proofs. For learning Lean: [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/).

**Pointers from the session, not yet engaged**

- HyperLTL and hyperproperties, which state properties across runs and so can describe how a system or metasystem evolves.
- Milner's formalisms.
- Pebble automata.
- Wardley maps, with an evolution axis from emergence to ossification.
- International relations parallels: Klir and Wendt, Bunge and Gilpin, Mobus and Jervis.
- Notebooks that mix languages, as an analogy for handing work between formalisms.

## Open problems

1. Can hardness be measured across protocols, not only located?
2. Does the shared skeleton survive a fifth formalism?
3. Where does this model break on a protocol in real use?
4. Blygger replaces deletion with withdrawal and makes pins irrevocable. That is designed hardness, and a next instance to model.

## Build

```
cd lean
lake exe cache get
lake build
```

The proofs depend on systems-science-foundations at commit `7efa91b`, pinned in `lean/lakefile.lean`. Built from a clean checkout on 2026-10-02. `#print axioms` shows the three theorems use only Lean's standard axioms (`propext`, `Quot.sound`, `Classical.choice`).
