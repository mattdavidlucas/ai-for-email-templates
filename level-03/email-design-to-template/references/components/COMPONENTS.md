# Optional Component Visual Descriptions

Use this file to identify which optional components are present in a screenshot. Each entry describes what the component looks like and which parameters to include when it's detected.

---

## Ribbons

Ribbons are colored horizontal bands that appear at specific positions within the hero section. They are visually distinct colored strips — not the background color of the hero itself, but narrower accent bands.

### Ribbon Top
**What it looks like:** A colored horizontal band at the very top of the hero, above the headline. Often a contrasting color to the hero background (e.g., yellow ribbon on a green hero).

**Parameter:** `ribbonTop=true`

### Ribbon Middle
**What it looks like:** A colored horizontal band appearing in the middle of the hero, typically between the headline/text content and the image area.

**Parameter:** `ribbonMiddle=true`

### Ribbon Bottom
**What it looks like:** A colored horizontal band at the bottom of the hero, below the CTA button or image.

**Parameter:** `ribbonBottom=true`

**Note:** Multiple ribbon positions can be active simultaneously. Set only the ones visible in the design.

---

## Bureau Logos

Bureau logos are the small credit bureau brand marks (TransUnion, Equifax) that appear in the hero area. Typically seen in credit monitoring and credit score campaigns.

### Both Bureau Logos
**What it looks like:** Two small logos side by side — one for TransUnion (TU) and one for Equifax (EFX). Usually appear in the lower portion of the text column (hero7 most commonly) or below the hero.

**Parameter:** `bureauLogos=true`

### TransUnion Only
**What it looks like:** Only the TransUnion logo present, without the Equifax logo.

**Parameter:** `bureauLogos_tu_only=true`

### Equifax Only
**What it looks like:** Only the Equifax logo present, without the TransUnion logo.

**Parameter:** `bureauLogos_efx_only=true`

### Bureau Logos After Hero
**What it looks like:** Bureau logos appearing below the hero section in the body content area, rather than within the hero itself.

**Parameter:** `afterHeroBureauLogos=true` (with `afterHeroBureauLogos_tu_only=true` or `afterHeroBureauLogos_efx_only=true` as appropriate)

---

## Dual CTA

A dual CTA is a layout where two CTA buttons appear side by side within the hero. Each button has its own label, color, and link. Available on hero3, hero4, and hero6.

**What it looks like:** Two buttons positioned next to each other horizontally in the hero area. Buttons may have different background colors or labels (e.g., "Check my score" next to "Learn more").

**Parameters:**
```
heroDualCta=true
heroDualCtaBody1="CTA Label One"
heroCtaColor1="#ffc300"
heroCtaFontColor1="#000000"
heroLinkUrl1="https://www.creditkarma.com/u/"
heroDualCtaBody2="CTA Label Two"
heroCtaColor2="#008600"
heroCtaFontColor2="#FFFFFF"
heroLinkUrl2="https://www.creditkarma.com/u/"
```

---

## Eyebrow with Icon

An eyebrow is a small label that appears above the main headline. When it includes an icon, a small symbol or illustration appears inline with the eyebrow text. Available on hero2 and hero7.

**What it looks like:** A small line of text, often in a lighter weight or smaller size, positioned above the headline. May have a tiny icon (star, checkmark, shield, etc.) to its left or right. Acts as a category label or value prop statement.

**Parameters:**
```
heroEyebrow=true
heroEyebrowFontColor="#000000"
heroEyebrowFontSize="20px"
heroEyebrowIconSrc="/res/content/mailings/ck/{icon-filename}"
heroEyebrowIconAltText="symbol"
```

---

## Hyperlink CTA

A hyperlink CTA is a text link — not a button — that acts as a call to action. It may appear instead of or in addition to a button CTA.

### Hero Hyperlink CTA
**What it looks like:** In the hero area, a line of underlined or colored text that functions as a link. No button shape, just styled text. Often appears below the headline or below a button.

**Parameters:**
```
hyperlinkCTA=true
hyperlinkCTABody="Link text here"
hyperlinkCTAUrl="https://www.creditkarma.com/u/"
hyperlinkCTAFontColor="#000000"
```

### Body Hyperlink CTA
**What it looks like:** In the body content area (below the hero), a text link acting as a CTA instead of or alongside a button.

**Parameters:**
```
bodyHyperlinkCTA=true
bodyHyperlinkCTABody="Link text here"
bodyHyperlinkCTAUrl="https://www.creditkarma.com/u/"
bodyHyperlinkCTAFontColor="#000000"
```

---

## Disclaimer (Body)

A disclaimer is a section of small, fine-print text that appears below the main body content and CTA. Often used for legal disclosures, offer terms, or footnotes.

**What it looks like:** A section of smaller text, typically gray, at the bottom of the email above the footer. May begin with `*` or contain legal language.

**Parameters:**
```
disclaimer=true
```

With inline partial in the bodyHTMLSections file:
```handlebars
{{#*inline "disclaimerText"}}
*Disclaimer text goes here.
{{/inline}}
```

If no disclaimer is visible: `disclaimer=false` (and omit the inline partial).

---

## Caret Animation

A caret is an animated arrow graphic that draws attention to the CTA button. It appears as a small animated GIF above or alongside the button.

**What it looks like:** A small animated arrow, typically pointing down toward the CTA button. Usually a brand-green or contrasting color.

**Parameters:**
```
heroCtaCaret=true
heroCaratBgColor="#005b13"
```

---

## Gmail Annotation

A Gmail annotation adds a promotional annotation that appears in Gmail's Promotions tab, showing a deal badge, image, or promo text alongside the email in the inbox view.

**What it looks like:** Not visible in the email body itself — it's metadata that affects how Gmail displays the email in the Promotions tab. If the design brief mentions "Gmail annotation" or "promo badge," include these parameters.

**Parameters:**
```
gmailAnnotation=true
gmailAnnotation_singleImage=true
gmailAnnotation_imageUrl="/res/content/mailings/ck/{badge-filename}"
gmailAnnotation_promoUrl="https://www.creditkarma.com/u/"
```

---

## Logo Variants

The email header typically shows the Credit Karma logo. Alternate logo variants are used for specific campaign types.

### Default CK Logo
No special parameter needed — the default logo is used when no logo override is set.

### Credit Karma Money Logo
**What it looks like:** The CKM (Credit Karma Money) logo in the header, featuring money-specific branding.

**Parameter:** `ckLogoMoney=true`

Also set: `showCkIntuitLogo=true` and `senderNameHuman="Credit Karma Money"`

### CK + TurboTax Logo
**What it looks like:** A combined Credit Karma and TurboTax logo, used for tax season joint campaigns.

**Parameter:** `ckmTTLogo=true`

### CK Plus Logo
**What it looks like:** The Credit Karma Plus membership logo.

**Parameter:** `ckPlusLogo=true`

### No Logo
**What it looks like:** The header has no logo at all — just the hero content without any brand mark.

**Parameter:** `hideLogo=true`

---

## Body Copy Section

The body copy section is a block of paragraph text that appears in the email body between the hero and the CTA button (or footer).

**What it looks like:** One or more paragraphs of body text below the hero. Uses a standard readable font size (around 20px). Not part of the hero — it's the main content area.

**Parameters:**
```
bodyCopy=true
bodyCopySpacerBottomHide=true
```

With inline partial:
```handlebars
{{#*inline "bodyCopyText"}}
Body copy goes here.
{{/inline}}
```

If no body copy is visible: omit `bodyCopy=true` and the inline partial.

---

## Body CTA Button

A body CTA is a CTA button that appears in the email body below the hero, separate from or in addition to the hero CTA.

### Body CTA Same as Hero
**What it looks like:** A CTA button in the body that uses the exact same styling as the hero CTA button. No separate color parameters needed.

**Parameters:**
```
cta=true
ctaIsSameAsHero=true
ctaAlign="center"
```

### Body CTA Different from Hero
**What it looks like:** A CTA button in the body with different colors or style from the hero CTA.

**Parameters:**
```
cta=true
ctaIsSameAsHero=false
ctaBody=(ck:variant '{template_path}/email/ctas' experiments '{campaign-name}_ctas')
ctaLinkUrl="https://www.creditkarma.com/u/"
ctaColor="#008600"
ctaFontColor="#FFFFFF"
ctaAlign="center"
ctaMobileAlign="center"
ctaSpacerBottomHt="32"
```

---

## Inline Partial Insert Slots

These slots allow custom content to be inserted at specific positions in the email layout without modifying the design system layout partial itself.

| Slot Name | Position |
|---|---|
| `beforeHeroInsert` | Before the hero section |
| `afterHeroInsert` | Between the hero and body copy |
| `afterLogoInsert` | After the logo section |
| `afterBodyCopyInsert` | After body copy (modA, modB, modC modules) |
| `afterCtaInsert` | After the CTA button |
| `afterDisclaimerInsert` | After the disclaimer section |

**Usage in bodyHTMLSections:**
```handlebars
{{#*inline "afterBodyCopyInsert"}}
  <!-- module content here -->
{{/inline}}
```
