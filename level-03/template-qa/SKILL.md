---
name: template-qa
description: Performs QA on newly built email and/or push templates, or on newly generated template variants. Use when a user requests QA to be performed on email and/or push templates before a production launch.
disable-model-invocation: true
---
# Purpose

Guidelines for performing Quality Assurance (QA) on email and push messages deployed in marketing campaigns.

## Description

You are a Marketing QA Specialist, with particular focus on reviewing Email and Push messages that will be used in Marketing Campaigns. Your role is to ensure that Email and Push messages are 100% error free. A QA review is complete only when every applicable item in the Primary QA Checklist has been verified.

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

### Triple Curly Braces `{{{macro}}}` — Use In:
- **Subject line files** (`email/subjects/*.hbs`)
- **Body text sections** (`email/bodyTextSections/*.hbs`)
- **Push notification files** (`push/messages/*.hbs`, `push/titles/*.hbs`)

### Double Curly Braces `{{macro}}` — Use In:
- **Preheader files** (`email/preheaders/*.hbs`)
- **Headline files** (`email/headlines/*.hbs`)
- **Subheadline files** (`email/subheadlines/*.hbs`)
- **CTA files** (`email/ctas/*.hbs`)
- **Body HTML sections** (`email/bodyHTMLSections/*.hbs`)

### Why the difference?

Triple braces `{{{macro}}}` prevent HTML escaping — required in plain-text contexts (subjects, body text, push) where raw characters must pass through unescaped. Double braces `{{macro}}` enable HTML escaping — required in HTML file contexts where output is rendered inside markup.

| File path | Braces |
|---|---|
| `email/subjects/*.hbs` | `{{{macro}}}` |
| `email/bodyTextSections/*.hbs` | `{{{macro}}}` |
| `push/messages/*.hbs` | `{{{macro}}}` |
| `push/titles/*.hbs` | `{{{macro}}}` |
| `email/preheaders/*.hbs` | `{{macro}}` |
| `email/headlines/*.hbs` | `{{macro}}` |
| `email/subheadlines/*.hbs` | `{{macro}}` |
| `email/ctas/*.hbs` | `{{macro}}` |
| `email/bodyHTMLSections/*.hbs` | `{{macro}}` |

---

## Pre-Review Setup

Before starting category checks, identify:

1. **Template type** — Does the template include `/email/`, `/push/`, or both? Apply only the relevant category checks.
2. **Link tracking method** — Does the email use `emailClickTracking` or `standardLinks=true`? This changes URL rules significantly — flag it before reviewing any URLs.
3. **International template** — Is this a UK or CA template? Look for `ck:setVariable "country"` at the very top of `index.hbs`. If present, apply country-specific rules in Category 2.

---

## Review Category 1: Layout & Structure

- Only `common/bulk/layouts/design_system` is permitted for new emails. Flag any template using a different layout.
- `brand2025=true` must be present in all `bodyHTMLSections` files.

---

## Review Category 2: Sender & Header Configuration

- Check subject line and preheader for spelling, typographical, and grammatical errors.
- Verify `senderNameHuman` is correct:
  - Default: `"Credit Karma"`
  - CKM campaigns: `"Credit Karma Money"`
- Verify `senderName` is correct.
- Verify `senderDomain` uses the correct partial for this campaign type.

### Country-Specific Configuration (UK / CA)

**UK:**
- `{{ck:setVariable "country" "UK"}}` must appear at the very top of `index.hbs`, before the opening `{`
- `senderDomain` must use `"{{> common/senderDomain/uk/mail }}"`

```handlebars
{{ck:setVariable "country" "UK"}}
{
  "type": "email",
  "senderDomain": "{{> common/senderDomain/uk/mail }}",
  ...
```

**CA:**
- `{{ck:setVariable "country" "Canada"}}` must appear at the very top of `index.hbs`
- `senderDomain` must use `"{{> common/senderDomain/canada }}"`
- CA campaigns may use `standardLinks=true` or `canadaClickTracking=true` — note this during Pre-Review Setup as it changes URL tracking behavior

```handlebars
{{ck:setVariable "country" "Canada"}}
{
  "type": "email",
  "senderDomain": "{{> common/senderDomain/canada }}",
  ...
```

---

## Review Category 3: Handlebars & Personalization

### Macro Closure & Spacing

- All macros must end with `}}` or `}}}`
- All macros must start with `{{` or `{{{`
- Examples of **incorrectly** formatted macros to flag:
  - `\{\{.*?\}` — single closing brace
  - `\{.*?\}\}` — single opening brace
  - `\{.*?\}` — single braces on both sides
- No extra spaces inside Handlebars parameter values

### Darwin Experiment Helpers (CRITICAL)

- `ck:varyBig` → used when pointing to a **directory** of `.hbs` files
- `ck:variant` → used when pointing to a **single `.json` file**

```handlebars
{{!-- Directory of .hbs files → ck:varyBig --}}
{{{ck:varyBig 'path/email/subjects' experiments 'campaign_subjects'}}}

{{!-- Single .json file → ck:variant --}}
preheader=(ck:variant 'path/email/preheaders' experiments 'campaign_preheaders')
```

Flag any case where these helpers are swapped.

---

## Review Category 4: Colors

- Any parameter with `color` or `Color` in its name must have a value starting with `#`
- All hex values must be from the approved color palette

Key color parameters to check:

- `heroBgColor`
- `heroHeadlineFontColor`
- `heroCtaColor`
- `heroCtaFontColor`
- `ctaColor`
- `ctaFontColor`

---

## Review Category 5: URLs & Link Tracking

### A. General URL Rules

- Any parameter with `url` or `Url` in its name must have a value starting with `https`

### B. Standard Email URL Rules

When the email does **not** use `emailClickTracking` or `standardLinks=true`:

- Any `creditkarma.com` URL must include `/u/` in the path

```
CORRECT:   heroLinkUrl="https://www.creditkarma.com/u/savings"
INCORRECT: heroLinkUrl="https://www.creditkarma.com/savings"
```

### C. Link Tracking Templates — `emailClickTracking` (CRITICAL)

When `{{> common/emailClickTracking ...}}` is used, OR `standardLinks=true` is set:

1. URLs in `content_link` do **NOT** need `/u/` — the tracking template handles redirects automatically
2. `content_link` must not contain empty or stray spaces
3. `content_linkText` should be present and match the visible anchor text
4. `content_section` should be present (typically `"body"`)

```handlebars
{{!-- CORRECT: No /u/ when using emailClickTracking --}}
{{> common/emailClickTracking
  content_link="https://www.creditkarma.com/savings"
  content_linkText="See my savings"
  content_section="body"
}}

{{!-- INCORRECT: empty space in content_link --}}
{{> common/emailClickTracking
  content_link="https://www.creditkarma.com/ savings"
  content_linkText="See my savings"
  content_section="body"
}}
```

### D. campaignName Parameter

- `campaignName` must be present in every `bodyHTMLSections/*.hbs` file
- All `bodyHTMLSections` files in a campaign must share the **same** `campaignName` value
- When reviewing a cloned campaign, verify `campaignName` was updated and does not contain the old campaign identifier

### E. Push URL Rules

In `push/index.hbs`, the `destination` object must have all three properties:

- `appLink` — valid app deep link
- `webLink` — uses `{{> common/pushWebLink content_link='...'}}` — **NO** `/u/` in the content_link value
- `ckLink` — uses `{{> common/base/pushCkLinkTracking content_link='...'}}` — **MUST** include `/u/` in the content_link value

`content_link` values in push destination must have no empty or stray spaces.

---

## Review Category 6: HTML & Content Quality

- All HTML tags are properly closed
- Special characters use HTML entities:
  - `®` → `<sup>&reg;</sup>`
  - `™` → `&trade;`
  - en dash `–` → `&ndash;`
  - em dash `—` → `&mdash;`
- CTA labels do not end with `>` or `>>`
- Body text is correct: spelling, grammar, accuracy
- Footer is correct for the campaign category
- Footer HTML flag and text partial match the **same** category (e.g., `3_ck_generic=true` paired with `{{> common/footers/us/categories/3_ck_generic_text }}`)

---

## Review Category 7: Push-Specific Checks

- All personalization macros in push files use triple braces `{{{macro}}}` (see Macro Formatting Rules)
- Push `destination` structure is validated (see Category 5E)
- Confirm whether the `image` property in `push/index.hbs` is intentionally present — most campaigns omit it; flag if found unexpectedly

---

## Master QA Checklist

Use this checklist to confirm every applicable item has been reviewed. Conditional items are labeled with their context.

### Layout & Structure
- ✅ Layout uses `common/bulk/layouts/design_system` (not an older layout)
- ✅ `brand2025=true` present in all `bodyHTMLSections` files

### Sender & Header
- ✅ Subject line: no spelling, typographical, or grammatical errors
- ✅ Preheader: no spelling, typographical, or grammatical errors
- ✅ Email header renders correctly
- ✅ `senderNameHuman` is correct (`"Credit Karma"` or `"Credit Karma Money"` for CKM)
- ✅ `senderName` is correct
- ✅ `senderDomain` uses the correct partial
- ✅ (UK) `{{ck:setVariable "country" "UK"}}` at very top of `index.hbs`
- ✅ (UK) `senderDomain` uses `"{{> common/senderDomain/uk/mail }}"`
- ✅ (CA) `{{ck:setVariable "country" "Canada"}}` at very top of `index.hbs`
- ✅ (CA) `senderDomain` uses `"{{> common/senderDomain/canada }}"`
- ✅ (CA) Link tracking method noted (`standardLinks=true` or `canadaClickTracking=true`)

### Macro Formatting
- ✅ Subject files use `{{{macro}}}` (triple braces)
- ✅ Body text section files use `{{{macro}}}` (triple braces)
- ✅ Preheader, headline, subheadline, CTA, and body HTML section files use `{{macro}}` (double braces)
- ✅ No incorrectly closed macros (single brace patterns flagged)
- ✅ No extra spaces inside Handlebars parameter values
- ✅ Darwin helpers: `ck:varyBig` for `.hbs` directories, `ck:variant` for `.json` files

### Colors
- ✅ All `color`/`Color` parameters start with `#`
- ✅ All hex values are from the approved color palette
- ✅ `heroBgColor`, `heroHeadlineFontColor`, `heroCtaColor`, `heroCtaFontColor`, `ctaColor`, `ctaFontColor` verified

### URLs & Link Tracking
- ✅ All `url`/`Url` parameters start with `https`
- ✅ (Standard email) All `creditkarma.com` URLs include `/u/` in the path
- ✅ (emailClickTracking) URLs in `content_link` do NOT need to contain `/u/`
- ✅ (emailClickTracking) `content_link` has no empty or stray spaces
- ✅ (emailClickTracking) `content_linkText` present and matches visible anchor text
- ✅ (emailClickTracking) `content_section` present
- ✅ `campaignName` present in every `bodyHTMLSections` file
- ✅ All `bodyHTMLSections` files share the same `campaignName` value
- ✅ (Cloned campaign) `campaignName` does not contain old campaign identifier
- ✅ (Push) `destination` has `appLink`, `webLink`, and `ckLink`
- ✅ (Push) `webLink` content_link has no `/u/`
- ✅ (Push) `ckLink` content_link includes `/u/`
- ✅ (Push) No empty spaces in push `content_link` values

### HTML & Content
- ✅ All HTML tags properly closed
- ✅ Special characters use HTML entities (`&reg;`, `&trade;`, `&ndash;`, `&mdash;`)
- ✅ CTA labels do not end with `>` or `>>`
- ✅ Body text: no spelling, grammatical, or factual errors
- ✅ Footer is correct for the campaign category
- ✅ Footer HTML flag and text partial match the same category

### Push
- ✅ (Push) Push macros use `{{{macro}}}` (triple braces)
- ✅ (Push) Push `destination` structure validated
- ✅ (Push) `image` property presence is intentional