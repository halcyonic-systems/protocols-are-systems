# Protocols are systems

A protocol is a relation over roles, so a protocol is where a system's systemhood lives.

**Site:** https://halcyonic.systems/protocols-are-systems/

- `blueprint/src/content.tex`: the blueprint (definitions, theorems, open problems), built with [leanblueprint](https://github.com/PatrickMassot/leanblueprint).
- `Protocols/`: Lean formalizations of three protocol instances, against [systems-science-foundations](https://github.com/halcyonic-systems/systems-science-foundations).
- `index.md`, `questions.md`, `talk.md`: the site pages.

```
lake exe cache get && lake build      # Lean
scripts/build-site.sh                 # blueprint, PDF, declaration map, site
```

MIT license.
