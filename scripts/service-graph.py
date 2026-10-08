#!/usr/bin/env python3
"""Render the service graph of the compose file as Graphviz DOT.

Reads the resolved compose configuration as JSON on stdin, i.e.

    docker compose --profile '*' config --format json --no-interpolate \
      | scripts/service-graph.py | dot -Tpng -o images/service-graph.png

Solid edges are `depends_on` (labelled when the dependency must be healthy or
complete), dashed edges are connections configured through environment
variables (e.g. `BROWSER_URI=http://browser:3000`). Services that only start
with a profile are grouped by that profile.
"""

import json
import re
import sys

CONDITIONS = {
    "service_healthy": "healthy",
    "service_completed_successfully": "completed",
}


def quote(value):
    return '"' + str(value).replace('"', '\\"') + '"'


def main():
    services = json.load(sys.stdin)["services"]

    # a service can be addressed by its name, hostname or container name
    addresses = {}
    for name, service in services.items():
        for address in (name, service.get("hostname"), service.get("container_name")):
            if address:
                addresses[address] = name
    # an address in host position: `scheme://host`, `user@host` or a bare `host:port`
    # (a bare `host` on its own is too ambiguous, i.e. `MINIO_ROOT_USER=loki`)
    hosts = "|".join(sorted(map(re.escape, addresses), key=len, reverse=True))
    address_pattern = re.compile(rf"(?://|@)({hosts})(?=:\d|/|$)|^({hosts})(?=:\d)")

    edges = {}
    for name, service in services.items():
        for dependency, details in (service.get("depends_on") or {}).items():
            edges[(name, dependency)] = CONDITIONS.get((details or {}).get("condition"))

        environment = service.get("environment") or {}
        if isinstance(environment, dict):
            values = environment.values()
        else:
            values = [entry.partition("=")[2] for entry in environment]
        for value in values:
            for match in address_pattern.finditer(str(value or "")):
                target = addresses[match.group(1) or match.group(2)]
                if target != name and (name, target) not in edges:
                    edges[(name, target)] = "env"

    groups = {}
    for name, service in services.items():
        profiles = service.get("profiles") or []
        groups.setdefault(profiles[0] if profiles else None, []).append(name)

    lines = [
        "digraph services {",
        '  graph [rankdir=LR, fontname="Helvetica", nodesep=0.3, ranksep=0.8];',
        '  node [shape=box, style="rounded,filled", fillcolor="#eef3fb", fontname="Helvetica"];',
        '  edge [color="#55657a", fontname="Helvetica", fontsize=9];',
    ]
    for profile, names in sorted(groups.items(), key=lambda item: item[0] or ""):
        indent = "  "
        if profile:
            lines.append(f"  subgraph {quote('cluster_' + profile)} {{")
            lines.append(f'    label={quote("profile: " + profile)}; style="rounded,dashed"; color="#9aa7b8";')
            indent = "    "
        lines.extend(f"{indent}{quote(name)};" for name in sorted(names))
        if profile:
            lines.append("  }")

    for (source, target), kind in sorted(edges.items()):
        if kind == "env":
            attributes = ' [style=dashed, color="#9aa7b8"]'
        elif kind:
            attributes = f" [label={quote(kind)}]"
        else:
            attributes = ""
        lines.append(f"  {quote(source)} -> {quote(target)}{attributes};")

    lines.append("}")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
