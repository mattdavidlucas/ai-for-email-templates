# Use for splitting multiple lines of text into single varyBig variants;
# Will output into numbered .hbs files
gosplit() {
  # Parameters:
  # $1: start_num - The starting number for the output file names.
  # $2: output_dir - The path to the directory where output files will be saved.
  local start_num="$1"
  local output_dir="$2"

  # --- Configuration ---
  # Path to the input file. Consider making this a third parameter if it needs to be flexible.
  local input_file_path="${HOME}/Desktop/input/input.hbs"

  # --- Validate Parameters ---
  # Check if start_num is provided
  if [[ -z "$start_num" ]]; then
    echo "Error: Starting number not provided." >&2
    echo "Usage: gosplit <start_number> <output_directory_path>" >&2
    return 1
  fi

  # Check if start_num is a non-negative integer
  if ! [[ "$start_num" =~ ^[0-9]+$ ]]; then
    echo "Error: Starting number must be a non-negative integer." >&2
    echo "Usage: gosplit <start_number> <output_directory_path>" >&2
    return 1
  fi

  # Check if output_dir is provided
  if [[ -z "$output_dir" ]]; then
    echo "Error: Output directory path not provided." >&2
    echo "Usage: gosplit <start_number> <output_directory_path>" >&2
    return 1
  fi

  # --- Validate Input File ---
  if [[ ! -f "$input_file_path" ]]; then
    echo "Error: Input file not found at $input_file_path" >&2
    return 1
  fi

  # --- Prepare Output Directory ---
  # Create output directory if it doesn't exist. The -p flag creates parent directories as needed.
  mkdir -p "$output_dir"
  if [[ ! -d "$output_dir" ]]; then
    echo "Error: Could not create or find output directory $output_dir" >&2
    return 1
  fi

  # --- Process Input File ---
  local current_num="$start_num"
  local lines_processed=0

  # Read the input file line by line.
  # IFS= (Input Field Separator cleared) prevents trimming leading/trailing whitespace from lines.
  # -r prevents backslash escapes from being interpreted.
  # `|| [[ -n "$line" ]]` ensures the last line is processed if it doesn't end with a newline.
  while IFS= read -r line || [[ -n "$line" ]]; do
    local output_filename="${output_dir}/${current_num}.hbs"
    
    # Write the line to the output file.
    # Using `printf "%s" "$line"` writes the line content *without* adding a newline character.
    # This replicates the behavior of `tr -d '\n'` on each line from your original script.
    printf "%s" "$line" > "$output_filename"
    
    current_num=$((current_num + 1))
    lines_processed=$((lines_processed + 1))
  done < "$input_file_path"

  if [[ "$lines_processed" -eq 0 ]]; then
    if [[ -s "$input_file_path" ]]; then # File exists and is not empty, but no lines processed (should not happen with current loop)
        echo "Warning: Input file $input_file_path was not empty, but no lines were processed. Check file format." >&2
    else
        echo "Info: Input file $input_file_path is empty or does not exist. No files generated."
    fi
  else
    echo "Successfully generated $lines_processed files in $output_dir, starting from ${start_num}.hbs."
  fi

  return 0
}