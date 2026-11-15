"""Lee el Project 1 de GitHub (tablero Kanban) y escribe docs/kanban/kanban.json.

El JSON sirve para actualizar la diapositiva del Kanban en Canva.
Necesita GH_TOKEN con permiso de lectura de Projects (secreto PROJECT_TOKEN).
"""
import json
import os
import subprocess
import sys

ORG = os.environ.get("KANBAN_ORG", "Proyecto-Intermodular-MM")
NUMBER = int(os.environ.get("KANBAN_PROJECT", "1"))
OUT = os.environ.get("KANBAN_OUT", "docs/kanban/kanban.json")

QUERY = """
query($org: String!, $number: Int!, $cursor: String) {
  organization(login: $org) {
    projectV2(number: $number) {
      title
      url
      field(name: "Status") {
        ... on ProjectV2SingleSelectField { options { name } }
      }
      items(first: 100, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes {
          isArchived
          fieldValueByName(name: "Status") {
            ... on ProjectV2ItemFieldSingleSelectValue { name }
          }
          content {
            __typename
            ... on Issue { number title state assignees(first: 5) { nodes { login } } }
            ... on PullRequest { number title state assignees(first: 5) { nodes { login } } }
            ... on DraftIssue { title assignees(first: 5) { nodes { login } } }
          }
        }
      }
    }
  }
}
"""

# Columnas de la diapositiva. Si el Project usa los nombres de GitHub por defecto,
# se traducen: Ready -> To do, In progress -> Doing, In review -> Done, Done -> Approved.
COLUMNS = ["To do", "Doing", "Done", "Approved"]
DEFAULT_MAP = {
    "backlog": "To do", "todo": "To do", "to do": "To do", "ready": "To do",
    "in progress": "Doing", "doing": "Doing",
    "in review": "Done",
    "done": "Approved", "approved": "Approved",
}


def gql(cursor):
    args = ["gh", "api", "graphql", "-f", f"query={QUERY}",
            "-f", f"org={ORG}", "-F", f"number={NUMBER}"]
    if cursor:
        args += ["-f", f"cursor={cursor}"]
    res = subprocess.run(args, capture_output=True, text=True)
    if res.returncode != 0:
        sys.exit(f"GraphQL error: {res.stderr or res.stdout}")
    return json.loads(res.stdout)["data"]["organization"]["projectV2"]


def column_for(status, has_approved):
    if not status:
        return "To do"
    key = status.strip().lower()
    if has_approved and key == "done":
        return "Done"  # el Project ya usa To do / Doing / Done / Approved
    return DEFAULT_MAP.get(key, status)


def main():
    cursor, nodes, project = None, [], None
    while True:
        project = gql(cursor)
        nodes += project["items"]["nodes"]
        page = project["items"]["pageInfo"]
        if not page["hasNextPage"]:
            break
        cursor = page["endCursor"]

    options = [o["name"] for o in (project.get("field") or {}).get("options", [])]
    has_approved = any(o.strip().lower() == "approved" for o in options)

    columns = {c: [] for c in COLUMNS}
    for n in nodes:
        c = n.get("content") or {}
        if n.get("isArchived") or not c:
            continue
        status = (n.get("fieldValueByName") or {}).get("name")
        col = column_for(status, has_approved)
        columns.setdefault(col, []).append({
            "number": c.get("number"),
            "title": c.get("title", "").strip(),
            "assignees": [a["login"] for a in c.get("assignees", {}).get("nodes", [])],
            "status": status,
        })

    data = {
        "project": project["title"],
        "url": project["url"],
        "status_options": options,
        "total": sum(len(v) for v in columns.values()),
        "columns": columns,
    }
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")
    print(json.dumps({k: len(v) for k, v in columns.items()}))


if __name__ == "__main__":
    main()
