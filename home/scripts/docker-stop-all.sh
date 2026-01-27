#!/usr/bin/env bash

# Alle laufenden Docker Compose Projekte stoppen
# Verwendet: docker compose ls -q um Projektnamen zu ermitteln

projects=$(docker compose ls -q)

if [ -z "$projects" ]; then
    echo "Keine laufenden Docker Compose Projekte gefunden."
    exit 0
fi

echo "Stoppe folgende Projekte:"
echo "$projects"
echo ""

for project in $projects; do
    echo "→ Stoppe: $project"
    docker compose -p "$project" kill
    docker compose -p "$project" down
done

echo ""
echo "✓ Alle Projekte gestoppt."
