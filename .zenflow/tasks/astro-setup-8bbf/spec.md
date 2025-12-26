# Technical Specification: Astro Blog Setup with MultiTerm Theme

## Complexity Assessment
**Difficulty Level**: Medium

**Rationale**: 
- Requires cloning and integrating a third-party Astro theme into a subdirectory
- Need to configure the theme for personal use (NixOS and AI blog topics)
- Must ensure proper .gitignore configuration for Node.js/Astro artifacts
- Requires understanding of Astro project structure and configuration
- Some edge cases around directory structure and dependency management

## Technical Context

### Current State
- **Repository**: MartinLoeper/My-Identity (Hugo theme repository)
- **Target**: Create independent Astro blog in `blog/` subdirectory
- **Theme Source**: https://github.com/stelcodes/multiterm-astro
- **Blog Topics**: NixOS and AI

### Technology Stack
- **Framework**: Astro (withastro/astro)
- **Theme**: MultiTerm Astro v2.0.0+
- **Package Manager**: npm
- **Dependencies**: 
  - Astro core
  - Tailwind CSS v4
  - Shiki (syntax highlighting)
  - Giscus (comments, optional)
  - Various Astro integrations (MDX, sitemap, RSS, etc.)

## Implementation Approach

### 1. Directory Setup
- Clone the multiterm-astro repository directly into `blog/` subdirectory
- Use shallow clone to avoid unnecessary history: `git clone --depth 1`
- Remove the `.git` directory from the cloned theme to integrate it into the parent repository

### 2. Dependency Installation
- Navigate to `blog/` directory
- Run `npm install` to install all Astro and theme dependencies
- Verify successful installation and dependency resolution

### 3. Configuration
- Edit `blog/src/site.config.ts` to customize:
  - Site title, description, author information
  - Theme selection (choose appropriate Shiki themes)
  - Social links (GitHub, etc.)
  - Optional features (GitHub activity widget, Giscus comments)
- Review and understand available configuration options

### 4. Content Initialization
- Remove example content from `blog/src/content/`
- Create initial blog post structure for NixOS and AI topics
- Set up appropriate content collections and frontmatter

### 5. .gitignore Updates
- Update root `.gitignore` to include Astro-specific patterns:
  - `node_modules/`
  - `dist/`
  - `.astro/`
  - `*.log`
- Ensure Hugo and Astro artifacts don't conflict

## Source Code Structure Changes

### New Files/Directories
```
blog/
├── src/
│   ├── site.config.ts          # Modified: Site configuration
│   ├── content/                # Modified: Custom blog content
│   │   ├── posts/              # Modified: Blog posts about NixOS and AI
│   │   └── pages/              # Modified: Static pages
│   ├── components/             # Unchanged: Theme components
│   ├── layouts/                # Unchanged: Theme layouts
│   └── styles/                 # Unchanged: Theme styles
├── public/                     # Unchanged: Static assets
├── astro.config.mjs           # Review: Astro configuration
├── package.json               # Unchanged: Dependencies
├── package-lock.json          # Generated: Lock file
└── node_modules/              # Generated: Dependencies (gitignored)
```

### Modified Files
- `/.gitignore` - Add Astro/Node.js patterns
- `/blog/src/site.config.ts` - Customize site settings
- `/blog/src/content/` - Replace example content

## Data Model / API / Interface Changes
No database or API changes required. This is a static site generation project.

### Content Schema (defined by theme)
Blog posts use frontmatter:
```typescript
{
  title: string
  description: string
  publishDate: Date
  updatedDate?: Date
  tags?: string[]
  draft?: boolean
  ogImage?: string
}
```

## Verification Approach

### Build Verification
1. Navigate to `blog/` directory
2. Run `npm run dev` - verify development server starts successfully
3. Run `npm run build` - verify static site builds without errors
4. Run `npm run preview` - verify built site can be previewed
5. Check browser at http://localhost:4321 (or provided port)

### Content Verification
1. Verify homepage renders correctly
2. Verify blog post pages are accessible
3. Verify theme switcher functionality works
4. Verify RSS feed is generated at `/rss.xml`
5. Verify sitemap is generated at `/sitemap-index.xml`

### Code Quality
1. Check for TypeScript errors: `npm run check` (if available)
2. Verify no console errors in browser
3. Test responsive design on different screen sizes
4. Verify all internal links work correctly

### .gitignore Verification
1. Verify `node_modules/` is not tracked by git
2. Verify `dist/` build output is not tracked
3. Verify no conflicts with existing Hugo ignore patterns

## Key Dependencies
```json
{
  "astro": "^5.x",
  "@astrojs/mdx": "^4.x",
  "@astrojs/sitemap": "^3.x",
  "@astrojs/rss": "^4.x",
  "astro-expressive-code": "^0.x",
  "tailwindcss": "^4.x"
}
```
(Exact versions will be determined by the theme's package.json)

## Risks and Mitigation

### Risk 1: Git Submodule Complexity
- **Mitigation**: Clone and remove `.git` directory to flatten the theme into the repository

### Risk 2: Port Conflicts
- **Mitigation**: Document default ports, allow Astro to use alternative ports if needed

### Risk 3: Node.js Version Compatibility
- **Mitigation**: Check theme's requirements, use appropriate Node.js version (likely Node 18+)

### Risk 4: Theme Updates
- **Mitigation**: Document theme version and update process for future reference

## Success Criteria
- [ ] Astro blog successfully set up in `blog/` directory
- [ ] Development server runs without errors
- [ ] Production build completes successfully
- [ ] Site configuration reflects personal blog settings
- [ ] Example content replaced with initial structure for NixOS/AI posts
- [ ] .gitignore properly configured to exclude build artifacts
- [ ] All verification steps pass
