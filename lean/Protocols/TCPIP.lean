/-
  Protocols/TCPIP.lean
  TCP + HTTP composition under the systems-science core.

  The APQ's Step 4 asks, alongside the Bitcoin homeostat: "does TCP + HTTP compose
  unconditionally?" This file answers it. HTTP and TCP are each built as a Bunge
  `ConcreteSystem`; the protocol stack is their composition under
  `ConcreteSystem.compose`, whose own FINDING is that the construction is
  unconditionally valid — the disjointness and interaction hypotheses add physical
  content (distinct, interacting layers) but are not needed for coherence. The
  composed stack is then proved to be an organized system: composition closes.

  This is the second inherited result, complementing Bitcoin's homeostat.
  Governance-as-homeostat (Bitcoin) and composition-that-closes (here) are two of
  the properties the APQ claims protocols inherit — each now a theorem.

  Minimal model: each layer is closed (environment = ∅), to keep the focus on the
  composition itself; a richer model would carry the network as environment.
-/

import Systems.Core.Systemness

namespace TCPIP

open Systems

/-! ## Entities: two protocol layers -/

inductive Entity where
  | httpClient
  | httpServer
  | tcpSender
  | tcpReceiver
  deriving DecidableEq

open Entity

/-! ## Action relation

  HTTP request within the application layer, TCP segment within the transport
  layer, and the cross-layer handoff (HTTP hands its request down to TCP) that
  makes the two layers interact. -/

instance entityActsOn : ActsOn Entity where
  actsOn
    | httpClient, httpServer => True   -- HTTP request
    | tcpSender, tcpReceiver => True   -- TCP segment
    | httpClient, tcpSender => True    -- application data handed down to transport
    | _, _ => False

/-! ## Layer compositions -/

def httpComp : Set Entity := {httpClient, httpServer}
def tcpComp : Set Entity := {tcpSender, tcpReceiver}

/-! ## HTTP as a ConcreteSystem -/

def http : ConcreteSystem Entity where
  composition := httpComp
  environment := ∅
  structure' := {(httpClient, httpServer)}
  disjoint := by simp
  structure_on := by
    intro p hp
    have hp' : p = (httpClient, httpServer) := hp
    subst hp'
    refine ⟨Or.inl ?_, Or.inl ?_⟩
    · left; rfl
    · right; rfl
  bondage_nonempty := by
    refine ⟨httpClient, ?_, httpServer, ?_, ?_, ?_⟩
    · left; rfl
    · right; rfl
    · decide
    · exact Or.inl trivial

/-! ## TCP as a ConcreteSystem -/

def tcp : ConcreteSystem Entity where
  composition := tcpComp
  environment := ∅
  structure' := {(tcpSender, tcpReceiver)}
  disjoint := by simp
  structure_on := by
    intro p hp
    have hp' : p = (tcpSender, tcpReceiver) := hp
    subst hp'
    refine ⟨Or.inl ?_, Or.inl ?_⟩
    · left; rfl
    · right; rfl
  bondage_nonempty := by
    refine ⟨tcpSender, ?_, tcpReceiver, ?_, ?_, ?_⟩
    · left; rfl
    · right; rfl
    · decide
    · exact Or.inl trivial

/-! ## The two layers are disjoint and they interact -/

theorem http_tcp_disjoint : http.composition ∩ tcp.composition = ∅ := by
  show httpComp ∩ tcpComp = ∅
  ext x
  simp only [Set.mem_inter_iff, Set.mem_empty_iff_false, iff_false, not_and]
  intro hc ht
  unfold httpComp at hc; unfold tcpComp at ht
  rcases hc with rfl | rfl <;> (rcases ht with h | h <;> exact nomatch h)

theorem http_tcp_interact :
    ∃ a ∈ http.composition, ∃ b ∈ tcp.composition, Bonded a b :=
  ⟨httpClient, by left; rfl, tcpSender, by left; rfl, Or.inl trivial⟩

/-! ## The protocol stack: TCP + HTTP composed -/

def stack : ConcreteSystem Entity :=
  http.compose tcp http_tcp_disjoint http_tcp_interact

/-! ## Composition closes: the stack is an organized system

  This is the differentiator for this instance — the analog of Bitcoin's
  homeostat fixed point. Two protocol layers, composed, yield again a valid
  organized system, with no compatibility precondition. -/

theorem stack_organized : IsOrganized stack.composition :=
  ConcreteSystem.compose_organized http tcp http_tcp_disjoint http_tcp_interact

/-- Both layers live in the composed stack. -/
theorem http_in_stack : http.composition ⊆ stack.composition :=
  ConcreteSystem.compose_contains_left http_tcp_disjoint http_tcp_interact

theorem tcp_in_stack : tcp.composition ⊆ stack.composition :=
  ConcreteSystem.compose_contains_right http_tcp_disjoint http_tcp_interact

end TCPIP
