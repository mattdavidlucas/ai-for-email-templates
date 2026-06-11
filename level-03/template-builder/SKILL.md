---
name: template-builder
description: Builds new, production-ready email and push templates from marketing copy documents. Use when a user needs to build or generate a new email template, or push template, or both a new email and push template.
disable-model-invocation: true
---
# Marketing Template Builder

## Overview

This skill helps you generate and build production-ready email and push templates from a user provided marketing copy document. These rules guide the AI coding agent to produce consistent, high-quality code when a new email and/or push template is needed.

## Available scripts

- **`.claude/skills/template-builder/scripts/gostarter.sh`** - Bash function to clone our boilerplate template to new, user defined path and campaign name

---

## CRITICAL: Marketing Copy Guardrail

**Never modify user-provided marketing copy without explicit confirmation.**

If the agent detects a potential spelling, grammar, punctuation, or typographical issue in copy provided by the user, it must:

1. Flag the issue and show the recommendation clearly
2. Ask the user to confirm before making any change

Example:
> "I noticed a possible typo in your subject line: *'Your acount is ready'* — did you mean *'Your account is ready'*? Would you like me to correct this?"

**Do not silently fix or alter copy.** Apply corrections only after the user explicitly confirms.

---

## CRITICAL: Macro Formatting Rules

Personalization macros (e.g., `fname`, `bank`, `creditBureau`) **must use the correct number of curly braces** depending on the file type:

### Triple Curly Braces `{{{macro}}}` - Use in:
- **Subject line files** (`email/subjects/*.hbs`)
- **Body text sections** (`email/bodyTextSections/*.hbs`)
- **Push notification files** (`push/messages/*.hbs`, `push/titles/*.hbs`)

### Double Curly Braces `{{macro}}` - Use in:
- **Preheader files** (`email/preheaders/*.hbs`) - if they contain macros
- **Headline files** (`email/headlines/*.hbs`) - if they contain macros
- **Subheadline files** (`email/subheadlines/*.hbs`) - if they contain macros
- **CTA files** (`email/ctas/*.hbs`) - if they contain macros
- **Body HTML sections** (`email/bodyHTMLSections/*.hbs`)

**Why the difference?**
- Triple braces `{{{macro}}}` prevent HTML escaping (for plain text contexts)
- Double braces `{{macro}}` enable HTML escaping (for HTML contexts)

**Always verify macro formatting before completing the build.**

---

## PRIMARY WORKFLOW: Build from Starter

### Step 1: Clone `_examples/campaign_starter`

Run the `gostarter` script to clone our boilerplate template to new, user defined path and campaign name.

```bash
bash .claude/skills/template-builder/scripts/gostarter.sh
```

### Step 2: Prompt User for Template Path and Campaign Name

Ask the user to provide:
1. **Template Path**: The directory path for the new campaign (e.g., `test/sandbox/your-name/campaign-name`)
2. **Campaign Name**: The campaign identifier (e.g., `campaign-name`)

Execute the `gostarter` function with these parameters.

### Step 3: Prompt User for Design Parameters

Before collecting marketing copy, gather all design parameters. For context, see [the reference guide](references/REFERENCE.md). 

Ask in order:

#### A. Hero Variant (required — ask first)

Ask the user which hero variant to use. Default is `hero4=true`.

See [the reference guide](references/REFERENCE.md) for details.

#### B. Hero Parameters

Always required — include in every campaign:
- `heroLinkUrl` — hero CTA link URL (must start with `https://`)

Optional — remove if user says to remove:
- `heroBgColor` — hero background color (hex, e.g., `#005b13`)
- `heroHeadlineFontColor` — headline text color (hex, e.g., `#FFFFFF`)
- `heroImgSrc` — path appended to `/res/content/mailings/ck/` (e.g., `image-name.png`)
- `heroMobileImgSrc` — mobile image path (note: `hero0` uses `heroImgMobileSrc` instead)

Remove + set matching flag if removed:
- `heroSubheadFontColor` → remove param AND set `heroSubhead=false`
- `heroCtaColor` → remove param AND set `heroCta=false`
- `heroCtaFontColor` → remove param alongside `heroCtaColor` (they are always removed together)

**Defaults if not specified:**
- heroBgColor: `#005b13`
- heroHeadlineFontColor: `#FFFFFF`
- heroSubheadFontColor: `#FFFFFF`
- heroLinkUrl: `https://www.creditkarma.com/u/`
- heroCtaColor: `#ffc300`
- heroCtaFontColor: `#000000`
- heroImgSrc: `/res/content/mailings/ck/`
- heroMobileImgSrc: `/res/content/mailings/ck/`

#### C. Additional Parameters (ask user for each)

Ask whether each of the following applies to this campaign:

- `showCkIntuitLogo=true` / `ckLogoMoney=true` — include for CKM campaigns.
- `senderNameHuman` — sender name override. Default is `"Credit Karma"`. Use `"Credit Karma Money"` for CKM campaigns.
- `heroCtaBottomDisclaimer=true` + `heroCtaBottomDisclaimerFontColor` — add if there is a disclaimer below the hero CTA.
- `brand2025=true` — **always include** on all new campaigns.

#### D. Footer Configuration (required — ask user)

Every campaign needs a footer. Ask the user which category applies, then apply **both** the HTML flag and text partial together.

See [the reference guide](references/REFERENCE.md) for details.

- Add the HTML flag as a parameter in all `bodyHTMLSections` files
- Add the text partial at the end of all `bodyTextSections` files

The HTML flag and text partial **must always match** the same category.

#### E. Body CTA Parameters (required — ask user)

When a campaign has a body CTA separate from the hero CTA, or when the hero has no CTA, add these parameters:

- `cta=true`
- `ctaIsSameAsHero=false`
- `ctaBody` — static string or Darwin experiment:
  `(ck:variant '{path}/email/ctas' experiments '{campaign}_ctas')`
- `ctaLinkUrl` — destination URL
- `ctaColor` — hex
- `ctaFontColor` — hex
- `ctaAlign` / `ctaMobileAlign` — `"center"` or `"left"`
- `ctaSpacerBottomHt` — pixels (e.g., `"32"`)

### Step 4: Collect Marketing Copy

Prompt the user for their marketing copy document containing:

#### Email Components:
1. **Subject Lines** (multiple variants recommended)
2. **Preheaders** (multiple variants)
3. **Headlines** (multiple variants)
4. **Subheadlines** (multiple variants)
5. **CTA Labels** (multiple variants)
6. **Body Copy** (multiple variants if applicable)
7. **Disclaimers/Footer** (if any)
8. **Links** (URLs for CTAs)

#### Push Notification Components (if applicable):
1. **Push Titles** (multiple variants)
2. **Push Messages** (multiple variants)
3. **Deep Link** (destination URL)

### Step 5: Process Marketing Copy

Once marketing copy is received:

1. **Update Subject Lines**:
   - If personalization macros exist (e.g., `{fname}`, `[fname]`), create separate `.hbs` files in `email/subjects/` directory (0.hbs, 1.hbs, 2.hbs, etc.)
   - **CRITICAL:** Convert single curly braces `{macro}` to **triple curly braces** `{{{macro}}}`
   - Convert straight brackets `[macro]` to **triple curly braces** `{{{macro}}}`
   - Remove trailing empty lines

2. **Update Preheaders**:
   - If no personalization macros, update `email/preheaders.json` as a JSON array
   - If personalization macros exist, create separate `.hbs` files in `email/preheaders/` directory
   - **CRITICAL:** Convert macros to **double curly braces** `{{macro}}`
   - Remove trailing empty lines

3. **Update Headlines**:
   - If personalization macros exist, create separate `.hbs` files in `email/headlines/` directory
   - If directory is created, update references to use `ck:varyBig` instead of `ck:variant`
   - Convert macros to **double curly braces** `{{macro}}`
   - Remove trailing empty lines

4. **Update Subheadlines**:
   - If personalization macros exist, create separate `.hbs` files in `email/subheadlines/` directory
   - If directory is created, update references to use `ck:varyBig` instead of `ck:variant`
   - Convert macros to **double curly braces** `{{macro}}`
   - Remove trailing empty lines

5. **Update CTAs**:
   - If personalization macros exist, create separate `.hbs` files in `email/ctas/` directory
   - If directory is created, update references to use `ck:varyBig` instead of `ck:variant`
   - Convert macros to **double curly braces** `{{macro}}`
   - Remove trailing empty lines

6. **Update Body Copy**:
   - Create separate files in `email/bodyHTMLSections/` for each body copy variant (0.hbs, 1.hbs, 2.hbs, etc.)
   - Apply the design parameters collected in Step 3 to all bodyHTMLSections files
   - Convert macros to **double curly braces** `{{macro}}`
   - Set `disclaimer=false` if no disclaimer provided, or `disclaimer=true` with `disclaimerText` inline partial if provided
   - Remove trailing empty lines

7. **Update Body Text Sections**:

   Create corresponding files in `email/bodyTextSections/` for each variant. Every `bodyTextSections` file must include all of the following elements — do not omit any:

   - [ ] Darwin experiment references for all variable content (headlines, subheadlines, CTAs)
   - [ ] Body copy text
   - [ ] CTA label + destination URL on the same line (e.g., `Shop Now: https://...`)
   - [ ] Disclaimer text (if applicable)
   - [ ] Footer partial matching the footer category selected in Step 3

   Additional formatting rules:
   - Keep empty lines between paragraphs (do NOT convert to `<br><br>`)
   - **CRITICAL:** Convert macros to **triple curly braces** `{{{macro}}}`
   - Remove trailing empty lines

8. **Update Payload Files**:
   - Update `payloads/{template_path}/email/payload.json` experiment names to match campaign name
   - Update `payloads/{template_path}/push/payload.json` experiment names to match campaign name
   - Collect all personalization macros (e.g., `{{fname}}`, `{{bank}}`, `{{creditBureau}}`) found in email templates (subjects, preheaders, headlines, subheadlines, CTAs, body copy)
   - Add each unique macro as a new property to `payloads/{template_path}/email/payload.json` with a sample value
   - Collect all personalization macros found in push templates (titles, messages)
   - Add each unique macro as a new property to `payloads/{template_path}/push/payload.json` with a sample value
   - Common macro examples and sample values:
     - `fname`: "Matthew"
     - `bank`: "Chase"
     - `creditBureau`: "TransUnion"
     - `dateReported`: "January 15, 2025"
     - `amount`: "$500"

   **`preferences` property (required):** Always set the `preferences` property in `email/payload.json`. See [the reference guide](references/REFERENCE.md) for details. Ask the user which preference to use.

   **Custom payload properties:** Ask if the campaign needs additional payload properties (e.g., `"PCA": true`, `"missed_notifs": "5"`). Add any the user specifies.

9. **Configure Push Notifications:**

   Ask the user these three questions before building push files:

   **Q1: Does this campaign have a push notification?**
   - If **no** → delete the entire `push/` directory and skip the remaining push questions.
   - If **yes** → continue.

   **Q2: Should the `image` property be removed from `push/index.hbs`?**
   - Default: **yes** — most campaigns omit the image property.
   - Remove `image` from `push/index.hbs` unless the user provides an image path.

   **Q3: Should titles and messages be consolidated into a single `messages` experiment?**
   - Default: **yes** — use the consolidated pattern below.

   **Standard consolidated push pattern (default):**
   - Remove `image` property from `push/index.hbs`
   - Delete the `push/titles/` directory entirely
   - Each `push/messages/N.hbs` file contains both `message` and `richData` fields inline:
     ```
     "message": "Push message text here",
     "richData": {
       "title": "Push title here",
       "body": "Push message text here"
     }
     ```
   - **CRITICAL:** All personalization macros in push files must use **triple curly braces** `{{{macro}}}`
   - In `push/index.hbs`, replace separate `message`, `richData.title`, and `richData.body` references with a single `ck:varyBig` pointing to the `messages` directory
   - Remove `{campaign}_titles` from `push/payload.json`; keep only `{campaign}_messages`
   - Append the destination path to all three `destination` properties: `appLink`, `webLink`, `ckLink`

### Step 6: Run HTML Cleanup

Execute the `/marketing/cleanup_html` command on all files in the `bodyHTMLSections` directory:

1. Find strings in single curly braces `{text}` and update to double curly braces `{{text}}`
2. Find strings in straight brackets `[text]` and update to double curly braces `{{text}}`
3. Replace curly apostrophes with straight apostrophes
4. Replace en dashes `–` with HTML entity `&ndash;`
5. Replace em dashes `—` with HTML entity `&mdash;`
6. Replace empty lines with `<br><br>`
7. Replace `®` with `<sup>&reg;</sup>`
8. Replace `™` with HTML entity `&trade;`
9. **Remove `>` or `>>` from CTA text** — CTA labels must never end with arrow characters

### Step 7: Final Validation

Verify that:
- ✅ **MACRO FORMATTING (CRITICAL):**
  - Subject lines (`email/subjects/*.hbs`): Use **triple curly braces** `{{{macro}}}`
  - Preheaders (`email/preheaders/*.hbs`): Use **double curly braces** `{{macro}}`
  - Headlines (`email/headlines/*.hbs`): Use **double curly braces** `{{macro}}`
  - Subheadlines (`email/subheadlines/*.hbs`): Use **double curly braces** `{{macro}}`
  - CTAs (`email/ctas/*.hbs`): Use **double curly braces** `{{macro}}`
  - Body HTML sections (`email/bodyHTMLSections/*.hbs`): Use **double curly braces** `{{macro}}`
  - Body text sections (`email/bodyTextSections/*.hbs`): Use **triple curly braces** `{{{macro}}}`
  - Push files (`push/messages/*.hbs`, `push/titles/*.hbs`): Use **triple curly braces** `{{{macro}}}`
- ✅ No trailing empty lines at end of any files
- ✅ All color parameters start with `#`
- ✅ All URL parameters start with `https://`
- ✅ Darwin experiment helpers (`ck:varyBig` and `ck:variant`) are used correctly:
  - `ck:varyBig` for directories of `.hbs` files
  - `ck:variant` for individual `.json` files
- ✅ All HTML tags are properly closed
- ✅ Design system layout is properly configured with provided design parameters
- ✅ Footer HTML flag and text partial match the same category
- ✅ Every `bodyTextSections` file includes Darwin experiment refs, body copy, CTA+URL, and footer partial
- ✅ `preferences` is set in `email/payload.json`
- ✅ No CTA label ends with `>` or `>>`
- ✅ `brand2025=true` is present in all bodyHTMLSections files

### Step 8: Inline Partial Inserts (Optional)

After completing the main build, ask the user if any inline partial inserts are needed. Three named insert slots are available:

| Partial Name | Placement |
|---|---|
| `afterHeroInsert` | Between the hero section and body copy |
| `afterBodyCopyInsert` | After body copy (commonly used for `modA`, `modB`, `modC` modules) |
| `afterCtaInsert` | After the CTA button |

Insert syntax (placed inside the `design_system` block in `bodyHTMLSections`):

```handlebars
{{#*inline "afterBodyCopyInsert"}}
  <!-- module content here -->
{{/inline}}
```

Add whichever partials the user requests to the appropriate `bodyHTMLSections` files.

---

## SECONDARY WORKFLOW: Clone an Existing Production Campaign

Use this workflow when cloning an existing production campaign instead of the starter boilerplate.

### Step 9: Template Cloning Workflow

**When to use:** The user provides an existing campaign path to clone rather than building from scratch.

#### 9.1 Copy Template and Payload Directories

```bash
# Copy the template directory
cp -R {old_template_path} {new_template_path}

# Copy the payload directory
cp -R payloads/{old_template_path} payloads/{new_template_path}
```

#### 9.2 Find and Replace Old Campaign References

In all files within **both** the new template directory and new payload directory, replace:

1. **`campaignName` parameter value** — the string value of the `campaignName` parameter in `.hbs` files
2. **Darwin experiment paths** — file system paths referencing the old campaign directory (e.g., `old/path/email/headlines`)
3. **Darwin experiment IDs** — experiment identifiers (e.g., `old_html` → `new_html`, `old_messages` → `new_messages`)
4. **`templateId` property** — in all `index.hbs` files

```bash
# Replace in template files
find {new_template_path} -type f \( -name "*.hbs" -o -name "*.json" \) -print0 | \
  xargs -0 sed -i "" "s%{old_campaign_name}%{new_campaign_name}%g"

# Replace in payload files
find payloads/{new_template_path} -type f -print0 | \
  xargs -0 sed -i "" "s%{old_campaign_name}%{new_campaign_name}%g"
```

#### 9.3 Apply Design Parameter Overrides

Ask the user if any design parameters differ from the source campaign. Apply any overrides the user specifies to all `bodyHTMLSections` files (following the same parameter rules from Step 3).

#### 9.4 Update Marketing Copy (if copy is changing)

If the campaign has new marketing copy, prompt the user for it and process it following Steps 4–6.

#### 9.5 Validate — No Old Campaign References Remain

Search all files in both directories to confirm no references to the old campaign name remain:

```bash
grep -r "{old_campaign_name}" {new_template_path}
grep -r "{old_campaign_name}" payloads/{new_template_path}
```

Both searches must return no results before the cloning workflow is complete.

---

---

## Optional: Run Parity

After completing either workflow, ask the user if they'd like to run parity to validate the template. **Do not run automatically — ask first.**

> "Would you like to run parity to validate the template?"

If yes, use the `run-parity` skill with the template path from the current build.

---

## Best Practices Enforced

- No trailing empty lines in any files
- Proper macro formatting: `{{macro}}` for HTML, `{{{macro}}}` for text
- Correct Darwin experiment helper usage (`ck:varyBig` for `.hbs` directories, `ck:variant` for `.json` files)
- Valid hex color values (always prefixed with `#`)
- Valid HTTPS URLs
- `brand2025=true` on all new campaigns
- Footer must be consistent: HTML flag and text partial must always match the same category
- Every `bodyTextSections` file must include all Darwin experiment refs, body copy, CTA+URL, and footer partial
- Push `image` property: remove from `push/index.hbs` unless user explicitly provides an image path
- CTA label text must never end with `>` or `>>`
- `preferences` must always be set in `email/payload.json`
- `senderNameHuman` defaults to `"Credit Karma"`; use `"Credit Karma Money"` for CKM campaigns
