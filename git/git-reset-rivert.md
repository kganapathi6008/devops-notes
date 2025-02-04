# Git Reset and Git Revert

## 1. Git Reset

`git reset` is used to undo changes by moving the HEAD pointer to a specific commit. It can modify the commit history and affect your working directory and staging area depending on the mode used.

### **Modes of Git Reset:**

1. **Soft Reset (`--soft`):**
   - Moves HEAD to the specified commit.
   - Changes remain in the staging area.

   ```bash
   git reset --soft <commit-hash>
   ```
   **Use Case:** Undo the last commit but keep changes staged.

2. **Mixed Reset (`--mixed`)** (default):
   - Moves HEAD to the specified commit.
   - Unstages changes, but they remain in the working directory.

   ```bash
   git reset --mixed <commit-hash>
   # or simply
   git reset <commit-hash>
   ```
   **Use Case:** Unstage files while keeping changes in the working directory.

3. **Hard Reset (`--hard`):**
   - Moves HEAD to the specified commit.
   - Discards all changes in the staging area and working directory.

   ```bash
   git reset --hard <commit-hash>
   ```
   **Use Case:** Completely discard changes and reset the repository to a previous state.

---

## 2. Git Revert

`git revert` is used to create a new commit that undoes the changes introduced by a previous commit. It doesn’t modify the commit history, making it safe for public repositories.

### **How to Use Git Revert:**

```bash
git revert <commit-hash>
```

- This command opens an editor to modify the default commit message.
- Save and close the editor to complete the revert.

### **Reverting Multiple Commits:**

```bash
git revert <oldest-commit-hash>^..<newest-commit-hash>
```

**Use Case:** Ideal for undoing changes in a shared repository without altering commit history.

---

## Key Differences Between Git Reset and Git Revert

| Feature           | Git Reset                      | Git Revert                         |
|-------------------|--------------------------------|------------------------------------|
| Modifies History  | Yes (for local commits)        | No                                 |
| Safe for Shared Repos | No (can rewrite history)      | Yes                                |
| Discards Changes  | Yes (with `--hard`)            | No, creates a new commit            |
| Use Case          | Rewriting local commit history | Undoing changes in shared history   |

---

## **Summary:**
- Use `git reset` for local changes when you want to modify history or clean your working directory.
- Use `git revert` for undoing commits in shared repositories safely.