# Keeping EC2 SSH Connection Alive

When connecting to an EC2 instance using SSH (e.g., through Mobaxterm), you may experience the following error after some time of inactivity:

```
[ec2-user@ip-172-31-32-45 ~]$ client_loop: send disconnect: Connection reset by peer
```

This usually happens because the SSH session times out due to inactivity. Let’s configure both the client (your local machine) and the server (EC2 instance) to keep the connection alive.

## 1. Update SSH Client Config (Local Machine)

You can configure your SSH client to send periodic keep-alive messages:

1. Open or create the SSH configuration file:

   ```bash
   vi ~/.ssh/config
   ```

2. Add the following configuration:

   ```plaintext
   Host *
       ServerAliveInterval 60
       ServerAliveCountMax 3
   ```

   **Explanation:**
   - `ServerAliveInterval 60`: Sends a keep-alive packet every 60 seconds.
   - `ServerAliveCountMax 3`: If the client doesn’t receive a response after 3 attempts, the connection is closed.

3. Save and exit the file.
4. Reconnect to your EC2 instance.

## 2. Adjust SSH Server Config (EC2 Instance)

If the timeout is caused by the server (EC2 instance), update the SSH daemon’s configuration:

1. Connect to your EC2 instance.
2. Edit the SSH daemon configuration file:

   ```bash
   sudo nano /etc/ssh/sshd_config
   ```

3. Add or update these lines:

   ```plaintext
   ClientAliveInterval 60
   ClientAliveCountMax 3
   TCPKeepAlive yes
   ```

   **Explanation:**
   - `ClientAliveInterval 60`: Sends a keep-alive message every 60 seconds.
   - `ClientAliveCountMax 3`: Disconnects the client if no response is received after 3 tries.
   - `TCPKeepAlive yes`: Ensures the TCP connection is kept alive.

4. Restart the SSH service to apply the changes:

   ```bash
   sudo systemctl restart sshd
   ```

## 3. Mobaxterm Settings (Optional)

If you are using Mobaxterm, you can configure the SSH keepalive settings directly:

1. Open **Mobaxterm**.
2. Go to **Settings -> Configuration -> SSH**.
3. Enable **SSH keepalive** and set the interval to **60 seconds**.

---

By following these steps, you can prevent SSH sessions from disconnecting due to inactivity, ensuring a stable connection with your EC2 instance.

