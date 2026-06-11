# Litmus QA
litmus() {
  # Set Mailgun API credentials here:
  MAILGUN_API_USERNAME=""
  MAILGUN_API_KEY=""

  # Set Litmus email address here:
  recipient_email="creditkarma.proofs@litmusemail.com"

  echo "Please provide the path to your HTML file and press Enter:"
  read -r html_file_path

  # Check if the file exists
  if [[ ! -f "$html_file_path" ]]; then
      echo "Error: File not found at '$html_file_path'."
      return 1
  fi

  # Read the content of the HTML file
  html_content=$(<"$html_file_path")

  # Remove the subject & sender domain from bottom of HTML file
  pattern_to_remove="<h1>Subject: .*</h1><h1>Sender Domain: .*</h1>"
  cleaned_html_content=$(echo "$html_content" | sed "s#${pattern_to_remove}##g")

  echo "Please enter the subject line for the email:"
  read -r email_subject

  # Send the email using curl to Mailgun API
  # We use -s for silent mode and -o /dev/null to discard output,
  # then -w "%{http_code}" to capture just the HTTP status code.
  #-F "to=${recipient_email}" \
  http_status=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
    -u "${MAILGUN_API_USERNAME}:${MAILGUN_API_KEY}" \
    "https://api.mailgun.net/v3/test.litmus-qa.com/messages" \
    -F "from=Marketing QA <postmaster@test.litmus-qa.com>" \
    -F "to=${recipient_email}" \
    -F "subject=${email_subject}" \
    --form-string "html=${cleaned_html_content}" \
    -F "o:testmode=no" \
    -F "o:tracking=no" \
    -F "o:tracking-clicks=no" \
    -F "o:tracking-opens=no" \
    -F "o:require-tls=no" \
    -F "o:skip-verification=yes")

  if [[ "$http_status" -eq 200 ]]; then
      echo "🚀 Your Litmus test has been created! Please tag your design partners in #email_proofs."
  else
      echo "Failed to create your Litmus test. Mailgun's API returned HTTP status code: $http_status."
      echo "Please check your Mailgun API key, domain, and network connection."
  fi
}