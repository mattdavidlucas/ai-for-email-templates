# Design System Parameter Reference

### Hero Variant Options

| Variant | Description |
|---|---|
| `hero0` | Image-only, no text overlay. Used for campaigns that require a full, image-based hero. Uses `heroImgMobileSrc` (not `heroMobileImgSrc`) |
| `hero1` | Text-only layout with flexible left/center alignment, optional ribbon elements, and button or hyperlink CTA support |
| `hero1b` | Text-left layout with centered alignment option, no image, supports both button and hyperlink CTAs |
| `hero1t` | Text-left layout with horizontal rule separator at top, subhead, and hyperlink CTA support |
| `hero2` | Text-centered layout with icon, supports headlines, subheads, and optional ribbon elements |
| `hero3` | Image-first layout with centered text below, supports optional ribbon elements at top/middle/bottom positions |
| `hero4` | Text-above-image layout with flexible left/center alignment, dual CTA support, and optional ribbon elements |
| `hero5` | Side-by-side layout with text left and image right, optional ribbon top, and mobile-responsive stacking |
| `hero6` | Full-width image-first layout with centered text below, supports snipes animations and optional ribbon elements |
| `hero7` | Side-by-side layout with text left and small image right, supports eyebrow with icon and bureau logos |

### Global Layout Parameters

| Parameter | Type | Description | Default |
|---|---|---|---|
| `layoutBgColor` | hex | Layout background color; not required; only apply when the user specfies | `#ffffff` |
| `brand2025` | boolean | Enable 2025 brand styling (always include) | - |
| `campaignName` | string | Campaign identifier used for tracking | - |

## Hero Parameters (All Variants)

### Required Parameters
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroLinkUrl` | url | Hero CTA link destination | - |

### Background & Colors
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroBgColor` | hex | Hero section background color | - |
| `heroHeadlineFontColor` | hex | Headline text color | `#FFFFFF` |
| `heroHeadlineFontSize` | string | Headline font size | `36px` |
| `heroHeadlineFontWeight` | string | Headline font weight | `bold` (brand2025) / `300` (legacy) |
| `heroSubheadFontColor` | hex | Subheadline text color | `#FFFFFF` |
| `heroSubheadFontSize` | string | Subheadline font size | `20px` |

### Images
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroImgSrc` | path | Hero image path (desktop) | - |
| `heroMobileImgSrc` | path | Hero image path (mobile) | - |
| `heroImgMobileSrc` | path | Hero image path (mobile, hero0 only) | - |
| `heroImgWidthSet` | string | Hero image width | `700` |
| `heroImgWidthResponsive` | string | Hero image responsive width | `100%` |
| `heroImgWidth` | string | Hero image specific width | varies by hero |
| `heroMobileImgWidth` | string | Mobile hero image width | `100%` |
| `heroImgAltText` | string | Hero image alt text | `Credit Karma` / `Illustration` |
| `heroImgAlign` | string | Hero image alignment | `center` |
| `heroImgVAlign` | string | Hero image vertical alignment | `middle` / `top` |

### Hero Icon (hero2)
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroIconSrc` | path | Hero icon image path | - |
| `heroIconAltText` | string | Hero icon alt text | `Symbol` |

### Hero Eyebrow (hero2, hero7)
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroEyebrow` | boolean | Show hero eyebrow | - |
| `heroEyebrowFontColor` | hex | Eyebrow text color | `#000000` / `#FFFFFF` |
| `heroEyebrowFontSize` | string | Eyebrow font size | `20px` |
| `heroEyebrowWeight` | string | Eyebrow font weight | `bold` / `normal` |
| `heroEyebrowIconSrc` | path | Eyebrow icon path | - |
| `heroEyebrowIconValign` | string | Eyebrow icon vertical alignment | `middle` |
| `heroEyebrowIconAltText` | string | Eyebrow icon alt text | `symbol` |

### Hero CTA
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroCtaBody` | string | Hero CTA button text | - |
| `heroCtaColor` | hex | Hero CTA background color | `#ffc300` |
| `heroCtaBorderColor` | hex | Hero CTA border color | matches `heroCtaColor` |
| `heroCtaFontColor` | hex | Hero CTA text color | `#000000` |
| `ctawidth` | string | CTA button width | `268` |
| `heroIconCtaImgSrc` | path | Icon inside CTA button | - |
| `heroIconCtaImgWidth` | string | CTA icon width | `21` / `22` |
| `heroIconCtaImgAltText` | string | CTA icon alt text | `img` |

### Hero CTA Image (hero4, hero5)
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroCtaImg` | boolean | Show CTA as image | - |
| `heroCtaImgSrc` | path | CTA image path (desktop) | - |
| `heroCtaMobileImgSrc` | path | CTA image path (mobile) | - |
| `heroCtaImgWidthSet` | string | CTA image width | `272` |
| `heroCtaImgWidthResponsive` | string | CTA image responsive width | `100%` |
| `heroCtaMobileImgWidth` | string | Mobile CTA image width | `43%` |
| `heroCtaImgAltText` | string | CTA image alt text | - |
| `heroCtaImgAlign` | string | CTA image alignment | `left` |

### Hero Dual CTA (hero3, hero4, hero6)
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroDualCta` | boolean | Enable dual CTA layout | - |
| `heroDualCtaBody1` | string | First CTA button text | - |
| `heroCtaColor1` | hex | First CTA background color | - |
| `heroCtaBorderColor1` | hex | First CTA border color | - |
| `heroCtaFontColor1` | hex | First CTA text color | `#ffffff` |
| `heroLinkUrl1` | url | First CTA link destination | - |
| `heroDualCtaBody2` | string | Second CTA button text | - |
| `heroCtaColor2` | hex | Second CTA background color | - |
| `heroCtaBorderColor2` | hex | Second CTA border color | - |
| `heroCtaFontColor2` | hex | Second CTA text color | `#ffffff` |
| `heroLinkUrl2` | url | Second CTA link destination | - |

### Hero Hyperlink CTA
| Parameter | Type | Description | Default |
|---|---|---|---|
| `hyperlinkCTA` | boolean | Enable hyperlink CTA | - |
| `hyperlinkCTABody` | string | Hyperlink CTA text | - |
| `hyperlinkCTAUrl` | url | Hyperlink CTA destination | - |
| `hyperlinkCTAFontColor` | hex | Hyperlink CTA text color | `#000000` |

### Hero Disclaimers
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroCtaDisclaimer` | boolean | Show disclaimer above CTA | - |
| `heroCtaDisclaimerFontColor` | hex | Disclaimer text color | `#000000` / `#373737` / `#FFFFFF` |
| `heroCtaBottomDisclaimer` | boolean | Show disclaimer below CTA | - |
| `heroCtaBottomDisclaimerFontColor` | hex | Bottom disclaimer text color | `#565C5E` / `#373737` / `#FFFFFF` |

### Hero Alignment & Layout
| Parameter | Type | Description | Default |
|---|---|---|---|
| `hero1Align` | string | Hero1 text alignment | `left` |
| `hero1bAlign` | string | Hero1b text alignment | `left` |
| `heroContentAlign` | string | Hero content alignment | `center` |
| `heroContentAlignLeft` | boolean | Align hero content left | - |
| `heroContentAlignCenter` | boolean | Align hero content center | - |
| `heroLeftContentValign` | string | Left content vertical alignment | `top` / `middle` |

### Hero Spacing
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroSpacerTopHt` | string | Top spacer height | `32` |
| `subheadSpacerTopHt` | string | Subhead top spacer height | `16` |
| `subheadSpacerBottomHt` | string | Subhead bottom spacer height | `32` |
| `heroImgSpacerTopHt` | string | Image top spacer height | `0px` |
| `heroImgSpacerBottomHt` | string | Image bottom spacer height | `0px` |
| `heroImgSpacerLeftWd` | string | Image left spacer width | `0px` |
| `heroImgSpacerRightWd` | string | Image right spacer width | `0px` |
| `heroMobileImgSpacerTopHt` | string | Mobile image top spacer | `32px` |
| `heroMobileImgSpacerBottomHt` | string | Mobile image bottom spacer | `0px` |
| `heroMobileImgAlign` | string | Mobile image alignment | `center` |

### Hero Toggles
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroSubhead` | boolean | Show subheadline | - |
| `heroHeadline` | boolean | Show headline | - |
| `hideHeadline` | boolean | Hide headline | - |
| `heroNoLink` | boolean | Remove hero link wrapper | - |
| `heroImgHide` | boolean | Hide hero image (hero6) | - |
| `hero3SpacerBottomHide` | boolean | Hide hero3 bottom spacer | - |
| `hero4BottomSpacer` | boolean | Show hero4 bottom spacer | - |
| `hero6TopSpacerHide` | boolean | Hide hero6 top spacer | - |
| `heroHeadlineSpacerTopHide` | boolean | Hide headline top spacer | - |
| `smallHeroHeadline` | boolean | Use small headline (32px) | - |
| `largeHeroHeadline` | boolean | Use large headline (40px) | - |
| `mediumheroSubhead` | boolean | Use medium subhead (20px with 25px line-height) | - |
| `hideRightColBottomSpacer` | boolean | Hide right column bottom spacer | - |

### Hero Ribbons
| Parameter | Type | Description | Default |
|---|---|---|---|
| `ribbonTop` | boolean | Show ribbon at top | - |
| `ribbonMiddle` | boolean | Show ribbon in middle | - |
| `ribbonBottom` | boolean | Show ribbon at bottom | - |
| `ribbonBgWidth` | string | Ribbon background width | `61.429%` |
| `ribbonMbClass` | string | Ribbon mobile class | `mb-79-16` |

### Hero Caret
| Parameter | Type | Description | Default |
|---|---|---|---|
| `heroCtaCaret` | boolean | Show animated caret | - |
| `heroCtaCaretSrc` | path | Caret animation source | `/res/content/mailings/ck/animated_cta/Black_Carat_Mint_Matte.gif` |
| `heroCaratBgColor` | hex | Caret background color | - |
| `heroCaratBgColorSpacer` | boolean | Show spacer above caret | - |

### Hero7 Specific
| Parameter | Type | Description | Default |
|---|---|---|---|
| `hero7MobileBground` | boolean | Show mobile background image | - |
| `heroCta` | boolean | Enable hero CTA (hero7) | - |
| `heroDisclaimer` | boolean | Show hero disclaimer (hero7) | - |
| `heroDisclaimerFontColor` | hex | Disclaimer text color (hero7) | `#FFFFFF` |
| `heroDisclaimerFontSize` | string | Disclaimer font size (hero7) | `12px` |
| `bureauLogos` | boolean | Show bureau logos (TU & EFX) | - |
| `bureauLogos_tu_only` | boolean | Show TransUnion logo only | - |
| `bureauLogos_efx_only` | boolean | Show Equifax logo only | - |
| `bureauLogosSpacerBottom` | string | Bureau logos bottom spacer | `16px` |
| `afterHeroBureauLogos` | boolean | Show bureau logos after hero | - |
| `afterHeroBureauLogos_tu_only` | boolean | Show TU logo after hero | - |
| `afterHeroBureauLogos_efx_only` | boolean | Show EFX logo after hero | - |

### Hero6 Snipes
| Parameter | Type | Description | Default |
|---|---|---|---|
| `snipes` | boolean | Enable snipes animation | - |
| `snipesBorderColorRed` | boolean | Use red border snipes | - |
| `snipesBorderColorYellow` | boolean | Use yellow border snipes | - |

### HR Line (hero1t)
| Parameter | Type | Description | Default |
|---|---|---|---|
| `hrBgColor` | hex | HR background color | `#ffffff` |
| `hrColor` | hex | HR line color | `#008600` |
| `hrThickness` | string | HR line thickness | `3px` |
| `hrWidth` | string | HR line width | `100%` |
| `hrClass` | string | HR CSS class | - |

## Body Copy Parameters

| Parameter | Type | Description | Default |
|---|---|---|---|
| `bodyCopy` | boolean | Enable body copy section | - |
| `bodyCopyBgColor` | hex | Body copy background color | - |
| `bodyCopyColor` | hex | Body copy text color | `#000000` |
| `bodyCopyFontFamily` | string | Body copy font family | `Arial, sans-serif` |
| `bodyCopyFontSize` | string | Body copy font size | `20px` |
| `bodyCopyTextAlign` | string | Body copy text alignment | `left` |
| `bodyCopyTableClass` | string | Body copy table class | `mb-87` |
| `bodyCopyWidthAttr` | string | Body copy width attribute | `77.8%` |
| `bodyCopyTableWidth` | string | Body copy table width | `77.8%` |
| `bodyCopySpacerTopHide` | boolean | Hide top spacer | - |
| `bodyCopySpacerTopHt` | string | Top spacer height | `16` / `32` |
| `bodyCopySpacerBottomHide` | boolean | Hide bottom spacer | - |
| `bodyCopySpacerBottomHt` | string | Bottom spacer height | `16` |
| `bodyCopyMobileCenter` | boolean | Center on mobile | - |

## CTA (Body) Parameters

| Parameter | Type | Description | Default |
|---|---|---|---|
| `cta` | boolean | Enable body CTA section | - |
| `ctaIsSameAsHero` | boolean | Use hero CTA settings | - |
| `ctaBgColor` | hex | CTA section background color | - |
| `ctaBody` | string | CTA button text | - |
| `ctaLinkUrl` | url | CTA link destination | - |
| `ctaColor` | hex | CTA background color | - |
| `ctaBorderColor` | hex | CTA border color | matches `ctaColor` |
| `ctaFontColor` | hex | CTA text color | `#ffffff` |
| `ctaAlign` | string | CTA alignment | `left` |
| `ctaMobileAlign` | string | CTA mobile alignment | - |
| `ctaSpacerTopHt` | string | CTA top spacer height | `16` |
| `ctaSpacerBottomHt` | string | CTA bottom spacer height | `16` |
| `ctaSpacerBottomHide` | boolean | Hide CTA bottom spacer | - |
| `ctawidth` | string | CTA button width | `268` |
| `bodyIconCtaImgSrc` | path | Icon inside body CTA | - |
| `bodyIconCtaImgWidth` | string | Body CTA icon width | `21` |
| `bodyIconCtaImgAltText` | string | Body CTA icon alt text | `img` |

### Body Hyperlink CTA
| Parameter | Type | Description | Default |
|---|---|---|---|
| `bodyHyperlinkCTA` | boolean | Enable body hyperlink CTA | - |
| `bodyHyperlinkCTABody` | string | Hyperlink text | - |
| `bodyHyperlinkCTAUrl` | url | Hyperlink destination | - |
| `bodyHyperlinkCTAFontColor` | hex | Hyperlink text color | `#000000` |

### Partner Disclaimers
| Parameter | Type | Description | Default |
|---|---|---|---|
| `partnerDisclaimer` | boolean | Enable partner disclaimer | - |
| `disclosureAboveCta` | boolean | Show disclosure above CTA | - |
| `disclosureBelowCta` | boolean | Show disclosure below CTA | - |
| `disclosureAboveHeroCta` | boolean | Show disclosure above hero CTA | - |
| `disclosureBelowHeroCta` | boolean | Show disclosure below hero CTA | - |

## Disclaimer Parameters

### Main Disclaimer
| Parameter | Type | Description | Default |
|---|---|---|---|
| `disclaimer` | boolean | Enable main disclaimer section | - |
| `disclaimerBgColor` | hex | Disclaimer background color | - |
| `disclaimerTextColor` | hex | Disclaimer text color | `#373737` (brand2025) / `#6E7677` |
| `disclaimerTextAlign` | string | Disclaimer text alignment | `left` |
| `disclaimerSpacerTopHt` | string | Top spacer height | `0` |
| `disclaimerSpacerBottomHt` | string | Bottom spacer height | `32` |
| `disclaimerSpacerBottomHide` | boolean | Hide bottom spacer | - |
| `lightBg` | boolean | Light background mode | - |

### Hero Disclaimer
| Parameter | Type | Description | Default |
|---|---|---|---|
| `disclaimerHero` | boolean | Enable hero disclaimer section | - |
| `disclaimerHeroBgColor` | hex | Hero disclaimer background | - |
| `disclaimerTextColor` | hex | Hero disclaimer text color | `#373737` / `#6E7677` |
| `disclaimerHeroTextAlign` | string | Hero disclaimer text align | `center` |
| `disclaimerHeroSpacerTopHt` | string | Top spacer height | `16` |
| `disclaimerHeroSpacerBottomHt` | string | Bottom spacer height | `0` |

## Logo Parameters

| Parameter | Type | Description | Default |
|---|---|---|---|
| `showCkIntuitLogo` | boolean | Show CK Intuit logo | - |
| `hideLogo` | boolean | Hide all logos | - |
| `ckmTTLogo` | boolean | Show CK + TurboTax logo | - |
| `ckFreeTaxLogo` | boolean | Show CK Free Tax logo | - |
| `ckLogoMoney` | boolean | Show CK Money logo | - |
| `ckPlusLogo` | boolean | Show CK Plus logo | - |
| `intuitCKHL` | boolean | Show Intuit CK HL logo | - |
| `heroLogoAlignLeft` | boolean | Align logo left | - |
| `mobileLogoLeft` | boolean | Align logo left on mobile | - |
| `mobileLogoCenter` | boolean | Center logo on mobile | - |

## Sender Parameters

| Parameter | Type | Description | Default | Note |
|---|---|---|---|---|
| `senderNameHuman` | string | Email sender name | `Credit Karma` | Use `Credit Karma Money` when user specifies |

## Gmail Annotation Parameters

| Parameter | Type | Description | Default |
|---|---|---|---|
| `gmailAnnotation` | boolean | Enable Gmail annotation | - |
| `gmailAnnotation_singleImage` | boolean | Use single image annotation | - |
| `gmailAnnotation_imageUrl` | path | Annotation image path | - |
| `gmailAnnotation_promoUrl` | url | Annotation promo link | - |

## Footer Configuration Options

| Category | HTML Flag (bodyHTMLSections) | Text Partial (bodyTextSections) |
|---|---|---|
| CK Transactional Emails | `1_ck_transactional=true` | `{{> common/footers/us/categories/1_ck_transactional_text }}` |
| Generic CK Marketing | `3_ck_generic=true` | `{{> common/footers/us/categories/3_ck_generic_text }}` |
| Credit Cards & Special Offers Marketing | `4_ck_cards_special_offers=true` | `{{> common/footers/us/categories/4_ck_cards_special_offers_text }}` |
| Home Marketing | `5_ck_home=true` | `{{> common/footers/us/categories/5_ck_home_text }}` |
| Personal Loans Marketing | `6_ck_personal_loans=true` | `{{> common/footers/us/categories/6_ck_personal_loans_text }}` |
| Auto Insurance Marketing | `7_ck_auto=true` | `{{> common/footers/us/categories/7_ck_auto_text }}` |
| Multicategory Marketing | `8_ck_revenue_multicategory=true` | `{{> common/footers/us/categories/8_ck_revenue_multicategory_text }}` |
| CKM Transactional Emails | `10_ckm_transactional=true` | `{{> common/footers/us/categories/10_ckm_transactional_text }}` |
| CK Networth Marketing | `11_ck_networth=true` | `{{> common/footers/us/categories/11_ck_networth_text }}` |

## Inline Partial Insert Slots

| Partial Name | Placement | Usage |
|---|---|---|
| `afterHeroInsert` | Between hero section and body copy | Insert custom content after hero |
| `afterBodyCopyInsert` | After body copy | Commonly used for modA/modB/modC modules |
| `afterCtaInsert` | After CTA button | Insert custom content after CTA |
| `beforeHeroInsert` | Before hero section | Insert custom content before hero |
| `afterLogoInsert` | After logo section | Insert custom content after logo |
| `afterDisclaimerInsert` | After disclaimer section | Insert custom content after disclaimer |

## Preferences Values (email/payload.json)

Use one of the following values for the `preferences` property:

- `"credit monitoring"` — for credit monitoring campaigns
- `"id monitoring"` — for ID monitoring campaigns
- `"accounts monitoring"` — for accounts monitoring campaigns
- `"financial tips"` — for financial tips campaigns
- `"home"` — for home campaigns
- `"auto"` — for auto insurance campaigns
- `"taxes"` — for taxes campaigns
- `"credit cards"` — for credit card campaigns
- `"personal loans"` — for personal loans campaigns
- `"savings"` — for savings campaigns
- `"checking"` — for checking/CKM campaigns
- `"special offers"` — for special offers campaigns
- `"monitoring"` — for monitoring campaigns
- `"promotions"` — for promotions campaigns
- `"third party promotions"` — for third party promotions campaigns
- `"education"` — for education campaigns
- `"net worth"` — for net worth campaigns
- `"reminders and updates"` — for reminders and updates campaigns

## Color Palette (Approved Hex Values)

The following hex values are approved for use in color parameters:

### Primary Colors
- `#000000` - Black
- `#02380d` - Dark Green
- `#008600` - Karma Green
- `#6ade19` - Light Green
- `#f4f4ef` - Tofu
- `#ffffff` - White
- `#89fe45` - Neon Green

### Secondary Colors
- `#f9c740` - Honey
- `#ff77c7` - Dragonfruit
- `#3592ef` - Blueberry

### Other Colors
- `#132f00` - Dark Forest
- `#009cc1` - Sky
- `#ff5e00` - Sunset
- `#7039a3` - Royal
- `#4b2e00` - Redwood
- `#ffc300` - Butter
- `#0077db` - Cerulean
- `#b68c50` - Autumn Gold
- `#52c800` - Spring
- `#e9eef0` - Light Gray
- `#373737` - Dark Gray
- `#f6f2db` - Cream
- `#005b13` - Muir
- `#002356` - Pacific
- `#f5f6f6` - Light Background Gray
