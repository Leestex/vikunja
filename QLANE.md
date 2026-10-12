# QLANE.md

What the QA team wants tested in this app, written for the testing tool.

## Critical scenarios

Two accounts are available: one admin and one regular user. Several scenarios are permission boundaries and need both.

P0, must always work:
1. Register, log in, log out
2. Create a project, create a task in it, mark it done
3. Due date and reminder on a task, confirm it appears in Upcoming
4. Kanban: move a task between buckets, confirm the done bucket marks it done
5. Share a project with the second user at read-only, confirm that user cannot edit
6. Create a label, filter by it, save the filter and reopen it

P1: subtasks and related tasks; assigning a task to the second user; attachments and comments; public link share and what it exposes; API token creation and use.
