# Git Advanced Topics

## 1. Viewing Local and Remote Repositories

### **View Local Branches:**
```bash
git branch
```

### **View Remote Branches:**
```bash
git branch -r
```

### **View Both Local and Remote Branches:**
```bash
git branch -a
```

### **View Remote Repositories:**
```bash
git remote -v
```

---

## 2. Deleting Local and Remote Branches

### **Delete a Local Branch:**
```bash
git branch -d branch_name   # Safe delete (prevents deleting unmerged branches)
git branch -D branch_name   # Force delete
```

### **Delete a Remote Branch:**
```bash
git push origin --delete branch_name
```

---

## 3. Difference Between a Branch and a Tag

| **Aspect**     | **Branch**                        | **Tag**                         |
|----------------|---------------------------------|---------------------------------|
| Purpose        | For ongoing development         | Marks specific points (releases) |
| Mutable        | Yes, commits can change         | No, it points to a fixed commit  |
| Usage          | Switching, merging, feature dev | Version releases, milestones    |

### **When to Use:**
- **Branches:** For new features, bug fixes, or experiments.
- **Tags:** For versioning stable releases.

---

## 4. What is a Personal Access Token (PAT)?

A **Personal Access Token (PAT)** is a secure alternative to passwords for authenticating with GitHub, especially when using HTTPS.

### **Why Use PAT?**
- Secure authentication
- Required for operations like cloning, pushing, and pulling with HTTPS

### **How to Create a PAT:**
1. Go to **GitHub Settings → Developer Settings → Personal Access Tokens**.
2. Click **Generate new token**.
3. Select scopes/permissions.
4. Generate and copy the token.

### **Using PAT with Git:**
```bash
git clone https://<username>@github.com/<repo>.git
# When prompted for a password, enter the PAT instead
```

---

## 5. Git Stash

`git stash` temporarily saves changes that you’re not ready to commit.

### **Basic Stash:**
```bash
git stash        # Stash current changes
git stash list   # View list of stashes
```

### **Apply Stash:**
```bash
git stash apply               # Apply the latest stash
git stash apply stash@{1}     # Apply a specific stash
```

### **Pop Stash (Apply & Delete):**
```bash
git stash pop                 # Apply and remove the latest stash
git stash pop stash@{1}       # Apply and remove a specific stash
```

### **Drop Stash (Delete without Applying):**
```bash
git stash drop stash@{0}      # Delete a specific stash
```

### **Clear All Stashes:**
```bash
git stash clear               # Remove all stashes
```

