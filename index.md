---
layout: default
title: Protocols are systems
---

# Protocols are systems

A protocol is a set of rules. In formal definitions of system, rules are relations, and the relation is where a system's systemhood lives. Defined over its participants, a protocol forms a system. This site states that claim precisely, gives the proofs that support it in Lean, and records the questions it has met.

**Start here:** [The core]({{ '/core/' | relative_url }}).

## The argument

1. Klir defines a system as things and a relation on them, S = (T, R). A protocol is rules, and rules are relations. Defined over its participants, a protocol forms a system.
2. Hand washing, modeled three ways, shows what each definition adds. Klir gives things and relations. Bunge adds inside, outside, and a mechanism. Mobus adds a boundary, flows, a history, and a clock.
3. Eight formal definitions of system share one arrow: the relation is defined over the things.
4. A state machine, a process calculus, a temporal logic, and a Petri net can each be drawn over the same four-state hand-washing skeleton. This is a sketch, not a proof.
5. Three protocols are formalized in Lean, with one theorem each.
6. Nostr fits the same model without changes, and drawing its dependencies shows where its hardness lives.

## What is proved, and where

| Claim | Status | Model limits | Source |
|---|---|---|---|
| Klir's shape (relation defined over things) embeds into each of eight definitions: Klir, Bunge, Mobus, Mesarović, Wymore, Myers, Joslyn, Spivak. | Proved | Injective on objects. | [Challenge.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Challenge.lean), `klirTo*_obj_injective` |
| Any connected pattern that embeds in both the Joslyn and the Willems shapes is exactly one arrow. | Proved | Relative to the encoded presentations. Willems is a witness, not one of the eight. | [SharedPrimitive.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Category/SharedPrimitive.lean), `connected_is_single_arrow` |
| "Nothing larger is shared." | False | Fails when definitions are compared as free categories: a three-object fork embeds into all eight. | [Challenge.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Challenge.lean), `free_category_maximality_fails` |
| Hand washing: under "wash every N contacts," a counter starting at or below N never exceeds N. | Proved | N = 3. Coarse model (hands and the rule, against surfaces and microbes). Assumes the rule is followed. | [HandWashing.lean](https://github.com/halcyonic-systems/protocols-are-systems/blob/main/lean/Protocols/HandWashing.lean), `handwashing_contamination_bounded` |
| TCP and HTTP: two layers joined by one bond compose into an organized system. | Proved | Each layer modeled as closed. | [TCPIP.lean](https://github.com/halcyonic-systems/protocols-are-systems/blob/main/lean/Protocols/TCPIP.lean), `stack_organized` |
| Bitcoin: a 10-minute block interval is a fixed point of the difficulty feedback law. | Proved | Idealized one-step version of the 2016-block retarget. | [Bitcoin.lean](https://github.com/halcyonic-systems/protocols-are-systems/blob/main/lean/Protocols/Bitcoin.lean), `difficulty_target_is_equilibrium` |
| Four protocol formalisms share the hand-washing skeleton. | Sketch | Not formalized. | [Slides]({{ '/talk/' | relative_url }}), slide 13 |
| Nostr fits the model, and its hardness sits at a relay that keeps a copy. | Drawn | Not formalized. | [Slides]({{ '/talk/' | relative_url }}), slide 17 |

## Pages

- [The core]({{ '/core/' | relative_url }}): the precise statement, with sources.
- [Instances]({{ '/instances/' | relative_url }}): the three protocol theorems, how to read one, and how to build them.
- [Questions]({{ '/questions/' | relative_url }}): questions from the symposium and the October 2 SIGFPT session.
- [Talk]({{ '/talk/' | relative_url }}): the September 24, 2026 talk at Protocol Symposium 2026, which responds to the Protocol Institute's Grand Challenge 55.

## Open problems

1. Can hardness be measured across protocols, not only located?
2. Does the shared skeleton survive a fifth formalism?
3. Where does this model break on a protocol in real use?
4. Blygger replaces deletion with withdrawal and makes pins irrevocable. That is designed hardness, and a next instance to model.
