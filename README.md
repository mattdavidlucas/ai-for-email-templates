# AI for Email Templates

I originally wrote about this on my [website](https://www.mattdavidlucas.com/work/use-case-ai-for-email-templates), but wanted to write an in-depth document outlining my thinking and approach to applying AI to email template production.

## Background

This was work I did at Credit Karma. I was a member of their Growth Technology Operations team, and my focus was managing and maintaining their email template code base, which was built with Handlebars.js, lived in a GitHub repo outside of our marketing platform, and could only be previewed by running a `npm` build command in Terminal. 

In addition to this, I also produced email messages for use in marketing campaigns and coded new email components, based on Figma mockups.

New email components were built primarily with HTML and CSS, with some Handlebars scripting. But the marketing emails were just a mix of Handlebars.js and `.json` files. When I first started on the team, the process generally looked like this:

1. Received a Google Doc containing campaign copy and a Figma mockup of the email.
2. Created a new `git` branch for the new email.
3. Manually formatted all of the Google Doc copy and moved it to individual Handlebars.js and `.json` files.
4. Ran our build command in Terminal; waited for the HTML files to be outputted.
5. Previewed in Chrome to check links, design fidelity, mobile viewport rendering; fixed any errors I caught; re-ran build command.
6. Took final HTML, went to Litmus, created a new test by pasting in HTML, and saving it, which automatically created a new test in our email review Slack channel.
7. Basically done...but definitely a lot of manual work just to get to that Litmus review.

Early in my career, I was mentored by an engineer who taught me about the vital importance of shell scripting and having an awe-inspiring `.bash_profile`. Bash profiles to him were crowning achievements, files to brag about; his idea of fun was converting Windows laptops to Linux machines.

With this background, I immediately started creating shell scripts to help with this manual flow. They were fairly basic, but definitely saved time in my production workflow.

After a few months, AI was officially made available to all employees. I was skeptical at first, but once we got access to Gemini Enterprise, I started experimenting with it, and found that it was quite good at doing basic coding tasks.

Below is a walkthrough of how I applied AI to marketing emails needed for a fast-moving growth marketing team. I broke down iterative stages into levels, sort of like video games.

### Level 1: Google Gemini Enterprise

---

To kick the tires, I started out basic: I only used Gemini for creating VS Code snippets (this was pre-Cursor days). Creating snippets used to be time consuming, and I had created a snippet to create a snippet, but with Gemini, I created a Gem, and all I had to do was paste in my block of code, and it would automatically format it and return my snippet. Amazing.

I ended up creating snippets for every piece of email template code from our repo, about 200 snippets in total, and I did this (I think) in an afternoon. The snippets, along with my basic shell scripts, really streamlined everything and gave me a great sense of flow.

But I wanted to see if I could do more, so I started working with Gemini, using their Coding Partner Gem, on my existing shell scripts. I gave it what I had and then outlined my ideal workflow, and let it do its thing. What it generated was pretty good (probably 80% close) so I went through several rounds of iteration and many rounds of testing my creation workflow.

The final result was such a game changer (at this pre-Cursor, pre-Claude Code level). My flow was mostly running my shell scripts to format copy and leveraging my snippets for anything else that required custom layouts. Here's a breakdown of what I created:

[**`gostarter.sh`**](level-01/gostarter.sh): A command for generating a net new marketing email, with optional push message. It clones a standard boilerplate template and finds and replaces any placeholder campaign metadata with user specified campaign metadata.

[**`goclone.sh`**](level-01/goclone.sh): A command for cloning an existing marketing email or push message. The command will also find and replace any of the old campaign metadata with the new, user specified campaign metadata.

[**`gosplit.sh`**](level-01/gosplit.sh): A command for splitting blocks of copy into individual, numbered `.hbs` files, which would be used for creative experiments.

[**`goreplace.sh`**](level-01/goreplace.sh): A command for finding and replacing text in a campaign directory. Fairly trivial, given that an IDE can do the same, but surprisingly handy at times.

[**`litmus-qa.sh`**](level-01/litmus-qa.sh): This command I truly loved. It's a simple command that uses the Mailgun `messages` endpoint to send outputted HTML files to Litmus, which simultaneously creates a Litmus test and posts the test to Slack, thanks to the Litmus/Slack integration. Finally, I didn't have to leave my IDE to create a Litmus test.

This was my new workflow: shell scripts; snippets; a Bash profile I could be proud of.

Then a couple of engineering colleagues told me to check out Cursor.

### Level 2: Cursor

---

Cursor quickly changed how I worked and how I approached my work. At the time of my usage, it was before agent skills had been fully adopted, so the key features I leveraged were:

- **Tab:** A feature that, after using it for a few weeks, can anticipate what you'll code next, which virtually eliminated the need for my snippets.
- **Rules:** A ruleset that applies to the specific work I was doing.
- **Commands:** A precursor to agent skills that worked as slash commands to complete specific tasks.
- **Plan Mode:** A feature I used heavily when needing to do large bulk audits across email templates, and also for coding new email template components.
- **MCP:** When Figma released their MCP for Cursor, I immediately connected it, and started using it. When I paired it with Cursor's Plan Mode, the time savings were significant. Examples of the generated code can be viewed [here](https://github.com/mattdavidlucas/email-samples/tree/master/ck-email-module-samples).

#### Rules:

[**`rule-marketing_template_best_practices.md`**](level-02/rule-marketing_template_best_practices.md): This was the rule I created for marketing emails; just a high level do's and don'ts.

#### Commands:

[**`command-cleanup_html.md`**](level-02/command-cleanup_html.md), [**`command-cleanup_text.md`**](level-02/command-cleanup_text.md), [**`command-json_array.md`**](level-02/command-json_array.md): These were utility commands I created to assist with formatting. Over time, my usage of Tab rendered these useless, but occasionally they were handy for one-off jobs.

[**`command-parity_test.md`**](level-02/command-parity_test.md): A simple command for running our build command. The benefit here was that an interactive Terminal was run in Cursor's chat, and if there were errors while the build ran, you could then work with the agent to identify the issues.

[**`command-qa.md`**](level-02/command-qa.md): A simple, yet effective command for QA'ing marketing emails.

[**`command-template_builder.md`**](level-02/command-template_builder.md): 

This command was the star of the show and yielded the best results: after much iteration and multiple failed attempts, this was the workflow that could ingest a Google Doc, design specs, campaign metadata, and output fully coded marketing emails (in our required Handlebars.js and `.json` formats) with 90 to 95% accuracy. All of a sudden I was using this to generate marketing emails and push messages **in less than 20 minutes**; and if an email was very simple in layout and experiments, it could be as quick as **8 minutes or less**. 

**One important note about this work:** The template builder command was truly a collaborative effort. Initial experimenting was done by a colleague of mine that built a version as a Gemini Gem, and also vibe coded as a React.js app with a front end UI to do the work; it was ambitious, but didn't deliver consistent, usable results. Another version by a data engineer was produced for Cursor, but since he wasn't close to the workflow or the unique experience of an email developer, it also didn't produce consistent, reliable results. 

When I took a stab at it, I brought all of my experiences, knowledge, and pain points to make a command that truly worked and produced reliable, consistent results.

### Level 3: Claude Code & Agent Skills

---

After using Cursor (and falling in love with it) for quite a few months, I gained access to Claude Code. During this time, we also saw the rise of agent skills, so I started investigating both.

When looking into the specs for agent skills, it was clear that they were much more powerful than Cursor commands.

It was also clear how powerful Claude Code was. Not only could I use it to draft, iterate, and convert my Cursor commands into skills, I could also use it for engineering purposes. For example, I used it to quickly create an [Airtable MCP](level-03/ck-airtable-mcp/) (we used Airtable for tracking email template requests) that I could use to retrieve template request details while in an agent chat. Pairing this with my newly converted agent skills, a Google Drive MCP, Figma's MCP, and all of a sudden...my workflow was becoming agentic.

In the end, there was a lot of work left incomplete due to me leaving Credit Karma, but before leaving, a non-technical marketer using early versions of the skills noted on Slack:

> "Just want to give a shoutout and thank you...for developing these skills! It built 4 net new emails using `template-builder` in 10 minutes which would normally take at least a couple of hours of manual work. This will help so much with velocity."

That was definitely a feather in my cap.

Here's a breakdown of the skills I created using Claude Code:

[**`template-builder`**](level-03/template-builder): This was the agent skill version of my Cursor `template_builder` command, but with much more context. Leveraging `references` and `scripts` directories, I gave the agent as much knowledge and understanding of our build process and standards to generate highly accurate marketing emails and push messages.

[**`template-qa`**](level-03/template-qa): This was the agent skill version of my Cursor `qa` command, but again, with much, much more contextual background on what it meant to truly QA a marketing email or push, along with our high standards for a great customer experience.

[**`run-parity`**](level-03/run-parity): A simple skill to run our build command.

[**`email-design-to-template`**](level-03/email-design-to-template): This was supposed to be my crowning achievement (famous last words), but was never completed. It was an ambitious skill where I intended to translate our Figma Email Design System into Markdown files and image assets, and then pair that with repository documentation, pointing to components and how they mapped to Figma components. A user could then drop a PNG of an exported Figma design into an agent chat and ask it create a marketing email. Initial testing was extremely promising.

---

## Conclusion

Before leaving Credit Karma, my AI for email templates work caught the attention of the engineering team. This was hugely satisfying because I had consistently struggled to get engineering support to improve email development tooling. AI empowered me to do the work on my own, and then share it with other teams to empower them.