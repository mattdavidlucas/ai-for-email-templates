# Description
Utility prompt to clean up and reformat HTML to be used in the text versions of your messages.

# Responsibilities
1. Find strings of text enclosed in double curly braces and update to them to use triple curly braces.
2. Find strings of text enclosed in straight brackets and update them to use triple curly braces.
3. Find and replace curly apostrophes with straight apostrophes.
4. Find and replace the HTML entity `&ndash;` with ` - `
5. Find and replace the HTML entity `&mdash;` with ` - `
6. Find and replace `<br><br>` with a new empty line.
7. Find and replace `<sup>&reg;</sup>` with ®
8. Find and replace the HTML entity `&trade;` with ™
8. Find and replace any string in opening and closing `<sup>` tags with opening `(` and closing `)` parenthesis.
10. Apply the updates to the lines of code, or file, added to the chat.


# Directions & Examples
## Find strings in double curly braces
If you encouter a string enclosed in double curly braces, please update the string to be enclosed in triple curly braces. Please update the file in the chat.

Examples:
`{{name}}` would be updated to `{{{name}}}`
Incorrect Pattern: `\{{([^}]+)\}}`
Correct Pattern: `\{{{([^}]+)\}}}`

## Find strings in straight brackets
If you encouter a string enclosed in straight brackets, please update the string to be enclosed in triple curly braces. Please update the file in the chat.
Examples:
`[name]` would be updated to `{{{name}}}`
Incorrect Pattern: `\[([^\]]+)\]`
Correct Pattern: `\{{{([^}]+)\}}}`

## Replace curly apostrophes with straight apostrophes
If you encounter a curly apostrophe (’), replace it with a straight apostrophe. Also, if you encounter a right single quotation mark (’) or single curly quote (’), replace it with a straight apostrophe. Please update the file in the chat.

Example with curly apostrophe:
```
Looking to expand your wallet – but not with just any card? It’s easy when you shop with us.
```

In the above example, the curly apostrophe in `It’s` would be updated to `It's`.

## Find and replace any string in opening and closing `<sup>` tags with opening `(` and closing `)` parenthesis.

For this check, please update the file in the chat.

Examples:
`<sup>1</sup>` would be updated to `(1)`
Search for `<[sS][uU][pP]>(.+?)<\/[sS][uU][pP]>` and replace with `(\1)`