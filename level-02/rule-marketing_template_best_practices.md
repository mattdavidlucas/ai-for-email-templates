---
description: A general guide of best practices used for creating marketing email and push templates.
alwaysApply: true
---
# Purpose
You are a marketing operations manager tasked with providing guidance and best practice guidelines for marketers and email developers creating marketing email and push templates.

## Design System Layout
For every new email created, it should only use `common/bulk/layouts/design_system.hbs` as the primary layout and include the following `{{#> common/bulk/layouts/design_system `.

## Modules
When you need to understand our email template modules and what configurable parameters are available to those modules, please refer to the partials in this directory: `common/bulk/layouts/partials/design_system`

## Module Implementation Examples
When looking for code examples of how modules are implemented in email templates, please refer to the examples in this directory: `_examples/design_system`

## Campaign Directories
When looking for examples of email and push campaigns, please start with the following directories:
- `growth_and_discovery`
- `revenue`
- `checking`

If any examples DO NOT contain `{{#> common/bulk/layouts/design_system `, please ignore them, as they represent deprecated layouts.

## Darwin Experiments
Our experimentation platform is called Darwin and is used for creative variant testing. In email and push templates, Darwin experiments are represented with the following custom Handlebars helpers:
- `ck:varyBig`
- `ck:variant`

This is followed by a path to either a directory of `.hbs` files or an individual `.json` file.

Paths that reference directories of single or multiple `.hbs` files must use `ck:varyBig`.

Paths that reference individual `.json` files must use `ck:variant`.

**Examples:**

- This Darwin experiment, `{{{ck:varyBig '_examples/campaign_starter/email/subjects' experiments 'starter_subjects'}}}`, uses `ck:varyBig` and references a directory containing a `.hbs` file: `_examples/campaign_starter/email/subjects`

- This Darwin experiment, `{{{ck:variant '_examples/campaign_starter/email/headlines' experiments 'starter_headlines'}}}`, uses `ck:variant` and references `_examples/campaign_starter/email/headlines.json`.

## Personalization
We call expressions in Handlebars "macros" or "personalization macros". Some examples are:
- {{fname}}
- {{dateReported}}
- {{creditBureau}}

Macros must either use double curly braces `{{}}`, or triple curly braces `{{{}}}`.

## Color Palette
Below is a list of acceptable hex values that can be used in parameters containing `color` or `Color`:
- #000000
- #02380d
- #008600
- #6ade19
- #f4f4ef
- #ffffff
- #89fe45
- #f9c740
- #ff77c7
- #3592ef
- #132f00
- #009cc1
- #ff5e00
- #7039a3
- #4b2e00
- #ffc300
- #0077db
- #b68c50
- #52c800
- #e9eef0
- #373737
- #f6f2db
- #005b13
- #008600
- #002356
- #02380d
- #6ade19
- #f4f4ef
- #89fe45
- #f9c740
- #ff77c7
- #3592ef

## Best Practices for Coding
- For every individual file created, whether it's a `.json` or `.hbs` file, please remove trailing empty lines at the end of each file. We do not want any trailing empty lines at the end of any files created, as that will cause errors in our build process.
- All personalization macros need to end with double curly braces `}}` or triple curly braces `}}}`
- Examples of incorrectly formatted personalization macros:
  - Incorrect pattern: \{\{.*?\}
  - Incorrect pattern: \{.*?\}\}
  - Incorrect pattern: \{.*?\}
- All personalization macros need to start with double curly braces `{{` or triple curly braces `{{{`
- Example of correctly formatted personalization macro: `{{name}}` or `{{{name}}}`
- Ensure all HTML tags are properly closed
- Ensure there are no extra spaces in Handlebars parameter values
- Ensure all Handelbars parameter names that contain `color` or `Color` start with a parameter value of `#`
- Ensure all Handelbars parameter names that contain `url` or `Url` start with a parameter value of `https`