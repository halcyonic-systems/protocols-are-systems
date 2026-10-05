/-
  Protocols/Bitcoin.lean
  Bitcoin difficulty adjustment formalized under Klir, Bunge, and Mobus.

  Verified 2026-08-05 against systems-science-foundations at the rev pinned in
  lakefile.lean: `lake build Protocols.Bitcoin` green, zero `sorry`, and no
  axioms beyond Lean's standard three (`propext`, `Quot.sound`,
  `Classical.choice`). Not axiom-free — checked, not assumed.

  This header previously claimed a green build dated 2026-06-09 and stayed
  unchanged while the file did not compile: SSF added the required field
  `interfaces_carry_flow` on 2026-07-25 and the dependency was unpinned. Any
  future claim here is only as good as the date beside it.

  The APQ ("Does the common core of systems also describe the common core of
  protocols?") proposes, at Step 4, that Bitcoin's difficulty-adjustment rule is
  a homeostat. This file makes that concrete: Bitcoin's consensus-control loop is
  built as a Mobus 8-tuple, projected onto the Bunge CES triple and the Klir
  walking arrow (the same commuting triangle as the thermostat), and its
  difficulty retarget is instantiated as a `Homeostat` whose target — the
  10-minute block interval — is proved to be a fixed point of the feedback law.

  The control loop mirrors Joslyn's thermostat exactly:
  - chain          (regulated variable)   ~ room
  - ledger         (sensor)               ~ thermometer
  - difficultyRule (controller)           ~ controller
  - miner          (actuator)             ~ furnace
  - network        (ambient milieu)       ~ outsideAir

  Modeling decisions:
  - Components C = {ledger, difficultyRule, miner}
  - Environment E = {chain, network}
  - Interfaces I = {ledger, miner}
  - chain is environment: the protocol acts ON the chain (miner appends blocks)
  - network is environment: propagation/latency is ambient (milieu)
  - Capacity κ = Unit (structural proofs don't depend on capacity)

  The homeostat is an idealized one-step model of the 2016-block retarget. The
  real rule adjusts difficulty multiplicatively by (actual interval / target)
  over a 2016-block window; we model the homeostatic STRUCTURE and prove the
  target is a fixed point, which is the structural claim Step 4 makes.
-/

import Systems.Klir.KlirSystem
import Systems.Core.Governance

namespace Bitcoin

open Systems

/-! ## Entity Type -/

inductive Entity where
  | ledger
  | difficultyRule
  | miner
  | chain
  | network
  deriving DecidableEq

open Entity

/-! ## Action Relation

  The difficulty-control loop: the chain's block history is read by the ledger,
  the ledger feeds the observed interval to the difficulty rule, the rule sets
  the miner's target, and the miner appends blocks back onto the chain. -/

instance entityActsOn : ActsOn Entity where
  actsOn
    | chain, ledger => True
    | ledger, difficultyRule => True
    | difficultyRule, miner => True
    | miner, chain => True
    | _, _ => False

/-! ## Shared Definitions -/

def comps : Set Entity := {ledger, difficultyRule, miner}
def envObjs : Set Entity := {chain, network}
def intfs : Set Entity := {ledger, miner}

/-! ## Internal Flow Network -/

def intEdges : Set (FlowEdge Entity Unit) :=
  fun e => (e.source = ledger ∧ e.target = difficultyRule ∧ e.capacity = ())
         ∨ (e.source = difficultyRule ∧ e.target = miner ∧ e.capacity = ())

def intNet : FlowNetwork Entity Unit where
  nodes := comps
  edges := intEdges
  edges_on := by
    intro e he
    rcases he with ⟨hs, ht, _⟩ | ⟨hs, ht, _⟩
    · constructor
      · rw [hs]; show ledger ∈ comps; left; rfl
      · rw [ht]; show difficultyRule ∈ comps; right; left; rfl
    · constructor
      · rw [hs]; show difficultyRule ∈ comps; right; left; rfl
      · rw [ht]; show miner ∈ comps; right; right; rfl
  no_self_loops := by
    intro e he
    rcases he with ⟨hs, ht, _⟩ | ⟨hs, ht, _⟩ <;> (rw [hs, ht]; decide)

/-! ## External Flow Network -/

def extEdges : Set (FlowEdge Entity Unit) :=
  fun e => (e.source = chain ∧ e.target = ledger ∧ e.capacity = ())
         ∨ (e.source = miner ∧ e.target = chain ∧ e.capacity = ())

def extNet : FlowNetwork Entity Unit where
  nodes := ({chain, ledger, miner} : Set Entity)
  edges := extEdges
  edges_on := by
    intro e he
    rcases he with ⟨hs, ht, _⟩ | ⟨hs, ht, _⟩
    · exact ⟨by rw [hs]; left; rfl,
             by rw [ht]; right; left; rfl⟩
    · exact ⟨by rw [hs]; right; right; rfl,
             by rw [ht]; left; rfl⟩
  no_self_loops := by
    intro e he
    rcases he with ⟨hs, ht, _⟩ | ⟨hs, ht, _⟩ <;> (rw [hs, ht]; decide)

/-! ## Helper: Disjointness -/

private theorem comps_envObjs_disjoint : comps ∩ envObjs = ∅ := by
  ext x
  simp only [Set.mem_inter_iff, Set.mem_empty_iff_false, iff_false, not_and]
  intro hc he
  unfold comps at hc; unfold envObjs at he
  rcases hc with rfl | rfl | rfl <;> (rcases he with h | h <;> exact nomatch h)

/-! ## Mobus 8-Tuple -/

def bitcoinMobus : MobusSystem Entity Unit Unit Unit Unit Unit Unit where
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
    rcases hx with rfl | rfl
    · left; rfl
    · right; right; rfl
  bipartite := by
    intro e he
    rcases he with ⟨hs, ht, _⟩ | ⟨hs, ht, _⟩
    · left
      exact ⟨by rw [hs]; show chain ∈ envObjs; left; rfl,
             by rw [ht]; show ledger ∈ intfs; left; rfl⟩
    · right
      exact ⟨by rw [hs]; show miner ∈ intfs; right; rfl,
             by rw [ht]; show chain ∈ envObjs; left; rfl⟩
  externalFlows_nodes := by
    intro x hx
    show x ∈ envObjs ∪ intfs
    rcases hx with rfl | rfl | rfl
    · left; left; rfl
    · right; left; rfl
    · right; right; rfl
  -- Both interfaces are endpoints of external flows: `ledger` receives the
  -- chain, `miner` emits to it. Required by SSF from 2026-07-25: a boundary may
  -- not declare an interface that transports nothing.
  interfaces_carry_flow := by
    intro i hi
    rcases hi with rfl | rfl
    · exact ⟨⟨chain, ledger, ()⟩, Or.inl ⟨rfl, rfl, rfl⟩, Or.inr rfl⟩
    · exact ⟨⟨miner, chain, ()⟩, Or.inr ⟨rfl, rfl, rfl⟩, Or.inl rfl⟩

/-! ## Flow-Action Consistency -/

theorem bitcoin_flow_induces_action :
    FlowInducesAction intNet := by
  intro e he
  show e.source ▷ e.target
  rcases he with ⟨hs, ht, _⟩ | ⟨hs, ht, _⟩ <;> (rw [hs, ht]; trivial)

theorem bitcoin_internal_nonempty :
    intNet.edges.Nonempty :=
  ⟨⟨ledger, difficultyRule, ()⟩, Or.inl ⟨rfl, rfl, rfl⟩⟩

/-! ## Klir and Bunge Systems (from Mobus projections) -/

def bitcoinBunge : ConcreteSystem Entity :=
  bitcoinMobus.toBunge
    bitcoin_flow_induces_action
    bitcoin_internal_nonempty

def bitcoinKlir : KlirSystem Entity :=
  bitcoinMobus.toKlir

/-! ## The Commuting Triangle on This Instance

  Both paths from the Mobus Bitcoin system to Klir produce definitionally
  identical systems — the same triangle proved for the thermostat, now on a
  protocol. This is "protocols are systems" made literal: a coordination
  protocol instantiated as a system, reducing to the walking arrow at the floor.

  ```
        toBunge
  Mobus -------→ Bunge
    \              |
     \  toKlir    | toKlir
      \           |
       ↘          ↓
         Klir
  ``` -/

theorem bitcoin_triangle_commutes :
    bitcoinBunge.toKlir = bitcoinKlir := rfl

/-! ## Differentiator: Difficulty Adjustment as a Homeostat

  The APQ's Step 4. State and observable are both the inter-block time
  (ℤ, in minutes): set point = the 10-minute target; sensor reads the interval;
  error = deviation from target; correction retargets toward the set point.

  Idealized one-step model of the 2016-block retarget — the real law adjusts
  difficulty multiplicatively by (actual / target) over a 2016-block window.
  We model the homeostatic STRUCTURE and prove the target is a fixed point. -/

def difficultyHomeostat : Homeostat ℤ ℤ where
  setPoint := 10
  sensor := id
  error := fun observed target => observed - target
  correct := fun err interval => interval - err

/-- The 10-minute target block interval is a fixed point of the difficulty
    feedback law: once the inter-block time is at target, the retarget rule
    leaves it there. This is governance-as-homeostat, demonstrated — the
    theorem the APQ's Step 4 promises, on a real protocol. -/
theorem difficulty_target_is_equilibrium :
    IsEquilibrium difficultyHomeostat.feedbackLaw 10 := by
  apply Homeostat.target_is_equilibrium
  · rfl
  · intro o; simp [difficultyHomeostat]
  · intro s; simp [difficultyHomeostat]

end Bitcoin
