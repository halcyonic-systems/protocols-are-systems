import Lake
open Lake DSL

package «protocols-are-systems» where
  leanOptions := #[
    ⟨`autoImplicit, false⟩
  ]

-- The verified systems core. Transitively pulls Mathlib (SSF requires it).
--
-- PINNED, and it has to stay pinned. Unpinned, this tracked whatever SSF main
-- happened to be, so an upstream change silently broke two of the three models:
-- SSF added the required field `interfaces_carry_flow` to MobusSystem on
-- 2026-07-25 and HandWashing and Bitcoin stopped compiling, while their headers
-- still advertised a green build from 2026-06-09. Nothing announced it because
-- nothing was pinned and lake-manifest.json was untracked.
--
-- Moving the pin is a deliberate act: bump the rev, rebuild all three models,
-- and only then update any claim about them.
require «systems-ontology» from git
  "https://github.com/halcyonic-systems/systems-science-foundations.git" @
  "7efa91b57f7fc3503d21328be50c1b734d43c1ba"

@[default_target]
lean_lib «Protocols» where
  srcDir := "."
  roots := #[`Protocols]
