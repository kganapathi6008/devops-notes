# Git Repository Basics

## 1. How to Create a Repository Locally

To create a new Git repository in your local system, follow these steps:

```bash
# Navigate to your project directory
cd /path/to/your/project

# Initialize a new Git repository
git init
```

- **`git init`** initializes a new, empty Git repository in the current directory. It creates a hidden `.git` folder to store all the metadata and version history.

---

## 2. The Three Logical Areas in Git

When working with Git, changes move through three logical areas:

### **a. Working Directory (Workspace)**
- This is where you create, modify, and delete files.
- Changes here are *not* tracked by Git until you explicitly add them.

### **b. Staging Area (Index)**
- A place where you prepare changes before committing them.
- Acts as a checkpoint, allowing you to review what will go into your next commit.

### **c. Local Repository (Git Database)**
- The `.git` directory holds the committed changes, storing the project’s history.
- Changes are permanently saved here once committed.

#### **How Files Move Between These Areas:**

- **Working Directory → Staging Area:**
  ```bash
  git add <filename>
  ```
  - Moves changes to the staging area.

- **Staging Area → Local Repository:**
  ```bash
  git commit -m "Commit message"
  ```
  - Commits the staged changes to the local repository.

- **Local Repository → Remote Repository:**
  ```bash
  git push origin main
  ```
  - Pushes committed changes to the remote repository.

---

## 3. Configuring Git User Information

Before making commits, configure your Git user information:

```bash
git config --global user.name "<username>"
git config --global user.email "youremail@example.com"
```

- **Explanation:**
  - `--global`: Applies the configuration to all repositories on your system.
  - `user.name`: Sets your Git username.
  - `user.email`: Sets the email associated with your commits.


After running the above commands, check if the .gitconfig file is created:


```bash
git config --global --list
```

---

## 4. Mapping Local Repository to Remote Repository

After creating a local repository, you can link it to a remote repository (e.g., on GitHub):

### **Step 1: Add the Remote Repository**
```bash
git remote add origin https://github.com/username/repo-name.git
```
- **Explanation:**
  - `remote add`: Adds a new remote connection.
  - `origin`: A common alias for the remote repository.
  - `https://github.com/username/repo-name.git`: The remote repository URL.

### **Step 2: Push Changes to Remote Repository**
```bash
git push -u origin main
```
- **Explanation:**
  - `push`: Uploads your commits to the remote repository.
  - `-u`: Sets the upstream branch so you can use `git push` directly in the future.
  - `origin main`: Pushes to the `main` branch on the `origin` remote.

Now your local repository is linked to the remote, and changes can be pushed or pulled as needed.

