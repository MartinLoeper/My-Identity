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

### [x] Step 3: Add Path Filter to GitHub Workflow
<!-- chat-id: 0693d307-5a74-46b7-9945-657cb1417ce9 -->

✅ **Completed** - Path filter successfully added to `.github/workflows/main.yml`:
- Created new `changes` job with `dorny/paths-filter@v2` action
- Configured filter for `blog/**` path pattern
- Set up `blog` output for conditional job execution
- Updated job dependencies to include `changes` job

**Verification**: Workflow syntax is valid

---

### [x] Step 4: Add Astro Build Job to Workflow
<!-- chat-id: 0e1bebcf-264f-4863-a7a4-df27a17b5cae -->

✅ **Completed** - Added `build-astro-blog` job to `.github/workflows/main.yml`:
- Setup Node.js with LTS version and npm caching
- Install dependencies in `/blog` directory using `npm ci`
- Run `npm run build` to build Astro blog
- Upload `blog/dist` as artifact named `astro-blog`
- Job runs conditionally: `if: needs.changes.outputs.blog == 'true' || github.event_name == 'workflow_dispatch'`

**Verification**: Job configuration complete, will run only when blog files change or on manual dispatch

---

### [x] Step 5: Implement Output Merge Logic
<!-- chat-id: 0008cf0f-b224-4dd7-ad73-0d33e8785919 -->

✅ **Completed** - Modified `build-and-release` job in `.github/workflows/main.yml`:
- Added `build-astro-blog` to job dependencies with refined condition: `if: always() && needs.changes.result == 'success'`
- Created `deploy-output` directory and copy Hugo's public folder contents (including hidden files)
- Download Astro build artifact conditionally (`if: needs.build-astro-blog.result == 'success'`)
- Merge Astro `dist/` contents to `deploy-output/blog/` when available
- Updated deployment to use `deploy-output` directory
- Fixed path filter with base parameter for scheduled/manual runs
- Fixed copy command to include hidden files (`.nojekyll`, etc.)

**Verification**: Merged output workflow handles both Hugo-only and Hugo+Astro scenarios, including scheduled runs

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
