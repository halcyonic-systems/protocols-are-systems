---
layout: default
title: Protocols are systems
---

# Protocols are systems

<p class="subtitle">A protocol is a relation over roles, so a protocol is where a system's systemhood lives.</p>

<p class="links">
<a href="{{ '/blueprint/' | relative_url }}">Blueprint</a><span class="sep">|</span><a href="{{ '/blueprint.pdf' | relative_url }}">PDF</a><span class="sep">|</span><a href="{{ '/blueprint/dep_graph_document.html' | relative_url }}">Dependency graph</a><span class="sep">|</span><a href="https://github.com/halcyonic-systems/protocols-are-systems">Lean source</a><span class="sep">|</span><a href="{{ '/questions/' | relative_url }}">Questions</a><span class="sep">|</span><a href="{{ '/talk/' | relative_url }}">Talk</a>
</p>

<figure>
<svg viewBox="0 0 300 70" role="img" aria-label="R, an arrow labeled is defined over, T">
  <text x="30" y="44" text-anchor="middle" font-family="Computer Modern Serif, serif" font-style="italic" font-size="24" fill="#1b1b1b">R</text>
  <line x1="52" y1="37" x2="240" y2="37" stroke="#1b1b1b" stroke-width="1"/>
  <polyline points="232,32 241,37 232,42" fill="none" stroke="#1b1b1b" stroke-width="1"/>
  <text x="146" y="27" text-anchor="middle" font-family="Computer Modern Serif, serif" font-size="13" fill="#6b6b6b">is defined over</text>
  <text x="264" y="44" text-anchor="middle" font-family="Computer Modern Serif, serif" font-style="italic" font-size="24" fill="#1b1b1b">T</text>
</svg>
<figcaption>The one arrow shared by eight formal definitions of system.</figcaption>
</figure>

Klir defines a system as a set of things \\(T\\) and a relation \\(R \subseteq T \times T\\). The relation cannot be stated without the things, and that dependence is the one arrow every definition shares. A protocol is rules, and rules are relations, so a protocol is the part of a system where systemhood resides. This project states that claim precisely, proves what can be proved in Lean, and keeps the rest as open problems.

<p class="status">24 statements · 16 formalized in Lean · 6 open problems</p>

## Contents

- [Blueprint]({{ '/blueprint/' | relative_url }}). Definitions, theorems, and open problems, each linked to its Lean declaration. Also as a [PDF]({{ '/blueprint.pdf' | relative_url }}).
- [Dependency graph]({{ '/blueprint/dep_graph_document.html' | relative_url }}). What is proved, what is stated, and what is open.
- [Questions]({{ '/questions/' | relative_url }}). Questions raised at Protocol Symposium 2026 and at SIGFPT, with short answers.
- [Talk]({{ '/talk/' | relative_url }}). *Protocols are Systems*, Protocol Symposium 2026, September 24, 2026.

## Contributing

Discussion takes place in SIGFPT, the formal protocol theory group of the Protocol Institute. Issues and pull requests are welcome on [GitHub](https://github.com/halcyonic-systems/protocols-are-systems). The open problems in the blueprint are the natural places to start.

## Building

```
lake exe cache get && lake build
```

The Lean files depend on [systems-science-foundations](https://github.com/halcyonic-systems/systems-science-foundations), pinned in `lakefile.lean`. The blueprint is built with [leanblueprint](https://github.com/PatrickMassot/leanblueprint).

## Changelog

- 2026-10-05. Blueprint and dependency graph. The shared arrow is stated between the parts of a definition, \\(R \to T\\), not between things.
- 2026-10-02. Companion page for the SIGFPT session.
- 2026-09-24. Talk at Protocol Symposium 2026.

## How to cite

<p style="hyphens: none">Thornton, S. (2026). <em>Protocols are systems.</em> Halcyonic Systems. <a href="https://halcyonic.systems/protocols-are-systems/">halcyonic.systems/protocols-are-systems</a></p>
