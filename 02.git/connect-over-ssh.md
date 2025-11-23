# Connecting to GitHub Using SSH with RSA Key

## 1. Why Use SSH to Connect to GitHub?
SSH (Secure Shell) provides a secure and encrypted way to communicate with GitHub. Using SSH keys eliminates the need to enter your GitHub username and password each time you interact with the remote repository.

---

## 2. Generating an RSA SSH Key

### **Step 1: Generate RSA Key Pair**
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
- `-t rsa`: Specifies the key type (RSA).
- `-b 4096`: Generates a 4096-bit key for strong security.
- `-C`: Adds a label to the key (your email).

### **Step 2: Save the Key**
You'll be prompted:
```
Enter file in which to save the key (/home/user/.ssh/id_rsa):
```
Press **Enter** to accept the default location or specify a path.

### **Step 3: Set a Passphrase (Optional)**
For added security, you can set a passphrase.

---

## 3. Adding the SSH Key to the SSH Agent

### **Start the SSH Agent:**
```bash
eval "$(ssh-agent -s)"
```

### **Add the Private Key:**
```bash
ssh-add ~/.ssh/id_rsa
```

---

## 4. Adding the Public Key to GitHub

### **Step 1: Copy the Public Key**
```bash
cat ~/.ssh/id_rsa.pub
```
Copy the entire output (starting with `ssh-rsa`).

### **Step 2: Add to GitHub**
1. Go to **GitHub → Settings → SSH and GPG keys**.
2. Click **New SSH key**.
3. Enter a title (e.g., *My Laptop Key*).
4. Paste the copied key into the **Key** field.
5. Click **Add SSH key**.

---

## 5. Testing the Connection

```bash
ssh -T git@github.com
```
**Expected Output:**
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

---

## 6. Cloning Repositories Using SSH

```bash
git clone git@github.com:username/repository.git
```

---

## 7. Managing SSH Keys

### **List Existing Keys:**
```bash
ls -al ~/.ssh
```

### **Remove a Key from SSH Agent:**
```bash
ssh-add -d ~/.ssh/id_rsa
```

### **Delete an SSH Key File:**
```bash
rm ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
```

---

## 8. Common Issues & Fixes

- **Permission Denied (Publickey):**
  - Check if the SSH key is added to the agent: `ssh-add -l`
  - Ensure the correct key is associated with GitHub.

- **Key Permissions:**
  ```bash
  chmod 600 ~/.ssh/id_rsa
  chmod 644 ~/.ssh/id_rsa.pub
  ```

---
