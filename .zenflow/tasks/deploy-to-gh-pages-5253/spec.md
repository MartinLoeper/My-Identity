# Technical Specification: Astro Blog Integration

## Task Difficulty
**Medium** - Requires integrating two separate static site generators (Hugo + Astro) in a monorepo setup with conditional CI builds and proper path-based deployment.

## Technical Context

### Current Architecture
- **Framework**: Hugo (v0.81.0 extended)
- **Deployment**: GitHub Pages via `peaceiris/actions-gh-pages@v3`
- **Domain**: mloeper.me (custom domain)
- **Build Output**: `my-site/public/`
- **Repository**: MartinLoeper/My-Identity
- **CI/CD**: GitHub Actions (`.github/workflows/main.yml`)

### Existing Workflow
1. Hugo builds the identity/landing page from `my-site/`
2. Deploys to GitHub Pages root
3. Includes validation (linkcheck) and archival (wayback-machine) jobs

### New Requirements
- Add Astro blog at `/blog` path (https://mloeper.me/blog)
- Keep Hugo site at root (https://mloeper.me)
- Conditional build: only build Astro when `/blog/**` files change
- Sequential build: Astro builds after Hugo
- Combined deployment: merge both outputs before deploying

---

## Implementation Approach

### 1. Astro Project Setup
Create a new Astro project in `/blog` directory:
- Initialize with `npm create astro@latest`
- Configure `astro.config.mjs` with `base: '/blog'` for subpath deployment
- Set `site: 'https://mloeper.me'`
- Configure build output to `blog/dist/`

### 2. GitHub Workflow Modifications
Modify `.github/workflows/main.yml` to:

**A. Add path-based conditional for Astro build:**
```yaml
paths-filter:
  outputs:
    blog: ${{ steps.filter.outputs.blog }}
  steps:
    - uses: dorny/paths-filter@v2
      id: filter
      with:
        filters: |
          blog:
            - 'blog/**'
```

**B. Build Astro (conditional):**
```yaml
build-astro:
  needs: [paths-filter]
  if: needs.paths-filter.outputs.blog == 'true' || github.event_name == 'workflow_dispatch'
  steps:
    - Setup Node.js
    - Install dependencies in /blog
    - Run astro build
    - Upload artifact (blog/dist)
```

**C. Merge outputs before deployment:**
```yaml
deploy:
  needs: [build-hugo, build-astro]
  steps:
    - Download Hugo artifact (my-site/public)
    - Download Astro artifact (blog/dist) [conditional]
    - Merge: copy blog/dist/* to my-site/public/blog/
    - Deploy combined output to GitHub Pages
```

### 3. Build Process Flow
```
┌─────────────────────────────────────┐
│  Push to main / workflow_dispatch   │
└───────────────┬─────────────────────┘
                │
                ▼
┌─────────────────────────────────────┐
│  Path Filter: Check /blog changes   │
└───┬─────────────────────────────┬───┘
    │                             │
    ▼                             ▼
┌──────────┐              ┌──────────────┐
│  Hugo    │              │  Astro       │
│  Build   │              │  Build       │
│ (always) │              │ (if changed) │
└────┬─────┘              └──────┬───────┘
     │                           │
     └─────────┬─────────────────┘
               ▼
     ┌──────────────────┐
     │  Merge Outputs   │
     │  Hugo + Astro    │
     └────────┬─────────┘
              ▼
     ┌──────────────────┐
     │  Deploy to       │
     │  GitHub Pages    │
     └──────────────────┘
```

---

## Source Code Structure Changes

### New Files/Directories
```
/blog/
├── src/
│   ├── pages/
│   │   └── index.astro
│   └── layouts/
│       └── Layout.astro
├── public/
├── astro.config.mjs
├── package.json
├── tsconfig.json
└── .gitignore
```

### Modified Files
- `.github/workflows/main.yml` - Add Astro build step and merge logic
- `.gitignore` - Add Astro build artifacts (`blog/dist/`, `blog/node_modules/`)

### Unchanged
- `my-site/` - Hugo site remains as-is
- CNAME configuration - stays `mloeper.me`

---

## Data Model / API / Interface Changes

### Routing Structure
```
https://mloeper.me/          → Hugo landing page
https://mloeper.me/blog/     → Astro blog homepage
https://mloeper.me/blog/...  → Astro blog posts
```

### Astro Configuration
```js
// blog/astro.config.mjs
export default defineConfig({
  site: 'https://mloeper.me',
  base: '/blog',
  outDir: './dist',
  build: {
    format: 'directory'
  }
});
```

---

## Verification Approach

### Build Verification
1. **Local Hugo build**: `cd my-site && hugo -v --buildDrafts --themesDir ../../ --minify`
2. **Local Astro build**: `cd blog && npm run build`
3. **Verify output structure**:
   ```
   my-site/public/        ← Hugo output
   my-site/public/blog/   ← Astro output (merged)
   ```

### CI/CD Verification
1. **Trigger workflow** with changes in `/blog`
2. **Verify conditional execution**: Astro build only runs when blog files change
3. **Check deployment**: Visit https://mloeper.me (Hugo) and https://mloeper.me/blog (Astro)

### Functional Testing
- Hugo landing page loads at root
- Astro blog loads at `/blog`
- Navigation works between both sites
- Assets load correctly for both sites
- CNAME is preserved

### Link Validation
- Existing linkcheck job should pass
- No broken links between Hugo and Astro sites

---

## Implementation Plan

Given the **medium complexity**, this task should be broken down into incremental steps:

### Phase 1: Astro Setup
1. Create Astro project in `/blog` directory
2. Configure `astro.config.mjs` for `/blog` base path
3. Create basic blog structure with test content
4. Verify local Astro build works

### Phase 2: CI/CD Integration
5. Add `dorny/paths-filter` action to detect `/blog` changes
6. Add Astro build job with Node.js setup
7. Implement artifact upload/download mechanism
8. Add merge step to combine Hugo + Astro outputs

### Phase 3: Deployment & Testing
9. Update deployment step to use merged output
10. Update `.gitignore` for Astro artifacts
11. Test full workflow with blog changes
12. Test workflow without blog changes (Hugo-only)
13. Verify production deployment

### Phase 4: Documentation
14. Update README with blog development instructions
15. Document local development setup for both sites

---

## Risks & Considerations

### Path Conflicts
- Ensure no path overlap between Hugo and Astro routes
- Hugo site should not have a `/blog` route

### Build Dependencies
- Astro requires Node.js (different from Hugo)
- Need to manage two separate build systems in CI

### Deployment Timing
- Must ensure artifacts are properly merged before deployment
- Failed Astro build should not prevent Hugo deployment (graceful degradation)

### Git Ignore
- Must add `blog/node_modules/` and `blog/dist/` to `.gitignore`
- Keep package-lock.json in version control

### Performance
- Conditional builds save CI time when only Hugo changes
- Full builds still occur on `workflow_dispatch` and schedule

---

## Success Criteria

✅ Hugo site continues to work at https://mloeper.me  
✅ Astro blog accessible at https://mloeper.me/blog  
✅ Astro only builds when `/blog/**` files change  
✅ GitHub Actions workflow completes successfully  
✅ No broken links or missing assets  
✅ Existing validation and archival jobs still work  
✅ CNAME preserved (mloeper.me)
