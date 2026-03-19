# Aethon Insights Blog

A blog platform for Aethon Automation built with Hugo, featuring a custom theme focused on AI, automation, and intelligent systems content. The site includes full-text search, RSS feeds, SEO optimization, and an Nginx deployment configuration.

## Features

- **Custom Theme** -- Purpose-built "Aethon Insights" Hugo theme with clean, professional design
- **Content Organization** -- Posts organized by tags, categories, and series with taxonomy pages
- **Full-Text Search** -- JSON-based search index for client-side content search
- **RSS Feed** -- Automatic RSS generation for content syndication
- **SEO Optimized** -- Open Graph metadata, sitemap generation, and configurable page descriptions
- **Analytics** -- Umami analytics integration for privacy-friendly visitor tracking
- **Syntax Highlighting** -- Code blocks with Monokai-styled syntax highlighting
- **Table of Contents** -- Auto-generated TOC for long-form articles
- **Related Content** -- Intelligent related posts based on tags and categories
- **Multi-Language Support** -- i18n-ready with translation file support
- **Nginx Configuration** -- Production-ready Nginx config included
- **Deployment Script** -- Publish script for streamlined deployments

## Tech Stack

- **Static Site Generator:** Hugo
- **Theme:** Custom "aethon-insights" theme
- **Styling:** HTML/CSS within Hugo templates
- **Deployment:** Nginx
- **Analytics:** Umami

## Prerequisites

- Hugo (extended edition recommended)
- Git

## Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/mhmalvi/aethon-blog.git
   cd aethon-blog/apps/aethon-blog
   ```

2. **Start the development server**
   ```bash
   hugo server -D
   ```

3. **Build for production**
   ```bash
   hugo --minify
   ```

The development server runs at `http://localhost:1313` by default.

## Project Structure

```
apps/aethon-blog/
  content/
    posts/          # Blog post markdown files
  layouts/
    _default/       # Base layout templates
  themes/
    aethon-insights/ # Custom Hugo theme
  static/           # Static assets (images, favicons)
  i18n/             # Translation files
  hugo.toml         # Hugo configuration
  nginx.conf        # Production Nginx config
  publish.sh        # Deployment script
```

## Configuration

Key settings in `hugo.toml`:

- `baseURL` -- Site URL
- `title` -- Site title
- `params.author` -- Author name
- `params.description` -- Site meta description
- `params.ogImage` -- Default Open Graph image
- `params.umamiWebsiteId` -- Umami analytics ID

## License

MIT
