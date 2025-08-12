Manage todo items organized by topic in markdown files.

If $ARGUMENTS contains:
- "add [topic] [task]" - Add a new task to the specified topic file
- "complete [topic] [task]" - Mark a task as completed in the topic file  
- "list [topic]" - Show all tasks for a specific topic
- "list" - Show all todo files and their contents
- Just a topic name - Show tasks for that topic

Todo files are stored in ~/todos/ as markdown files named by topic (e.g., "work.todos.md", "personal.todos.md").

Each todo file should have:
- Clear topic header
- Tasks organized with checkboxes [ ] for incomplete, [x] for complete
- Optional sub-tasks indented under parent tasks
- Clean markdown formatting

Please manage the todo files in ~/todos/ by:
1. Creating topic-specific markdown files as needed
2. Using standard checkbox syntax for task tracking
3. Maintaining organized, readable structure
4. Supporting nested sub-tasks where appropriate

Arguments: $ARGUMENTS