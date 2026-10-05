/-
  Protocols/HandWashing.lean
  Hand-washing formalized under Klir, Bunge, and Mobus.

  Verified 2026-08-05 against systems-science-foundations at the rev pinned in
  lakefile.lean: `lake build Protocols.HandWashing` green, zero `sorry`, and no
  axioms beyond Lean's standard three (`propext`, `Quot.sound`,
  `Classical.choice`). Not axiom-free — checked, not assumed.

  This header previously claimed a green build dated 2026-06-09 and stayed
  unchanged while the file did not compile: SSF added the required field
  `interfaces_carry_flow` on 2026-07-25 and the dependency was unpinned. Any
  future claim here is only as good as the date beside it.

  The APQ ("Does the common core of systems also describe the common core of
  protocols?") proposes that a hand-washing protocol is a situated agent
  exchanging mass and microbes across a boundary, with action-states tagged
  contaminating or sanitizing and a rule "sanitize every N steps." This file
  makes that concrete: the protocol is built as a Mobus 8-tuple, projected onto
  the Bunge CES triple and the Klir walking arrow (the same commuting triangle
  as the thermostat), and the every-N rule is proved to keep contamination
  bounded for all future steps.

  The third instance carries the third inherited property. Bitcoin demonstrates
  governance-as-homeostat (a fixed point); TCP/IP demonstrates composition that
  closes; this file demonstrates a safety/viability invariant: the regulated
  variable stays inside its viable region forever. This is Rao's
  "prophylactically stabilizable" property and the formal core of Walch's
  viability dynamics: the every-N sanitize rule renders the viable set
  forward-invariant.

  The situated agent mirrors Rao's worked example:
  - hands           (interface, the agent's boundary-crossing component)
  - sanitationRule  (controller, the every-N rule)
  - contactSurfaces (environment, source of inbound mass and microbes)
  - microbes        (environment, what washing sheds back across the boundary)

  Modeling decisions:
  - Components C = {hands, sanitationRule}
  - Environment E = {contactSurfaces, microbes}
  - Interfaces I = {hands}      (hands exchange mass across the boundary)
  - hands is the only interface: it is where the protocol acts ON its milieu
  - Capacity κ = Unit (structural proofs don't depend on capacity)

  The bonus lemma `handwashing_isOpen` records the boundary explicitly: the
  Bunge projection has a nonempty environment, so the system is open. Rao frames
  hand-washing as mass exchange across a boundary, and an open system is the
  formal acknowledgment of that exchange.
-/

import Systems.Klir.KlirSystem
import Systems.Core.Governance

namespace HandWashing

open Systems

/-! ## Entity Type -/

inductive Entity where
  | hands
  | sanitationRule
  | contactSurfaces
  | microbes
  deriving DecidableEq

open Entity

/-! ## Action Relation

  The contaminate-then-sanitize loop: contact surfaces deposit mass and microbes
  onto the hands, the sanitation rule drives the hands to wash, and washing sheds
  microbes back across the boundary into the environment. -/

instance entityActsOn : ActsOn Entity where
  actsOn
    | contactSurfaces, hands => True    -- inbound mass and microbes
    | sanitationRule, hands => True     -- the every-N rule drives the hands
    | hands, microbes => True           -- washing sheds microbes across boundary
    | _, _ => False

/-! ## Shared Definitions -/

def comps : Set Entity := {hands, sanitationRule}
def envObjs : Set Entity := {contactSurfaces, microbes}
def intfs : Set Entity := {hands}

/-! ## Internal Flow Network -/

def intEdges : Set (FlowEdge Entity Unit) :=
  fun e => e.source = sanitationRule ∧ e.target = hands ∧ e.capacity = ()

def intNet : FlowNetwork Entity Unit where
  nodes := comps
  edges := intEdges
  edges_on := by
    intro e he
    obtain ⟨hs, ht, _⟩ := he
    constructor
    · rw [hs]; show sanitationRule ∈ comps; right; rfl
    · rw [ht]; show hands ∈ comps; left; rfl
  no_self_loops := by
    intro e he
    obtain ⟨hs, ht, _⟩ := he
    rw [hs, ht]; decide

/-! ## External Flow Network -/

def extEdges : Set (FlowEdge Entity Unit) :=
  fun e => (e.source = contactSurfaces ∧ e.target = hands ∧ e.capacity = ())
         ∨ (e.source = hands ∧ e.target = microbes ∧ e.capacity = ())

def extNet : FlowNetwork Entity Unit where
  nodes := ({contactSurfaces, hands, microbes} : Set Entity)
  edges := extEdges
  edges_on := by
    intro e he
    rcases he with ⟨hs, ht, _⟩ | ⟨hs, ht, _⟩
    · exact ⟨by rw [hs]; left; rfl,
             by rw [ht]; right; left; rfl⟩
    · exact ⟨by rw [hs]; right; left; rfl,
             by rw [ht]; right; right; rfl⟩
  no_self_loops := by
    intro e he
    rcases he with ⟨hs, ht, _⟩ | ⟨hs, ht, _⟩ <;> (rw [hs, ht]; decide)

/-! ## Helper: Disjointness -/

private theorem comps_envObjs_disjoint : comps ∩ envObjs = ∅ := by
  ext x
  simp only [Set.mem_inter_iff, Set.mem_empty_iff_false, iff_false, not_and]
  intro hc he
  unfold comps at hc; unfold envObjs at he
  rcases hc with rfl | rfl <;> (rcases he with h | h <;> exact nomatch h)

/-! ## Mobus 8-Tuple -/

def handWashingMobus : MobusSystem Entity Unit Unit Unit Unit Unit Unit where
  components := comps
  internalNetwork := intNet
  environment := ⟨envObjs, ()⟩
  externalFlows := extNet
  boundary := ⟨(), intfs⟩
  transforms := ()
  history := ()
  timeScale := ()
  network_components := rfl
  disjoint := comps_envObjs_disjoint
  interfaces_sub := by
    intro x hx
    show x ∈ comps
    rcases hx with rfl
    left; rfl
  bipartite := by
    intro e he
    rcases he with ⟨hs, ht, _⟩ | ⟨hs, ht, _⟩
    · left
      exact ⟨by rw [hs]; show contactSurfaces ∈ envObjs; left; rfl,
             by rw [ht]; show hands ∈ intfs; rfl⟩
    · right
      exact ⟨by rw [hs]; show hands ∈ intfs; rfl,
             by rw [ht]; show microbes ∈ envObjs; right; rfl⟩
  externalFlows_nodes := by
    intro x hx
    show x ∈ envObjs ∪ intfs
    rcases hx with rfl | rfl | rfl
    · left; left; rfl
    · right; rfl
    · left; right; rfl
  -- The sole interface, `hands`, is the target of the contact edge. Required by
  -- SSF from 2026-07-25: a boundary may not declare an interface that
  -- transports nothing.
  interfaces_carry_flow := by
    intro i hi
    rcases hi with rfl
    exact ⟨⟨contactSurfaces, hands, ()⟩, Or.inl ⟨rfl, rfl, rfl⟩, Or.inr rfl⟩

/-! ## Flow-Action Consistency -/

theorem handwashing_flow_induces_action :
    FlowInducesAction intNet := by
  intro e he
  show e.source ▷ e.target
  obtain ⟨hs, ht, _⟩ := he
  rw [hs, ht]; trivial

theorem handwashing_internal_nonempty :
    intNet.edges.Nonempty :=
  ⟨⟨sanitationRule, hands, ()⟩, ⟨rfl, rfl, rfl⟩⟩

/-! ## Klir and Bunge Systems (from Mobus projections) -/

def handWashingBunge : ConcreteSystem Entity :=
  handWashingMobus.toBunge
    handwashing_flow_induces_action
    handwashing_internal_nonempty

def handWashingKlir : KlirSystem Entity :=
  handWashingMobus.toKlir

/-! ## The Commuting Triangle on This Instance

  Both paths from the Mobus hand-washing system to Klir produce definitionally
  identical systems, the same triangle proved for the thermostat, now on a
  prophylactic protocol. This is "protocols are systems" made literal: a
  hygiene protocol instantiated as a system, reducing to the walking arrow at
  the floor.

  ```
        toBunge
  Mobus -------→ Bunge
    \              |
     \  toKlir    | toKlir
      \           |
       ↘          ↓
         Klir
  ``` -/

theorem handwashing_triangle_commutes :
    handWashingBunge.toKlir = handWashingKlir := rfl

/-! ## Bonus: The Protocol is an Open System

  Rao frames hand-washing as mass exchange across a boundary. The Bunge
  projection has a nonempty environment (contact surfaces and microbes), so the
  system is open in Bunge's sense (Def 1.3). This lemma is the formal
  acknowledgment of the boundary exchange. -/

theorem handwashing_isOpen : handWashingBunge.isOpen := by
  intro hclosed
  have hmem : contactSurfaces ∈ handWashingBunge.environment := by
    show contactSurfaces ∈ envObjs; left; rfl
  unfold ConcreteSystem.isClosed at hclosed
  rw [hclosed] at hmem
  exact absurd hmem (Set.notMem_empty _)

/-! ## Differentiator: The Every-N Rule Keeps Contamination Bounded

  This instance's distinguishing theorem is a safety/viability invariant,
  distinct from Bitcoin's homeostat fixed point and TCP/IP's composition.

  Model the regulated variable as contamination ∈ ℕ, the number of contacts
  since the last wash. Each contact increments it; the sanitation rule resets it
  to zero once it would reach the period. The viable region is {c | c ≤ period}.

  The claim, Rao's "prophylactically stabilizable" property and the formal core
  of Walch's viability dynamics: starting anywhere in the viable region,
  contamination never exceeds the period for any number of steps. The viable set
  is forward-invariant under the every-N rule. -/

/-- The sanitize period N: the rule washes once contamination would reach N. -/
def sanitizePeriod : ℕ := 3

/-- One tick of the protocol: a contact increments contamination, but the
    every-N rule resets it to zero once it would reach the period. -/
def contaminationStep (c : ℕ) : ℕ :=
  if c + 1 ≥ sanitizePeriod then 0 else c + 1

/-- One-step safety: a single tick never pushes contamination past the period.
    Either the rule fires and contamination resets to zero, or contamination
    increments but stays below the period. -/
theorem contaminationStep_le (c : ℕ) :
    contaminationStep c ≤ sanitizePeriod := by
  unfold contaminationStep
  split
  · exact Nat.zero_le _
  · omega

/-- The safety invariant: starting anywhere in the viable region (contamination
    at most the period), the every-N rule keeps contamination at most the period
    for any number of steps. The viable set is forward-invariant. This is the
    bounded-safety theorem the APQ promises, on a prophylactic protocol. -/
theorem handwashing_contamination_bounded (n c : ℕ)
    (hsafe : c ≤ sanitizePeriod) :
    contaminationStep^[n] c ≤ sanitizePeriod := by
  induction n generalizing c with
  | zero => simpa using hsafe
  | succ k ih =>
    rw [Function.iterate_succ_apply]
    exact ih (contaminationStep c) (contaminationStep_le c)

/-- Corollary: from clean hands (contamination zero), the protocol keeps
    contamination within the viable bound forever. -/
theorem handwashing_reachable_safe (n : ℕ) :
    contaminationStep^[n] 0 ≤ sanitizePeriod :=
  handwashing_contamination_bounded n 0 (Nat.zero_le _)

end HandWashing
