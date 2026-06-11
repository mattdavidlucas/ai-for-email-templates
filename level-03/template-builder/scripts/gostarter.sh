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