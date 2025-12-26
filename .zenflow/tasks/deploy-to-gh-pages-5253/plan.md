# Spec and build

## Configuration
- **Artifacts Path**: {@artifacts_path} → `.zenflow/tasks/{task_id}`

---

## Agent Instructions

Ask the user questions when anything is unclear or needs their input. This includes:
- Ambiguous or incomplete requirements
- Technical decisions that affect architecture or user experience
- Trade-offs that require business context

Do not make assumptions on important decisions — get clarification first.

---

## Workflow Steps

### [x] Step: Technical Specification
<!-- chat-id: f2c9a331-1793-416b-b6e6-6ddf0411da4e -->

✅ **Completed** - Technical specification created at `spec.md`
- **Difficulty**: Medium
- **Approach**: Integrate Astro blog at `/blog` path with conditional CI builds
- **Key Components**: Astro setup, GitHub workflow modifications, merged deployment

---

## Implementation Steps

### [ ] Step 1: Create Astro Project in /blog Directory
<!-- chat-id: fc70c562-f27e-4d8e-9ae3-3b8bad04d42e -->

Initialize and configure a new Astro project:
- Run `npm create astro@latest` in `/blog` directory
- Configure `astro.config.mjs` with `base: '/blog'` and `site: 'https://mloeper.me'`
- Set output directory to `./dist`
- Create basic blog structure with test content

**Verification**: Run `cd blog && npm run build` successfully

---

### [x] Step 2: Update .gitignore for Astro
<!-- chat-id: f4327648-3edf-4036-b65f-5a60cc6f5254 -->

✅ **Completed** - Added Astro-specific entries to `.gitignore`:
- `blog/node_modules/`
- `blog/dist/`
- `blog/.astro/`

**Verification**: Build artifacts are now properly ignored by git

---

### [ ] Step 3: Add Path Filter to GitHub Workflow

Modify `.github/workflows/main.yml` to detect `/blog` changes:
- Add `dorny/paths-filter@v2` action
- Configure filter for `blog/**` path pattern
- Set up outputs for conditional job execution

**Verification**: Workflow syntax is valid

---

### [ ] Step 4: Add Astro Build Job to Workflow

Create new job in `.github/workflows/main.yml`:
- Setup Node.js (latest LTS)
- Install dependencies in `/blog` directory
- Run `npm run build`
- Upload `blog/dist` as artifact
- Make job conditional on path filter output

**Verification**: Job runs only when blog files change

---

### [ ] Step 5: Implement Output Merge Logic

Modify deployment job in `.github/workflows/main.yml`:
- Download Hugo build artifact
- Download Astro build artifact (if available)
- Copy Astro `dist/` contents to Hugo `public/blog/`
- Handle case when Astro didn't build (no changes)

**Verification**: Merged output contains both Hugo and Astro files

---

### [ ] Step 6: Update Deployment Configuration

Ensure deployment step works with merged output:
- Keep existing `peaceiris/actions-gh-pages@v3` configuration
- Maintain CNAME for `mloeper.me`
- Deploy from merged output directory

**Verification**: Deployment succeeds

---

### [ ] Step 7: Test Full Workflow

Run complete CI/CD pipeline:
- Test with blog file changes (Astro should build)
- Test without blog changes (Astro should skip)
- Test manual workflow_dispatch (both should build)
- Verify both sites are accessible

**Verification**: 
- Hugo site at https://mloeper.me
- Astro blog at https://mloeper.me/blog

---

### [ ] Step 8: Create Implementation Report

Document the implementation in `report.md`:
- What was implemented
- How the solution was tested
- Issues encountered and resolutions
