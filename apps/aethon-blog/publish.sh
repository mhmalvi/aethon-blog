#!/bin/bash
# ═══════════════════════════════════════════════════════
# Aethon Insights — Blog publish script
# Usage:
#   ./publish.sh                                    Build and deploy the blog
#   ./publish.sh new "Title"                        Create a new blog post
#   ./publish.sh crosspost my-post-slug             Cross-post only
#   ./publish.sh crosspost my-post-slug medium,linkedin  Specific platforms
# ═══════════════════════════════════════════════════════

BLOG_DIR="/home/davinci/apps/aethon-blog"
COMPOSE_DIR="/home/davinci/apps"
CROSSPOST_WEBHOOK="https://n8n.muhammadhmalvi.com/webhook/aethon-blog-crosspost"

do_build() {
  echo "Building Aethon Insights blog..."
  cd "$BLOG_DIR" && hugo --gc --minify
  echo ""
  echo "Restarting blog container..."
  cd "$COMPOSE_DIR" && docker compose restart aethon-blog
  echo ""
  echo "Done! Live at https://insights.aethonautomation.com"
}

do_crosspost() {
  local slug="$1"
  local platforms="${2:-all}"

  if [ -z "$slug" ]; then
    echo "Error: slug is required"
    echo "Usage: ./publish.sh crosspost <slug> [platforms]"
    exit 1
  fi

  echo "Cross-posting '$slug' to: $platforms"
  response=$(curl -s -w "\n%{http_code}" -X POST "$CROSSPOST_WEBHOOK" \
    -H "Content-Type: application/json" \
    -d "{\"slug\":\"$slug\",\"lang\":\"en\",\"platforms\":\"$platforms\"}")

  http_code=$(echo "$response" | tail -1)
  body=$(echo "$response" | sed '$d')

  if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
    echo "Cross-post triggered successfully (HTTP $http_code)"
    echo "$body"
  else
    echo "Cross-post failed (HTTP $http_code)"
    echo "$body"
    exit 1
  fi
}

case "${1:-build}" in
  new)
    if [ -z "$2" ]; then
      echo "Usage: ./publish.sh new \"Your Post Title\""
      exit 1
    fi
    # Convert title to filename slug
    SLUG=$(echo "$2" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
    FILE="$BLOG_DIR/content/posts/$SLUG.md"

    cat > "$FILE" << EOF
---
title: "$2"
date: $(date +%Y-%m-%d)
description: ""
categories: []
tags: []
draft: false
---

Start writing here.
EOF
    echo "Created: $FILE"
    echo "Edit the file, then run: ./publish.sh"
    ;;

  build|"")
    CROSSPOST_SLUG=""
    shift 2>/dev/null
    while [ $# -gt 0 ]; do
      case "$1" in
        --crosspost)
          CROSSPOST_SLUG="$2"
          shift 2
          ;;
        *)
          shift
          ;;
      esac
    done

    do_build

    if [ -n "$CROSSPOST_SLUG" ]; then
      echo ""
      do_crosspost "$CROSSPOST_SLUG"
    fi
    ;;

  crosspost)
    do_crosspost "$2" "$3"
    ;;

  preview)
    echo "Starting local preview at http://localhost:1313..."
    cd "$BLOG_DIR" && hugo server --buildDrafts --bind 0.0.0.0
    ;;

  *)
    echo "Usage:"
    echo "  ./publish.sh                                    Build and deploy"
    echo "  ./publish.sh new \"Title\"                        Create a new post"
    echo "  ./publish.sh build --crosspost <slug>           Build + cross-post"
    echo "  ./publish.sh crosspost <slug> [platforms]       Cross-post only"
    echo "  ./publish.sh preview                            Local preview"
    echo ""
    echo "Platforms: all (default), or comma-separated: medium,linkedin,pinterest,substack"
    ;;
esac
