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
- **Theme**: MultiTerm Astro v1.0.0 (repository claims v2.0.0 released, but package.json shows v1.0.0)
- **Package Manager**: npm
- **Dependencies**: 
  - Astro core v5.x
  - Tailwind CSS v4
  - Shiki (syntax highlighting via Expressive Code)
  - Pagefind (site-wide search, critical dependency)
  - Giscus (comments, optional)
  - Various Astro integrations (MDX, sitemap, RSS, etc.)
  - Satori (auto-generated social card images)

## Implementation Approach

### 1. Directory Setup
- Clone the multiterm-astro repository directly into `blog/` subdirectory
- Use shallow clone to avoid unnecessary history: `git clone --depth 1`
- Remove the `.git` directory from the cloned theme to integrate it into the parent repository

### 2. Dependency Installation
- Navigate to `blog/` directory
- Run `npm install` to install all Astro and theme dependencies
- Verify successful installation and dependency resolution
- Note: Pagefind will run automatically via `postbuild` script after each build

### 3. Configuration
- Edit `blog/src/site.config.ts` to customize:
  - **Basic Info**: `site`, `title`, `description`, `author`, `tags`
  - **Theme Mode**: `themes.mode` - choose "single", "select", or "light-dark-auto"
  - **Theme Selection**: `themes.include` - select Shiki themes from 59 available options
  - **Theme Overrides**: `themes.overrides` - optionally customize specific theme colors
  - **Navigation**: `navLinks` - configure header navigation menu
  - **Social Links**: `socialLinks` - GitHub, Mastodon, LinkedIn, Bluesky, Twitter, email, RSS
  - **Pagination**: `pageSize` - posts per page (default: 6)
  - **Social Cards**: `socialCardAvatarImage` - square JPEG for auto-generated OG images
  - **Optional Features**:
    - `giscus` - GitHub comments integration (requires repo setup)
    - `characters` - Character chat feature with custom avatars
  - **Font**: Configured in `src/styles/global.css` (default: JetBrains Mono Variable)
- Review and understand available configuration options

### 4. Content Initialization
- Remove example content from `blog/src/content/`
- Create initial blog post structure for NixOS and AI topics
- Set up appropriate content collections and frontmatter

### 5. .gitignore Updates
- Update root `.gitignore` to include Astro-specific patterns:
  - `blog/node_modules/` - npm dependencies
  - `blog/dist/` - build output (includes Pagefind index)
  - `blog/.astro/` - Astro's internal cache directory
  - `*.log` - npm/build logs
- Ensure Hugo and Astro artifacts don't conflict
- Note: Existing .gitignore is Hugo-focused; need to add Astro/Node.js patterns

## Source Code Structure Changes

### New Files/Directories
```
blog/
├── src/
│   ├── site.config.ts          # Modified: Site configuration
│   ├── content/                # Modified: Custom blog content
│   │   ├── posts/              # Modified: Blog posts about NixOS and AI (.md or .mdx)
│   │   ├── home.md             # Modified: Homepage content
│   │   ├── about.md            # Modified: About page content
│   │   ├── addendum.md         # Modified: Footer addendum content
│   │   └── avatar.jpg          # Modified: Social card avatar (square JPEG)
│   ├── components/             # Unchanged: Theme components
│   ├── layouts/                # Unchanged: Theme layouts
│   └── styles/                 # Unchanged: Theme styles
├── public/                     # Unchanged: Static assets (favicon, characters, etc.)
├── dist/                       # Generated: Build output (gitignored)
│   └── pagefind/               # Generated: Search index (gitignored)
├── .astro/                     # Generated: Astro cache (gitignored)
├── astro.config.mjs           # Review: Astro configuration
├── package.json               # Unchanged: Dependencies
├── package-lock.json          # Generated: Lock file
└── node_modules/              # Generated: Dependencies (gitignored)
```

**Note**: Content uses individual `.md` files for pages (not a `pages/` directory). Blog posts go in `posts/` directory.

### Modified Files
- `/.gitignore` - Add Astro/Node.js patterns
- `/blog/src/site.config.ts` - Customize site settings
- `/blog/src/content/` - Replace example content

## Data Model / API / Interface Changes
No database or API changes required. This is a static site generation project.

### Content Schema (defined by theme)
Blog posts use frontmatter (based on example posts):
```typescript
{
  title: string           // Post title
  description: string     // Post description (used in SEO and post listings)
  published: Date         // Publication date (YYYY-MM-DD format)
  draft: boolean          // Whether post is draft (true/false)
  tags: string[]          // Array of tags (e.g., ['nixos', 'ai'])
}
```

**Note**: The theme uses `published` (not `publishDate`) and does not include `updatedDate` or `ogImage` fields in example content.

## Verification Approach

### Build Verification
1. Navigate to `blog/` directory
2. Run `npm run dev` - verify development server starts successfully
3. Run `npm run build` - verify static site builds without errors
   - Note: This automatically runs `postbuild` script which executes Pagefind indexing
4. Run `npm run preview` - verify built site can be previewed
5. Check browser at http://localhost:4321 (or provided port)
6. Run `npm run format` - verify Prettier formatting (optional, for code quality)

### Content Verification
1. Verify homepage renders correctly
2. Verify blog post pages are accessible
3. Verify theme switcher functionality works (mode dependent on config)
4. Verify RSS feed is generated at `/rss.xml`
5. Verify sitemap is generated at `/sitemap-index.xml`
6. Verify Pagefind search functionality works (search icon in header)
7. Verify auto-generated social cards (check `dist/_astro/` after build)
8. Test Character Chat feature if configured
9. Test Giscus comments if configured (requires GitHub repo setup)

### Code Quality
1. Verify no console errors in browser
2. Test responsive design on different screen sizes
3. Verify all internal links work correctly
4. Check code formatting with `npm run format` (Prettier)
5. Verify Astro build produces no warnings or errors

**Note**: Theme does not include a `check` or type-checking script in package.json.

### .gitignore Verification
1. Verify `node_modules/` is not tracked by git
2. Verify `dist/` build output is not tracked
3. Verify `.astro/` cache directory is not tracked (Astro's internal cache)
4. Verify Pagefind's generated files in `dist/pagefind/` are not tracked
5. Verify no conflicts with existing Hugo ignore patterns

## Key Dependencies
### Core Dependencies
```json
{
  "astro": "^5.13.5",
  "@astrojs/mdx": "^4.3.4",
  "@astrojs/sitemap": "^3.5.1",
  "@astrojs/rss": "^4.0.12",
  "astro-expressive-code": "^0.41.3",
  "tailwindcss": "^4.1.13",
  "@pagefind/default-ui": "^1.4.0",
  "satori": "^0.18.2",
  "rehype-katex": "^7.0.1",
  "remark-math": "^6.0.0"
}
```

### Dev Dependencies
```json
{
  "pagefind": "^1.4.0",
  "prettier": "3.6.2",
  "prettier-plugin-astro": "0.14.1"
}
```

**Key Features Enabled by Dependencies**:
- **Pagefind**: Site-wide search (runs via `postbuild` script)
- **Satori**: Auto-generated social card images
- **KaTeX**: Math equation rendering
- **Expressive Code**: Enhanced syntax highlighting with Shiki themes
- **Prettier**: Code formatting

(Versions from multiterm-astro's current package.json)

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
