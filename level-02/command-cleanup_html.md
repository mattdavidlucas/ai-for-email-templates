# Description
Utility prompt to clean up and reformat text from campaign briefs to be used in the HTML versions of your email.

# Responsibilities
1. Find strings of text enclosed in single curly braces and update to them to use double curly braces.
2. Find strings of text enclosed in straight brackets and update them to use double curly braces.
3. Find and replace curly apostrophes with straight apostrophes.
4. Find and replace en dashes – with the HTML entity `&ndash;`.
5. Find and replace em dashes — with the HTML entity `&mdash;`.
6. Find and replace empty lines with `<br><br>`.
7. Find and replace ® with `<sup>&reg;</sup>`.
8. Find and replace ™ with the HTML entity `&trade;`.
9. Apply the updates to the lines of code, or file, added to the chat.


# Directions & Examples
## Find strings in single curly braces
If you encouter a string enclosed in single curly braces, please update the string to be enclosed in double curly braces. Please update the file in the chat.

**Examples:**

- `{name}` would be updated to `{{name}}`

- Incorrect Pattern: `\{([^}]+)\}`

- Correct Pattern: `\{{([^}]+)\}}`

## Find strings in straight brackets
If you encouter a string enclosed in straight brackets, please update the string to be enclosed in double curly braces. Please update the file in the chat.

**Examples:**

- `[name]` would be updated to `{{{name}}}`

- Incorrect Pattern: `\[([^\]]+)\]`

- Correct Pattern: `\{{([^}]+)\}}`

## Replace curly apostrophes with straight apostrophes
If you encounter a curly apostrophe (’), replace it with a straight apostrophe. Also, if you encounter a right single quotation mark (’) or single curly quote (’), replace it with a straight apostrophe. Please update the file in the chat.

**Example with curly apostrophe:**
```
Looking to expand your wallet – but not with just any card? It’s easy when you shop with us.
```

In the above example, the curly apostrophe in `It’s` would be updated to `It's`.

## Find and replace empty lines with `<br><br>`.

**Example:**

In the below example, there's an empty line.
```
You spend the dollars, we'll sweat the details to help get you as many rewards as possible. 

We'll show you which card to use to earn the most rewards before you make a purchase.
```

The empty line needs to be replaced with double `<br><br>` tags. The above example would become:
```
You spend the dollars, we'll sweat the details to help get you as many rewards as possible. 
<br><br>
We'll show you which card to use to earn the most rewards before you make a purchase.
```