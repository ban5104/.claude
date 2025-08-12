Create or update a journal entry for today or a specific date.

If $ARGUMENTS is provided:
- If it starts with a date (YYYY-MM-DD), create/update entry for that date with the remaining text
- If it's just text, add it to today's journal entry
- If no arguments, create/open today's journal entry file

Journal entries are stored in ~/journal/ as markdown files named by date (YYYY-MM-DD.md).

Each entry should have:
- A header with the date
- Timestamped sections for different entries throughout the day
- Clean markdown formatting

Please use the journal.js script at ~/code/claude-scripts/journal.js to handle this, or implement the functionality directly by:
1. Creating/opening the appropriate date file in ~/journal/
2. Adding timestamped content if provided
3. Maintaining proper markdown structure

Arguments: $ARGUMENTS