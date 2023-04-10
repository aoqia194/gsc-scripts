# Prevent database writes to only occur when the game ends.
- To keep data until the game ends, use the level.server_data struct to store a minified version of the database.
- Update the database only when the game ends and pray that other servers don't try to access it while updating (until I can think of a fix like pooling writes).
