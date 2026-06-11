# Use for cloning existing templates to new paths
goclone() {
  # --- 1. Environment Variable Validation ---
  if [ -z "${MAES_HOME_DIR}" ]; then
    echo "Error: MAES_HOME_DIR environment variable is not set."
    echo "Please set it, e.g., export MAES_HOME_DIR=\"/Sites/maes_template-manager/templates/\""
    return 1
  fi

  # --- 2. Get Campaign Names via Prompts ---
  local old_campaign_name
  local new_campaign_name

  read -p "Enter the OLD campaign name (source directory name and text to replace): " old_campaign_name
  if [ -z "${old_campaign_name}" ]; then
    echo "Error: Old campaign name cannot be empty."
    return 1
  fi

  read -p "Enter the NEW campaign name (destination directory name and replacement text): " new_campaign_name
  if [ -z "${new_campaign_name}" ]; then
    echo "Error: New campaign name cannot be empty."
    return 1
  fi

  if [ "${old_campaign_name}" == "${new_campaign_name}" ]; then
    echo "Error: Old and new campaign names cannot be the same. No changes to make."
    return 1
  fi

  # Use prompted names for source and destination operations
  local source_name="${old_campaign_name}"
  local dest_name="${new_campaign_name}"

  # --- 3. Define Paths ---
  # Construct the full base path, ensuring no double slashes
  local base_dir="${HOME%/}/${MAES_HOME_DIR%/}" # Removes trailing slash from HOME and MAES_HOME_DIR

  local source_template_dir="${base_dir}/${source_name}"
  local dest_template_dir="${base_dir}/${dest_name}"
  local source_payloads_dir="${base_dir}/payloads/${source_name}"
  local dest_payloads_dir="${base_dir}/payloads/${dest_name}"

  # --- 4. Pre-flight Checks ---
  if [ ! -d "${source_template_dir}" ]; then
    echo "Error: Source template directory not found: ${source_template_dir}"
    echo "Please ensure the old campaign name matches an existing directory."
    return 1
  fi

  if [ ! -d "${source_payloads_dir}" ]; then
    echo "Error: Source payloads directory not found: ${source_payloads_dir}"
    # This might be an acceptable scenario if payloads are optional.
    # For now, keeping it as an error for consistency.
    # If payloads can be optional, this check might need adjustment.
    return 1
  fi

  if [ -d "${dest_template_dir}" ]; then
    echo "Error: Destination template directory already exists: ${dest_template_dir}"
    echo "Please choose a new campaign name that doesn't already exist."
    return 1
  fi

  if [ -d "${dest_payloads_dir}" ]; then
    echo "Error: Destination payloads directory already exists: ${dest_payloads_dir}"
    return 1
  fi

  echo # Newline for better readability after prompts
  echo "Attempting to clone template for campaign '${source_name}' to '${dest_name}'..."
  echo "Source template: ${source_template_dir}"
  echo "Destination template: ${dest_template_dir}"
  echo "Source payloads: ${source_payloads_dir}"
  echo "Destination payloads: ${dest_payloads_dir}"

  # --- 5. Perform Cloning Operations ---
  echo "Copying template directory..."
  if ! cp -r "${source_template_dir}" "${dest_template_dir}"; then
    echo "Error: Failed to copy template directory from '${source_template_dir}' to '${dest_template_dir}'."
    return 1
  fi

  echo "Copying payloads directory..."
  if ! cp -r "${source_payloads_dir}" "${dest_payloads_dir}"; then
    echo "Error: Failed to copy payloads directory from '${source_payloads_dir}' to '${dest_payloads_dir}'."
    echo "Cleaning up partially cloned template directory: ${dest_template_dir}"
    rm -rf "${dest_template_dir}"
    return 1
  fi

  # --- 6. Update Contents ---
  echo "Changing directory to: ${dest_template_dir}"
  if ! cd "${dest_template_dir}"; then
    echo "Error: Failed to change directory to '${dest_template_dir}'."
    echo "Cleaning up cloned directories..."
    rm -rf "${dest_template_dir}"
    rm -rf "${dest_payloads_dir}"
    return 1
  fi

  echo "Replacing all occurrences of '${source_name}' with '${dest_name}' in .hbs files within '${dest_template_dir}'..."
  # sed -i "" is for BSD/macOS sed. For GNU sed, use sed -i "s%...%...%g" or sed -i.bak "s%...%...%g"
  find . -name '*.hbs' -print0 | xargs -0 sed -i "" "s%${source_name}%${dest_name}%g"
  if [ $? -ne 0 ]; then
      echo "Error: 'sed' command failed to replace content in .hbs files."
      echo "The directories have been copied, but content replacement failed."
      echo "Changing directory back to: ${base_dir}"
      if ! cd "${base_dir}"; then
        echo "Warning: Failed to change directory back to '${base_dir}'. Current directory: $(pwd)"
      fi
      return 1
  fi
  echo "Content replacement successful."

  # --- 7. Return to MAES Home Directory ---
  echo "Changing directory back to: ${base_dir}"
  if ! cd "${base_dir}"; then
    echo "Warning: Failed to change directory back to '${base_dir}'. Current directory: $(pwd)"
  fi

  echo "✅ Template for campaign '${source_name}' successfully cloned and updated to '${dest_name}'."
  return 0
}