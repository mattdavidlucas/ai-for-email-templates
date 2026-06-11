# Marketing Parity Test

Run parity tests on email and push templates to verify they render correctly and maintain consistency with expected outputs.

## Description

This command runs parity tests for a specified template directory using the MAES template manager's parity testing framework. Parity tests ensure that email and push templates render correctly with the provided payload data and match expected outputs.

## Usage

When invoked, you will prompt the user for:

1. **Template Directory Path**: The path to the template directory to test (e.g., `_examples/campaign_starter/email`, `test/sandbox/your-name/campaign-name/email`, `revenue/cc_prime/email`)

## Command Execution

Once the template path is provided, execute the following command:

```bash
PARITY_FILTER="<template_path>" npm run parity
```

### Example:

```bash
PARITY_FILTER="_examples/campaign_starter/email" npm run parity
```

## What This Command Does

The parity test command will:

1. **Pull latest changes** from the git repository
2. **Install dependencies** via npm install
3. **Build the project**:
   - Clean previous builds
   - Generate code from thrift IDL
   - Run ESLint
   - Compile TypeScript
4. **Run parity tests** on the specified template directory
5. **Copy rendered templates** to `templates/renders/`

## Test Results

After completion, the command will display:

- ✅ Test status (pass/fail)
- 📊 Number of tests completed
- ⏱️ Test duration
- 📈 Code coverage percentage
- 📁 Location of rendered output files

## Notes

- The parity test typically takes 2-3 minutes to complete
- The command runs from the parent directory (maes_template-manager root)
- Rendered templates will be available in `templates/renders/` for review
- An exit code of 0 indicates successful completion
