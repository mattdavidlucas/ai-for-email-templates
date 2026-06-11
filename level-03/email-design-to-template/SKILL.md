---
name: email-design-to-template
description: Generates a Handlebars bodyHTMLSections template from a screenshot of an email design. Use when a user shares a screenshot of an email and wants to generate a matching Handlebars template file.
disable-model-invocation: true
---
# Email Design to Template

## Overview

This skill bridges the gap between visual email design and the Handlebars template system. A designer or marketer shares a screenshot of an email design; this skill analyzes it visually, maps the layout to the correct hero variant and parameters, and generates a ready-to-use `bodyHTMLSections/0.hbs` and `bodyTextSections/0.hbs`.

---

## Step 1: Request Screenshot

Ask the user to share a screenshot of the email design they want to build. Accept the image in chat.

> "Please share a screenshot of the email design you'd like to convert into a template. I'll analyze the layout, detect design parameters, and generate the Handlebars files for you."

If no screenshot is provided, ask again before proceeding. Do not move to Step 2 until an image is received.

---

## Step 2: Load Reference Material

1. Before analyzing the screenshot, read both reference files in full:

- `.claude/skills/email-design-to-template/references/heroes/HEROES.md`
- `.claude/skills/email-design-to-template/references/components/COMPONENTS.md`

2. **Review Example Images:** Briefly analyze the images in the `.claude/skills/email-design-to-template/references/heroes/examples` folder. Use these as the 'Gold Standard' for what each hero variant looks like in our design system.

These files ground the visual analysis in the actual hero variants and optional components available in the design system. Do not skip this step.

---

## Step 3: Visual Analysis

With the reference material loaded, analyze the screenshot. Identify each of the following:

### Hero Variant
Match the email's layout structure to one of the hero variants (hero0–hero7) using the descriptions in HEROES.md and the decision tree in HEROES.md's hero-selection-guide section. Be specific about which visual characteristics drove the choice.

### Color Values
- Extract color values from the visible design (hero background, headline text, CTA button, CTA font).
- Map each to the approved hex palette where possible (see Color Palette below).
- Flag any colors that appear in the design but don't match an approved palette value — note they'll need to be confirmed by the user.

### Optional Components
Identify which optional components are visually present:
- Ribbon (top / middle / bottom)
- Bureau logos (TransUnion, Equifax, or both)
- Dual CTA (two buttons side by side)
- Eyebrow with icon (small label above headline)
- Hyperlink CTA (text link instead of or in addition to button)
- Body copy section
- Body CTA button
- Disclaimer section
- Gmail annotation badge

### Logo Variant
Default is the standard Credit Karma logo. Identify if the design shows:
- CKM (Credit Karma Money) logo → `ckLogoMoney=true`
- CK + TurboTax logo → `ckmTTLogo=true`
- CK Plus logo → `ckPlusLogo=true`
- No logo → `hideLogo=true`

### Footer Category
If the footer is visible and identifiable, map it to one of the footer categories below. If not visible or unclear, note the inference and ask the user to confirm.

---

## Step 4: Output Design Spec in Chat

Display a human-readable design spec for the user to review. Do not write any files yet.

Format exactly as follows:

```
## Detected Design Spec

**Hero variant:** hero4
**Reasoning:** Text-above-image layout with CTA button below the headline block and image in the lower portion of the hero

**Parameters detected:**
- heroBgColor: #005b13
- heroHeadlineFontColor: #FFFFFF
- heroSubheadFontColor: #FFFFFF
- heroSubhead: true
- heroCtaColor: #ffc300
- heroCtaFontColor: #000000
- heroLinkUrl: https://www.creditkarma.com/u/
- heroImgSrc: /res/content/mailings/ck/[filename-needed]
- heroMobileImgSrc: /res/content/mailings/ck/[filename-needed]
- brand2025: true
- bodyCopy: true
- bodyCopySpacerBottomHide: true
- cta: true
- ctaIsSameAsHero: true
- ctaAlign: center
- disclaimer: true
- hasNewFooter: true
- 3_ck_generic: true

**Components included:**
- Hero with text and image
- Body copy section
- Body CTA (same as hero)
- Disclaimer

**Flags / questions:**
- Image filename unknown — placeholder used, please provide the filename
- Footer category inferred as Generic CK Marketing — please confirm
```

Adapt the spec to match what was actually detected. Only include parameters that are relevant to the detected layout; omit parameters that don't apply.

---

## Step 5: Confirm or Correct

Ask the user:

> "Does this design spec look correct? If anything is off — colors, hero variant, components, footer — let me know and I'll update the spec before generating files."

If the user provides corrections, update the spec and display it again. Loop until the user confirms the spec is correct.

---

## Step 6: Request Template Path

Ask the user:

> "What template path and campaign name should I use?
> - **Template path** (e.g., `test/sandbox/your-name/campaign-name`)
> - **Campaign name** (e.g., `campaign-name`)
>
> These match the inputs from the `template-builder` skill's gostarter script."

Store both values for use in Step 7.

---

## Step 7: Generate and Display Template in Chat

Generate the complete content for both files and display them as code blocks in chat before writing anything.

### bodyHTMLSections/0.hbs

Build the file from the confirmed design spec using the campaign_starter boilerplate as the structural model:

```handlebars
{{#> common/bulk/layouts/design_system
  campaignName="{campaign-name}"
  preheader=(ck:variant '{template_path}/email/preheaders' experiments '{campaign-name}_preheaders')

  brand2025=true

  {hero-variant}=true
  heroBgColor="{detected-color}"
  heroHeadlineFontColor="{detected-color}"
  heroSubheadFontColor="{detected-color}"
  heroSubhead={true-or-false}
  heroLinkUrl="https://www.creditkarma.com/u/"
  heroCtaBody=(ck:variant '{template_path}/email/ctas' experiments '{campaign-name}_ctas')
  heroCtaColor="{detected-color}"
  heroCtaFontColor="{detected-color}"
  heroImgSrc="/res/content/mailings/ck/{filename}"
  heroMobileImgSrc="/res/content/mailings/ck/{filename}"

  bodyCopy=true
  bodyCopySpacerBottomHide=true

  cta=true
  ctaIsSameAsHero=true
  ctaAlign="center"

  disclaimer={true-or-false}

  hasNewFooter=true
  {footer-flag}=true
}}

{{#*inline "heroHeadlineText"}}
{{{ck:variant '{template_path}/email/headlines' experiments '{campaign-name}_headlines'}}}
{{/inline}}

{{#*inline "heroSubheadText"}}
{{{ck:variant '{template_path}/email/subheadlines' experiments '{campaign-name}_subheadlines'}}}
{{/inline}}

{{#*inline "bodyCopyText"}}
Body copy goes here.
{{/inline}}

{{#*inline "disclaimerText"}}
*Disclaimer text goes here.
{{/inline}}

{{/common/bulk/layouts/design_system}}
```

Include only the inline partials that apply to the detected components (e.g., only include `disclaimerText` if `disclaimer=true`).

### bodyTextSections/0.hbs

```
{{{ck:variant '{template_path}/email/headlines' experiments '{campaign-name}_headlines'}}}

{{{ck:variant '{template_path}/email/subheadlines' experiments '{campaign-name}_subheadlines'}}}

{{{ck:variant '{template_path}/email/ctas' experiments '{campaign-name}_ctas'}}}: https://www.creditkarma.com/u/

Body copy goes here.

{{{ck:variant '{template_path}/email/ctas' experiments '{campaign-name}_ctas'}}}: https://www.creditkarma.com/u/

*Disclaimer text goes here.

{{> common/footers/us/categories/{footer-partial}_text }}
```

After displaying both files, ask:

> "Does this look correct? I'll write these files to `{template_path}/email/` on your confirmation."

---

## Step 8: Write Files

On user confirmation, write:
- `{template_path}/email/bodyHTMLSections/0.hbs`
- `{template_path}/email/bodyTextSections/0.hbs`

Confirm the files were written, then note:

> "Files written. To complete the full template (subjects, preheaders, headlines, CTAs, payloads, and push), run the `template-builder` skill."

---

## Key Constraints

- `brand2025=true` is always included
- All color parameter values must start with `#`
- All URL parameter values must start with `https://`
- The footer HTML flag and text partial must always match the same category
- `ck:varyBig` is used for references to directories of `.hbs` files
- `ck:variant` is used for references to single `.json` files
- Double curly braces `{{macro}}` in bodyHTMLSections files
- Triple curly braces `{{{macro}}}` in bodyTextSections files
- `hasNewFooter=true` is always included alongside the footer category flag

---

## Footer Categories Reference

| Category | HTML Flag | Text Partial |
|---|---|---|
| CK Transactional | `1_ck_transactional=true` | `common/footers/us/categories/1_ck_transactional_text` |
| Generic CK Marketing | `3_ck_generic=true` | `common/footers/us/categories/3_ck_generic_text` |
| Credit Cards & Special Offers | `4_ck_cards_special_offers=true` | `common/footers/us/categories/4_ck_cards_special_offers_text` |
| Home Marketing | `5_ck_home=true` | `common/footers/us/categories/5_ck_home_text` |
| Personal Loans | `6_ck_personal_loans=true` | `common/footers/us/categories/6_ck_personal_loans_text` |
| Auto Insurance | `7_ck_auto=true` | `common/footers/us/categories/7_ck_auto_text` |
| Multicategory | `8_ck_revenue_multicategory=true` | `common/footers/us/categories/8_ck_revenue_multicategory_text` |
| CKM Transactional | `10_ckm_transactional=true` | `common/footers/us/categories/10_ckm_transactional_text` |
| CK Networth | `11_ck_networth=true` | `common/footers/us/categories/11_ck_networth_text` |

---

## Approved Color Palette

| Hex | Name |
|---|---|
| `#000000` | Black |
| `#02380d` | Dark Green |
| `#008600` | Karma Green |
| `#6ade19` | Light Green |
| `#f4f4ef` | Tofu |
| `#ffffff` | White |
| `#89fe45` | Neon Green |
| `#f9c740` | Honey |
| `#ff77c7` | Dragonfruit |
| `#3592ef` | Blueberry |
| `#132f00` | Dark Forest |
| `#009cc1` | Sky |
| `#ff5e00` | Sunset |
| `#7039a3` | Royal |
| `#4b2e00` | Redwood |
| `#ffc300` | Butter |
| `#0077db` | Cerulean |
| `#b68c50` | Autumn Gold |
| `#52c800` | Spring |
| `#e9eef0` | Light Gray |
| `#373737` | Dark Gray |
| `#f6f2db` | Cream |
| `#005b13` | Muir |
| `#002356` | Pacific |
| `#f5f6f6` | Light Background Gray |
