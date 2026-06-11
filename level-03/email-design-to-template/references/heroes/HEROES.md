# Hero Variant Visual Descriptions

Use this file to match a screenshot's layout to the correct hero variant. Each entry describes what the hero looks like, how to distinguish it from similar variants, and which parameters are unique to it.

---

## Hero Decision Tree

**Start here to narrow down the variant:**

1. **Does the hero have an image?**
   - No image at all → go to step 2
   - Image only, no text → **hero0**
   - Image + text → go to step 3

2. **Text-only hero (no image). What's the layout?**
   - Centered headline with a small icon/symbol above it → **hero2**
   - Text with a horizontal rule (thick line) separator near the top → **hero1t**
   - Text with a light background, standard left-aligned layout, no separator → **hero1** or **hero1b**
     - If the headline is noticeably centered → **hero1b**
     - Otherwise → **hero1**

3. **Image + text hero. Is the layout side-by-side (image and text next to each other horizontally)?**
   - Yes, side-by-side → go to step 4
   - No, image and text are stacked vertically → go to step 5

4. **Side-by-side layout. How large is the image relative to the text column?**
   - Image takes roughly half the width, comparable to the text column → **hero5**
   - Image is noticeably smaller than the text column (small thumbnail or icon-sized image on the right) → **hero7**

5. **Vertically stacked image + text. Is the text above or below the image?**
   - Text block is above the image → **hero4**
   - Text block is below the image → go to step 6

6. **Text below image. Is the text inside the image frame or below it?**
   - Text appears overlaid or embedded within/immediately below a full-width image, image bleeds to full email width, layout feels cinematic → **hero6**
   - Text is clearly below a contained image, image has visible padding/borders around it, text is in its own distinct section → **hero3**

---

## hero0 — Image Only

**What it looks like:**
The entire hero area is a single image. No headline, subheadline, or CTA button is visible as separate elements — all text is baked into the image artwork itself. The image spans the full width of the email.

**Key visual signals:**
- No separate text elements above or below the image
- The image is the full hero content
- Often used for announcement or brand campaigns where the design team controls all visual elements

**Unique parameter:**
- Uses `heroImgMobileSrc` (not `heroMobileImgSrc`) for the mobile image path

**Parameters typically used:**
```
hero0=true
heroImgSrc="/res/content/mailings/ck/{filename}"
heroImgMobileSrc="/res/content/mailings/ck/{filename}"
heroLinkUrl="https://www.creditkarma.com/u/"
```

---

## hero1 — Text Only, Left-Aligned

**What it looks like:**
A text-only hero with no image. Headline and subheadline are left-aligned (or optionally centered). Typically has a solid color background. May include a button CTA or a hyperlink CTA. No image panel.

**Key visual signals:**
- No image in the hero
- Text is predominantly left-aligned
- Clean, open layout with just text and optional CTA
- Background is typically a solid color

**Distinguishing from hero1b:** hero1 defaults to left alignment; hero1b has a centered alignment option as its design intent.
**Distinguishing from hero1t:** hero1 has no horizontal rule separator near the top.

**Parameters typically used:**
```
hero1=true
heroBgColor="#005b13"
heroHeadlineFontColor="#FFFFFF"
heroSubheadFontColor="#FFFFFF"
heroSubhead=true
heroLinkUrl="https://www.creditkarma.com/u/"
heroCtaBody=(ck:variant ...)
heroCtaColor="#ffc300"
heroCtaFontColor="#000000"
```

---

## hero1b — Text Only, Centered Option

**What it looks like:**
Similar to hero1 but with a layout designed for centered alignment. Headline is centered on the page. No image. May include a button CTA. Clean background.

**Key visual signals:**
- No image
- Headline and content are visually centered in the hero
- Otherwise similar to hero1

**Parameters typically used:**
```
hero1b=true
heroBgColor="#005b13"
heroHeadlineFontColor="#FFFFFF"
```

---

## hero1t — Text Only with Horizontal Rule

**What it looks like:**
A text-only hero featuring a thick horizontal rule (colored line) near the top, above the headline. Acts as a visual separator or accent. No image.

**Key visual signals:**
- A clearly visible thick horizontal line above or near the headline
- Line typically matches the brand green or another accent color
- No image panel

**Unique parameters:**
```
hrBgColor="#ffffff"
hrColor="#008600"
hrThickness="3px"
hrWidth="100%"
```

**Parameters typically used:**
```
hero1t=true
heroBgColor="#ffffff"
heroHeadlineFontColor="#000000"
```

---

## hero2 — Text Centered with Icon

**What it looks like:**
A text-only hero where the content is centered on the page and a small icon or symbol image appears above the headline. The layout feels balanced and symmetrical. No large image panel.

**Key visual signals:**
- Small icon/symbol centered above the headline
- Everything is centered (headline, subheadline, CTA)
- No large background image or side image

**Unique parameters:**
```
heroIconSrc="/res/content/mailings/ck/{icon-filename}"
heroIconAltText="Symbol"
```

**Parameters typically used:**
```
hero2=true
heroBgColor="#005b13"
heroHeadlineFontColor="#FFFFFF"
heroSubhead=true
```

---

## hero3 — Image Above, Text Below (Contained)

**What it looks like:**
The image is at the top of the hero, followed by text (headline, subheadline, CTA) below it. The image has visible spacing/containment — it doesn't bleed all the way to the edges. The text section is clearly a separate block underneath.

**Key visual signals:**
- Image is in the upper portion, text is in the lower portion
- Image feels contained (has padding or borders around it, or clear visual separation from the text)
- Layout feels like image → text from top to bottom
- CTA button appears at the bottom of the hero, below the text

**Distinguishing from hero6:** hero3 feels more contained; the image has defined boundaries. hero6 feels more cinematic with a full-bleed image.

**Parameters typically used:**
```
hero3=true
heroBgColor="#005b13"
heroHeadlineFontColor="#FFFFFF"
heroSubhead=true
heroImgSrc="/res/content/mailings/ck/{filename}"
heroMobileImgSrc="/res/content/mailings/ck/{filename}"
```

---

## hero4 — Text Above, Image Below

**What it looks like:**
The text (headline, subheadline, CTA button) appears in the upper portion of the hero, and the image fills the lower portion. This is the most common layout for standard marketing emails.

**Key visual signals:**
- Headline and CTA are in the top half of the hero
- Image is in the bottom half or spans the bottom portion
- CTA button appears between the text and image, or at the top of the image area
- Very common: green background in the text section, illustration image below

**Distinguishing from hero3:** hero4 has text on top, image on bottom. hero3 has image on top, text on bottom.

**Parameters typically used:**
```
hero4=true
heroBgColor="#005b13"
heroHeadlineFontColor="#FFFFFF"
heroSubheadFontColor="#FFFFFF"
heroSubhead=true
heroLinkUrl="https://www.creditkarma.com/u/"
heroCtaBody=(ck:variant ...)
heroCtaColor="#ffc300"
heroCtaFontColor="#000000"
heroImgSrc="/res/content/mailings/ck/{filename}"
heroMobileImgSrc="/res/content/mailings/ck/{filename}"
```

---

## hero5 — Side by Side (Equal Columns)

**What it looks like:**
Text and image appear side by side in two roughly equal-width columns. On desktop, image is on the right and text is on the left. On mobile, they stack vertically.

**Key visual signals:**
- Two-column layout: text left, image right
- Columns are roughly equal in width
- Image is a significant portion of the hero (not a small thumbnail)
- Layout feels balanced, like a two-panel design

**Distinguishing from hero7:** In hero5, the image column is comparable in size to the text column. In hero7, the image is noticeably smaller.

**Parameters typically used:**
```
hero5=true
heroBgColor="#005b13"
heroHeadlineFontColor="#FFFFFF"
heroSubhead=true
heroImgSrc="/res/content/mailings/ck/{filename}"
heroMobileImgSrc="/res/content/mailings/ck/{filename}"
```

---

## hero6 — Full-Width Image, Text Below (Cinematic)

**What it looks like:**
A full-bleed, edge-to-edge image at the top that feels cinematic or immersive. Text (headline, subheadline, CTA) appears below the image in its own distinct section. The image is wide and dramatic.

**Key visual signals:**
- Image bleeds to the full width of the email with no padding
- Image feels large and dominant
- Text section is clearly below and separate from the image
- Sometimes includes animated "snipes" elements (small animated badges or flourishes)

**Distinguishing from hero3:** hero6 feels more cinematic; the image is full-bleed. hero3 feels more contained.

**Unique parameters (if snipes are present):**
```
snipes=true
snipesBorderColorRed=true   (or snipesBorderColorYellow=true)
```

**Parameters typically used:**
```
hero6=true
heroBgColor="#005b13"
heroHeadlineFontColor="#FFFFFF"
heroImgSrc="/res/content/mailings/ck/{filename}"
heroMobileImgSrc="/res/content/mailings/ck/{filename}"
```

---

## hero7 — Side by Side with Small Image (Eyebrow / Bureau Logos)

**What it looks like:**
Two-column layout where the text column is dominant and the image on the right is noticeably smaller — more like a product image or icon-scale illustration rather than a large hero image. May include eyebrow text with a small icon above the headline, and/or bureau logos (TransUnion, Equifax) in the text column.

**Key visual signals:**
- Two-column layout: text left, small image right
- The image is clearly smaller than the text column
- May have a small "eyebrow" label with an icon above the headline
- May show credit bureau logos (TU, EFX) in the text area

**Distinguishing from hero5:** In hero7, the image is small relative to the text column. In hero5, columns are more equal.

**Unique parameters:**
```
heroEyebrow=true
heroEyebrowFontColor="#000000"
heroEyebrowIconSrc="/res/content/mailings/ck/{icon-filename}"
bureauLogos=true           (both TU and EFX)
bureauLogos_tu_only=true   (TransUnion only)
bureauLogos_efx_only=true  (Equifax only)
```

**Parameters typically used:**
```
hero7=true
heroBgColor="#005b13"
heroHeadlineFontColor="#FFFFFF"
heroImgSrc="/res/content/mailings/ck/{filename}"
```
