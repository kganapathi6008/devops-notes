# Git Notes

## 1. What is Traditional Source Code Management (SCM)?
Traditional SCM systems manage code in a centralized manner where a single server holds the main codebase. Examples include CVS and Subversion (SVN).

### **Limitations:**
- Single point of failure
- Requires constant server connection
- Limited collaboration efficiency

---

## 2. What is Distributed Architecture?
In Distributed Version Control Systems (DVCS), every developer has a complete copy of the repository, including its history.

### **Key Advantages:**
- No dependency on a central server
- Faster operations (commit, diff, etc.)
- Offline access to the full project history

---

## 3. What is Git & How is it Different from Other Tools?
**Git** is a distributed version control system designed for speed, efficiency, and collaboration.

### **Differences from Traditional SCMs:**
- Fully distributed architecture
- Faster branching and merging
- Lightweight compared to SVN or CVS

---

## 4. GitHub Account Creation
1. Visit [https://github.com](https://github.com)
2. Click on **Sign Up**
3. Fill in your email, password, and username
4. Verify your email and set up 2FA (optional but recommended)

---

## 5. Creating Public and Private Repositories on GitHub
### **Steps:**
1. After logging in, click the **+** icon → **New Repository**
2. Enter the repository name
3. Choose **Public** (visible to everyone) or **Private** (only you & collaborators)
4. Click **Create Repository**

---

## 6. Cloning a GitHub Repository
```bash
# Clone a public repository
git clone https://github.com/username/repo-name.git

# Clone using SSH (for private repos)
git clone git@github.com:username/repo-name.git
```

---

## 7. Adding Files and Content to the Staging Area
```bash
touch file.txt                    # Create a new file
echo "Hello, Git!" > file.txt      # Add content
git add file.txt                  # Stage the file
```

### **Check Staged Files:**
```bash
git status
```

---

## 8. Committing Changes to the Local Repository
```bash
git commit -m "Add greeting message"
```

### **Best Practices:**
- Use clear and concise commit messages
- Follow conventions like using present tense: "Fix bug", "Add feature"

---

## 9. Pushing Changes to Remote Repository
```bash
git push origin main  # Push changes to the 'main' branch
```

---

## 10. Introduction to Git Branches
A **branch** is an independent line of development, allowing multiple features to be developed simultaneously.

### **Common Branches:**
- `main` (or `master`): Production-ready code
- `dev`: Development branch
- `feature/*`: New features

---

## 11. Branching Strategy
- **Git Flow:** `main` → `develop` → `feature`/`release`/`hotfix`
- **GitHub Flow:** Lightweight, feature branches, pull requests

### **Benefits:**
- Parallel development
- Easier code reviews
- Rollback support

---

## 12. Creating Branches
```bash
# Create a new branch
git branch feature-xyz

# Switch to the new branch
git checkout feature-xyz

# Create and switch simultaneously
git checkout -b feature-abc
```

### **List All Branches:**
```bash
git branch
```

---

## 13. Merging Branches
```bash
# Merge feature branch into main
git checkout main
git merge feature-xyz
```

### **Fast-forward vs. Three-way Merge:**
- **Fast-forward:** Directly moves the pointer if there are no diverging changes
- **Three-way Merge:** Creates a merge commit when histories have diverged

---

## 14. Resolving Merge Conflicts
When Git can't automatically merge changes:
```bash
# Identify conflicts
git status

# Manually edit conflicting files

# Mark as resolved
git add <file-name>

git commit -m "Resolve merge conflict in <file-name>"
```

### **Tips:**
- Use tools like `git mergetool`
- Always pull the latest changes before merging

---

## 15. Git Workflows (Overview)
- **Feature Branch Workflow**: Isolated development
- **Git Flow Workflow**: Structured with `main`, `develop`, `release`, `hotfix`
- **Forking Workflow**: Great for open-source projects

---

## 16. Additional Git Commands
```bash
# View commit history
git log

# Revert changes
git revert <commit-hash>

# Delete a branch
git branch -d feature-xyz

# Stash changes temporarily
git stash
```

---

## 💡 ** Tips:**
- Commit often with meaningful messages
- Regularly pull changes when working in teams
- Use `.gitignore` to exclude unnecessary files

---

## 🔗 **References:**
- [Git Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)


---


