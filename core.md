---
layout: default
title: The core
description: The precise statement. A system's relation is defined over its things, and a protocol is the rules, where systemhood lives.
---

# The core

> A system's relation is defined over its things. A protocol is the rules, so a protocol is where a system's systemhood lives.

<figure>
<svg viewBox="0 0 360 100" role="img" aria-label="relation, arrow, things, labeled is defined over">
  <circle cx="60" cy="40" r="9" fill="#f0f4f8" stroke="#6366f1" stroke-width="3"/>
  <circle cx="300" cy="40" r="9" fill="#f0f4f8" stroke="#6366f1" stroke-width="3"/>
  <line x1="73" y1="40" x2="277" y2="40" stroke="#6366f1" stroke-width="2.5"/>
  <polygon points="277,33 289,40 277,47" fill="#6366f1"/>
  <text x="180" y="28" text-anchor="middle" font-family="Inter, sans-serif" font-size="13" fill="#1e293b">is defined over</text>
  <text x="60" y="80" text-anchor="middle" font-family="Inter, sans-serif" font-size="14" fill="#1e293b">relation (R)</text>
  <text x="300" y="80" text-anchor="middle" font-family="Inter, sans-serif" font-size="14" fill="#1e293b">things (T)</text>
</svg>
<figcaption>The shape of Klir's definition S = (T, R), as encoded in <a href="https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Category/ShapeKlir.lean">ShapeKlir.lean</a>.</figcaption>
</figure>

## The arrow runs between the parts of a definition

Klir defines a system as S = (T, R), a set of things and a relation on them. The arrow in the figure does not connect two things. It connects the two parts of the definition: the relation depends on the things, because the relation is defined over them.

In set theory, a relation on T is a subset of T × T, a set of pairs of things. It cannot be stated without saying which T it is on. In graph theory, an edge is a pair of vertices. No vertices, no edges.

The dependence concerns what a relation is defined over, not how many things exist. The empty set carries a relation too, the empty one.

## Klir's own words

From *Facets of Systems Science* (2001), page 5:

> S = (T, R), (1.1) where S, T, R denote, respectively, a system, a set of things distinguished within S, and a relation (or, possibly, a set of relations) defined on T. Clearly, the thinghood and systemhood properties of S reside in T and R, respectively.

The relation is what makes a set of things a system. Klir's examples on the same page show that the relation can take either form:

- Ordering books by author gives a system, "since any ordering of a set is a relation defined on the set." An ordering runs one way.
- Partitioning books by subject gives a system, "since every partition of a set emerges from a particular equivalence relation defined on the set." An equivalence runs both ways.

So the relation among things may be directed or symmetric. The arrow that every definition shares sits one level up, between the relation and the things.

## Protocols

A protocol is the rules. Rules are relations, so a protocol is the part of a system where systemhood resides.

Rules are always defined over some things, but those things can be kinds or roles rather than particular participants. The TCP specification exists whether or not any host runs it, and its rules are stated over a sender, a receiver, and segments. So a protocol is a relation defined over a set of roles.

When actual participants take up a protocol, the result is what Walch calls a protocol system:

> I think of protocols as oughts and of protocol systems as at least two people engaging with a protocol.

Angela Walch, *The Fundamentals of Protocol Systems* (2023), page 3. In computing terms, this is the difference between a specification and the system that runs it.

## What is proved

| Claim | Status | Source |
|---|---|---|
| Klir's shape (two parts, one arrow) embeds into each of eight definitions: Klir, Bunge, Mobus, Mesarović, Wymore, Myers, Joslyn, Spivak. Injective on objects. | Proved | [Challenge.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Challenge.lean), `klirTo*_obj_injective` |
| The only dependency that every encoded definition directly asserts is one arrow. Quiver level, relative to the encodings, forced by the Joslyn and Willems shapes. | Proved | [SharedPrimitive.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Category/SharedPrimitive.lean), `connected_is_single_arrow` |
| "Nothing larger is shared," when definitions are compared as free categories. | False | [Challenge.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Challenge.lean), `free_category_maximality_fails` |

The arrow is the same for a constructivist definition (Klir), a realist one (Bunge), and a perspectivist one (Mobus). It is a fact about how each definition is built, not about whether systems exist apart from an observer.

## What the core cannot do

It holds places for time and environment but cannot fill them. When the kernel generates a richer definition's view, the environment, flow, boundary, history, and timescale slots come out empty ([ViewGeneration.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Klir/ViewGeneration.lean)). The energy-driven view it generates is provably static (`Kernel.toSpivak_static`, [SpivakSystem.lean](https://github.com/halcyonic-systems/systems-science-foundations/blob/main/Systems/Klir/SpivakSystem.lean)). Dynamics come from the richer definitions: Bunge's mechanism, and Mobus's transformations, history, and timescale.

## A correction on the record

The symposium talk illustrated the shared arrow with examples between things, such as a packet and its acknowledgment. The proved statement concerns the parts of a definition. A question at the October 2 SIGFPT session prompted this sharper statement.
