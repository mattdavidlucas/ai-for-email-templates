# Function to find and replace text in files within a directory
goreplace() {
    local dir_path find_text replace_text confirmation
    local escaped_find_text escaped_replace_text
    local find_cmd_base # Array to hold the base find command

    # 1. Prompt for the directory path
    read -r -p "Enter the path of the directory: " dir_path

    # 2. Validate the directory path
    if [ ! -d "$dir_path" ]; then
        echo "❌ Error: Directory '$dir_path' not found."
        return 1
    fi

    # 3. Prompt for the text to find
    read -r -p "Enter the text to find: " find_text

    # 4. Validate "text to find" (cannot be empty)
    if [ -z "$find_text" ]; then
        echo "❌ Error: 'Text to find' cannot be empty."
        return 1
    fi

    # 5. Prompt for the replacement text
    read -r -p "Enter the replacement text: " replace_text

    # 6. Confirmation prompt (updated warning)
    echo ""
    echo "🛑 DANGER ZONE! 🛑"
    echo "You are about to perform the following replacement in all applicable files under '$dir_path'."
    echo "This operation will modify files directly WITHOUT creating backups."
    echo "It will also IGNORE '.DS_Store' files."
    echo ""
    echo "   FIND:    '$find_text'"
    echo "   REPLACE: '$replace_text'"
    echo ""
    read -r -p "Are you absolutely sure you want to proceed? (yes/no): " confirmation

    if [[ "$confirmation" != "yes" ]]; then
        echo "ℹ️ Operation cancelled by user."
        return 0
    fi

    echo "⏳ Processing (modifying files directly, no backups)..."

    # 7. Escape find_text and replace_text for sed
    escaped_find_text=$(echo "$find_text" | sed -e 's/\\/\\\\/g' -e 's/#/\\#/g' -e 's/[\^\$\.\[\*\]]/\\&/g')
    escaped_replace_text=$(echo "$replace_text" | sed -e 's/\\/\\\\/g' -e 's/#/\\#/g' -e 's/&/\\&/g')

    # 8. Build the base find command, excluding .DS_Store files
    # -type f: only regular files
    # -not -name ".DS_Store": exclude files named .DS_Store
    find_cmd_base=(find "$dir_path" -type f -not -name ".DS_Store")

    # 9. Find and replace using find and sed (NO BACKUPS)
    #    The sed -i command behaves differently on GNU (Linux) vs BSD (macOS)
    #    GNU sed: -i without an argument means no backup.
    #    BSD sed: -i requires an argument; -i "" means no backup (empty string).
    if [[ "$(uname)" == "Darwin" ]]; then # Darwin is macOS
        "${find_cmd_base[@]}" -exec sed -i "" "s#${escaped_find_text}#${escaped_replace_text}#g" {} +
    else # Assuming GNU sed for Linux and other systems
        "${find_cmd_base[@]}" -exec sed -i "s#${escaped_find_text}#${escaped_replace_text}#g" {} +
    fi

    echo "✅ Replacement complete!"
    echo "ℹ️ Files were modified directly. No backup files were created."
}