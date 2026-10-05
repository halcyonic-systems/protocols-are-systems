"""Map Lean declaration names to GitHub source lines for the blueprint's Lean links."""
import json, re, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SSF_DIR = Path.home() / "Desktop/halcyonic-projects/active/systems-science-foundations"
SSF_REF = "origin/main"
DECL = re.compile(r"^(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+)*"
                  r"(theorem|lemma|def|abbrev|structure|inductive|class|instance)\s+([^\s:({\[]+)")


def scan(text):
    ns, out = [], {}
    for i, line in enumerate(text.splitlines(), 1):
        if m := re.match(r"^namespace\s+(\S+)", line):
            ns.append(m.group(1))
        elif re.match(r"^end\s+\S+", line) and ns:
            ns.pop()
        elif m := DECL.match(line):
            name = ".".join(ns + [m.group(2)])
            out.setdefault(name, i)
    return out


def ssf_files():
    sha = subprocess.check_output(["git", "-C", SSF_DIR, "rev-parse", SSF_REF], text=True).strip()
    paths = subprocess.check_output(
        ["git", "-C", SSF_DIR, "ls-tree", "-r", "--name-only", SSF_REF, "Systems"], text=True).split()
    for p in paths:
        if p.endswith(".lean"):
            yield p, subprocess.check_output(["git", "-C", SSF_DIR, "show", f"{sha}:{p}"], text=True), sha


decls = {}
for p, text, sha in ssf_files():
    for name, line in scan(text).items():
        decls[name] = f"https://github.com/halcyonic-systems/systems-science-foundations/blob/{sha}/{p}#L{line}"
for f in sorted((ROOT / "Protocols").glob("*.lean")):
    for name, line in scan(f.read_text()).items():
        decls[name] = f"https://github.com/halcyonic-systems/protocols-are-systems/blob/main/Protocols/{f.name}#L{line}"

(ROOT / "lean/find/decls.json").write_text(json.dumps(decls, indent=0, sort_keys=True))

wanted = (ROOT / "blueprint/lean_decls").read_text().split()
missing = [w for w in wanted if w not in decls]
print(f"{len(decls)} declarations mapped, {len(wanted)} cited in the blueprint, {len(missing)} missing")
for w in missing:
    print("  missing:", w)
sys.exit(1 if missing else 0)
