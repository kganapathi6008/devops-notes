# Merge Conflicts in Git

## What are Merge Conflicts?

A **merge conflict** occurs when Git cannot automatically resolve differences between two commits. This usually happens when multiple people modify the same line in a file or when one person edits a file while another person deletes the same file.

---

## Scenario: Person-A and Person-B

### **Step-by-Step Example:**

#### 1️⃣ Initial Setup

```bash
# Both Person-A and Person-B clone the same remote repository
$ git clone https://github.com/example/repo.git
```

Now, both have the same codebase locally.

---

#### 2️⃣ Person-A Makes Changes

```bash
# Person-A creates and switches to a new branch
$ git checkout -b feature-branch

# Person-A edits 'app.txt'
echo "Line added by Person-A" >> app.txt

# Person-A stages and commits the changes
$ git add app.txt
$ git commit -m "Add line by Person-A"

# Person-A pushes changes to remote
$ git push origin feature-branch
```

---

#### 3️⃣ Person-B Makes Conflicting Changes

While Person-A is working, Person-B also makes changes:

```bash
# Person-B creates and switches to the same feature branch
$ git checkout -b feature-branch

# Person-B edits the same 'app.txt' but on the same line
nano app.txt  # Edits the same line as Person-A

# Person-B stages and commits the changes
$ git add app.txt
$ git commit -m "Add line by Person-B"

# Person-B tries to push changes
$ git push origin feature-branch
```

Person-B will get an error:

```bash
! [rejected]        feature-branch -> feature-branch (non-fast-forward)
error: failed to push some refs
hint: Updates were rejected because the remote contains work that you do
not have locally. This is usually caused by another repository pushing
```

---

#### 4️⃣ Resolving the Merge Conflict

Person-B needs to pull the latest changes before pushing:

```bash
$ git pull origin feature-branch
```

Now, Git will detect conflicting changes in `app.txt`:

```bash
Auto-merging app.txt
CONFLICT (content): Merge conflict in app.txt
Automatic merge failed; fix conflicts and then commit the result.
```

#### 5️⃣ Fixing the Conflict

Open `app.txt`, you’ll see:

```plaintext
<<<<<<< HEAD
Line added by Person-B
=======
Line added by Person-A
>>>>>>> feature-branch
```

Manually edit the file to resolve the conflict:

```plaintext
Line added by Person-A
Line added by Person-B
```

Then:

```bash
# Mark conflict as resolved
$ git add app.txt

# Commit the merge
$ git commit -m "Resolve merge conflict between Person-A and Person-B"

# Push the resolved code
$ git push origin feature-branch
```

---

## 🔑 **Key Takeaways:**

- **Conflicts arise** when two people change the same part of a file.
- **Resolution requires** manual intervention.
- Use `git status` to see conflicted files.
- Use tools like `git mergetool` for easier conflict resolution.

---

