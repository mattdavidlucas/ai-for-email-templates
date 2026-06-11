# Marketing Template Builder

## Overview

This command builds production-ready email and push templates from a user provided marketing copy document. It will be used by Campaign Operations Specialists.

### Step 1: Clone `_examples/campaign_starter`

Execute the below bash function to clone our boilerplate template to new, user defined path and campaign name.

```bash
gostarter() {
  # Purpose: Clones a starter template and its payload, updates
  #          paths within .hbs files (project dir), replaces "starter"
  #          text with campaign name (project dir .hbs files), and then
  #          replaces "starter" text in files within the payload directory.
  #
  # Usage: gostarter <template_path> <campaign_name>
  #
  # Arguments:
  #   $1 (template_path): The name for the new project directory.
  #   $2 (campaign_name):     The campaign name to replace "starter" text with.
  #
  # Environment Variables:
  #   MAES_HOME_DIR: Should be set to the path where your MAES projects reside.

  # --- Configuration ---
  local template_path="$1"
  local campaign_name="$2"
  
  local source_template_dir="_examples/campaign_starter"
  local source_payload_dir="payloads/_examples/campaign_starter"
  
  local string_to_replace_in_hbs="_examples/campaign_starter"
  local text_to_replace_with_campaign_name="starter"

  # --- Input Validation ---
  if [[ -z "${template_path}" ]]; then
    echo "Error: New template path (parameter 1) is required." >&2
    echo "Usage: gostarter <template_path> <campaign_name>" >&2
    return 1
  fi
  if [[ -z "${campaign_name}" ]]; then
    echo "Error: Campaign name (parameter 2) is required." >&2
    echo "Usage: gostarter <template_path> <campaign_name>" >&2
    return 1
  fi

  if [[ -z "${MAES_HOME_DIR}" ]]; then
    echo "Error: MAES_HOME_DIR environment variable is not set." >&2
    echo "Please set it (e.g., export MAES_HOME_DIR=\"/Sites/maes/\")." >&2
    return 1
  fi

  # --- Path Construction ---
  local base_path_maes="${HOME}${MAES_HOME_DIR}"
  if [[ "${base_path_maes: -1}" != "/" ]]; then
    base_path_maes+="/"
  fi

  local target_project_dir="${base_path_maes}${template_path}"
  local target_payload_dir="${base_path_maes}payloads/${template_path}"
  local final_cd_destination="${base_path_maes}"

  echo "--- 🚀 Starting gostarter for project: ${template_path}, campaign: ${campaign_name} ---"

  # --- Step 1: Copy starter template ---
  echo "📂 Copying template from '${source_template_dir}' to '${target_project_dir}'..."
  if cp -R "${source_template_dir}" "${target_project_dir}"; then
    echo "✅ Template copied successfully."
  else
    echo "❌ Error: Failed to copy template directory." >&2
    return 1
  fi

  # --- Step 2: Copy starter payload ---
  echo "📦 Copying payload from '${source_payload_dir}' to '${target_payload_dir}'..."
  if mkdir -p "$(dirname "${target_payload_dir}")"; then
    if cp -R "${source_payload_dir}" "${target_payload_dir}"; then
      echo "✅ Payload copied successfully."
    else
      echo "❌ Error: Failed to copy payload directory." >&2
      return 1
    fi
  else
    echo "❌ Error: Failed to create parent directory for payloads: $(dirname "${target_payload_dir}")" >&2
    return 1
  fi

  # --- Step 3: Navigate to the new project directory ---
  echo "⤵️ Changing directory to '${target_project_dir}'..."
  if ! cd "${target_project_dir}"; then
    echo "❌ Error: Failed to change directory to '${target_project_dir}'." >&2
    return 1
  fi
  echo "📍 Current directory: $(pwd)" # This is target_project_dir

  # --- Step 4: Update paths in .hbs files (PROJECT DIR) ---
  echo "✏️ Updating paths in .hbs files (Project Directory)..."
  local escaped_template_path
  escaped_template_path=$(printf '%s' "${template_path}" | sed -e 's/\\/\\\\/g' -e 's/%/\\%/g' -e 's/&/\\&/g')

  echo "   🔍 Searching for path: '${string_to_replace_in_hbs}'"
  echo "   ✨ Replacing with project name: '${template_path}' (Escaped: '${escaped_template_path}')"
  
  find . -type f -name '*.hbs' -print0 | xargs -0 sed -i "" "s%${string_to_replace_in_hbs}%${escaped_template_path}%g"
  local path_sed_status=$?
  if [[ ${path_sed_status} -ne 0 ]]; then
      echo "⚠️ Warning: Path replacement in .hbs (Project Dir) exited with status ${path_sed_status}." >&2
  else
    echo "✅ Path updates for project name in .hbs (Project Dir) completed."
  fi

  # --- Step 5: Replace "${text_to_replace_with_campaign_name}" text in .hbs files (PROJECT DIR) ---
  echo "✏️ Replacing '${text_to_replace_with_campaign_name}' with campaign name in .hbs files (Project Directory)..."
  local escaped_campaign_name # Define and escape campaign_name once for all sed uses
  escaped_campaign_name=$(printf '%s' "${campaign_name}" | sed -e 's/\\/\\\\/g' -e 's/%/\\%/g' -e 's/&/\\&/g')

  echo "   🔍 Searching for text: '${text_to_replace_with_campaign_name}'"
  echo "   ✨ Replacing with campaign name: '${campaign_name}' (Escaped: '${escaped_campaign_name}')"

  find . -type f -name '*.hbs' -print0 | xargs -0 sed -i "" "s%${text_to_replace_with_campaign_name}%${escaped_campaign_name}%g"
  local campaign_sed_hbs_status=$?
  if [[ ${campaign_sed_hbs_status} -ne 0 ]]; then
      echo "⚠️ Warning: Text replacement in .hbs (Project Dir) exited with status ${campaign_sed_hbs_status}." >&2
  else
    echo "✅ Text updates for campaign name in .hbs (Project Dir) completed."
  fi

  # --- Step 6: Replace "${text_to_replace_with_campaign_name}" text in PAYLOAD files ---
  echo "✏️ Replacing '${text_to_replace_with_campaign_name}' with campaign name in PAYLOAD files..."
  echo "   Targeting directory: '${target_payload_dir}'"
  # Note: escaped_campaign_name is already defined from Step 5.
  echo "   🔍 Searching for text: '${text_to_replace_with_campaign_name}'"
  echo "   ✨ Replacing with campaign name: '${campaign_name}' (Escaped: '${escaped_campaign_name}')"
  
  echo "   ❗ IMPORTANT: This operation targets ALL regular files in the payload directory ('${target_payload_dir}')."
  echo "      If the payload contains binary files, 'sed' might corrupt them if 'starter' appears as a byte sequence."
  echo "      To target specific text files, modify the 'find' command below, e.g.:"
  echo "      find \"${target_payload_dir}\" -type f \\( -name \"*.txt\" -o -name \"*.json\" \\) -print0 | xargs ..."

  # Current directory is still target_project_dir. We target payload files by specifying the path.
  find "${target_payload_dir}" -type f -print0 | xargs -0 sed -i "" "s%${text_to_replace_with_campaign_name}%${escaped_campaign_name}%g"
  local payload_campaign_sed_status=$?
  if [[ ${payload_campaign_sed_status} -ne 0 ]]; then
      echo "⚠️ Warning: Text replacement in PAYLOAD files exited with status ${payload_campaign_sed_status}." >&2
      echo "   This could be due to permissions or 'sed' attempting to modify binary files." >&2
  else
    echo "✅ Text updates for campaign name in PAYLOAD files completed."
  fi

  # --- Step 7: Navigate back ---
  # Current directory is still target_project_dir from Step 3.
  echo "⤴️ Changing directory back to '${final_cd_destination}' from '$(pwd)'..."
  if ! cd "${final_cd_destination}"; then
    echo "⚠️ Warning: Failed to change directory to '${final_cd_destination}'. Returning to HOME directory." >&2
    cd "${HOME}" || return 1 # Fallback to HOME
  fi
  echo "📍 Current directory: $(pwd)"

  echo "--- 🎉 gostarter for project: ${template_path}, campaign: ${campaign_name} completed successfully! ---"
  return 0
}
```

### Step 2: Prompt User for Template Path and Campaign Name

Ask the user to provide:
1. **Template Path**: The directory path for the new campaign (e.g., `test/sandbox/your-name/campaign-name`)
2. **Campaign Name**: The campaign identifier (e.g., `campaign-name`)

Execute the `gostarter` function with these parameters.

### Step 3: Prompt User for Design Parameters

Before collecting marketing copy, prompt the user for the following design parameters that will be applied to all files in `bodyHTMLSections`:

1. **heroBgColor**: Hero section background color (hex value, e.g., `#005b13`)
2. **heroHeadlineFontColor**: Hero headline text color (hex value, e.g., `#FFFFFF`)
3. **heroSubheadFontColor**: Hero subheadline text color (hex value, e.g., `#FFFFFF`)
4. **heroLinkUrl**: Hero CTA link URL (must start with `https://`)
5. **heroCtaColor**: Hero CTA button color (hex value, e.g., `#ffc300`)
6. **heroCtaFontColor**: Hero CTA button text color (hex value, e.g., `#000000`)
7. **heroImgSrc**: Hero image path to append to `/res/content/mailings/ck/` (e.g., `image-name.png`)
8. **heroMobileImgSrc**: Hero mobile image path to append to `/res/content/mailings/ck/` (e.g., `image-name-mobile.png`)

**Note**: If the user doesn't provide values, use these defaults:
- heroBgColor: `#005b13`
- heroHeadlineFontColor: `#FFFFFF`
- heroSubheadFontColor: `#FFFFFF`
- heroLinkUrl: `https://www.creditkarma.com/u/`
- heroCtaColor: `#ffc300`
- heroCtaFontColor: `#000000`
- heroImgSrc: `/res/content/mailings/ck/`
- heroMobileImgSrc: `/res/content/mailings/ck/`

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
   - Convert single curly braces `{macro}` to double curly braces `{{macro}}`
   - Convert straight brackets `[macro]` to double curly braces `{{macro}}`
   - Remove trailing empty lines

2. **Update Preheaders**:
   - If no personalization macros, update `email/preheaders.json` as a JSON array
   - If personalization macros exist, create separate `.hbs` files in `email/preheaders/` directory
   - Remove trailing empty lines

3. **Update Headlines**:
   - If personalization macros exist, create separate `.hbs` files in `email/headlines/` directory
   - If directory is created, update references to use `ck:varyBig` instead of `ck:variant`
   - Convert macros to double curly braces `{{macro}}`
   - Remove trailing empty lines

4. **Update Subheadlines**:
   - If personalization macros exist, create separate `.hbs` files in `email/subheadlines/` directory
   - If directory is created, update references to use `ck:varyBig` instead of `ck:variant`
   - Convert macros to double curly braces `{{macro}}`
   - Remove trailing empty lines

5. **Update CTAs**:
   - If personalization macros exist, create separate `.hbs` files in `email/ctas/` directory
   - If directory is created, update references to use `ck:varyBig` instead of `ck:variant`
   - Convert macros to double curly braces `{{macro}}`
   - Remove trailing empty lines

6. **Update Body Copy**:
   - Create separate files in `email/bodyHTMLSections/` for each body copy variant (0.hbs, 1.hbs, 2.hbs, etc.)
   - Apply the design parameters collected in Step 3 to all bodyHTMLSections files
   - Convert macros to double curly braces `{{macro}}`
   - Set `disclaimer=false` if no disclaimer provided, or `disclaimer=true` with `disclaimerText` inline partial if provided
   - Remove trailing empty lines

7. **Update Body Text Sections**:
   - Create corresponding files in `email/bodyTextSections/` for each variant
   - Keep empty lines between paragraphs (do NOT convert to `<br><br>`)
   - Convert macros to double curly braces `{{macro}}`
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

### Step 7: Final Validation

Verify that:
- ✅ All personalization macros use double curly braces `{{}}` or triple curly braces `{{{}}}`
- ✅ No trailing empty lines at end of any files
- ✅ All color parameters start with `#`
- ✅ All URL parameters start with `https://`
- ✅ Darwin experiment helpers (`ck:varyBig` and `ck:variant`) are used correctly:
  - `ck:varyBig` for directories of `.hbs` files
  - `ck:variant` for individual `.json` files
- ✅ All HTML tags are properly closed
- ✅ Design system layout is properly configured with provided design parameters

### Best Practices Enforced

- No trailing empty lines in any files
- Proper macro formatting: `{{macro}}` for HTML, `{{{macro}}}` for text
- Correct Darwin experiment helper usage
- Valid hex color values
- Valid HTTPS URLs
- Design system layout with `brand2025=true`
- Proper footer configuration
