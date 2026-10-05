# Protocols are systems

What a protocol is, stated over formal definitions of system, with the proofs in Lean.

**Site:** https://halcyonic.systems/protocols-are-systems/

| Page | Source file |
|---|---|
| Home | [index.md](index.md) |
| The core: the precise statement | [core.md](core.md) |
| Instances: three protocol theorems | [instances.md](instances.md) |
| Questions from the sessions | [questions.md](questions.md) |
| Talk: Protocol Symposium 2026 | [talk.md](talk.md), [slides.pdf](slides.pdf) |

Lean sources are in [lean/](lean/). They build against [systems-science-foundations](https://github.com/halcyonic-systems/systems-science-foundations) at commit `7efa91b`:

```
cd lean
lake exe cache get
lake build
```

MIT license.
