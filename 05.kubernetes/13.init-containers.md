## 🧩 What Are Init Containers?

Init containers are special containers that run **before the main application containers** in a Kubernetes Pod. They are commonly used to perform setup tasks such as:

* Waiting for a dependency to become available (e.g., a database)
* Performing pre-configuration or checks
* Downloading config files or certs

Unlike regular containers:

* **They run sequentially** (one after another)
* **They must complete successfully** for the Pod to move forward
* **They do not restart** after the Pod is running

---

## ✅ Why Use Init Containers in This Example?

In this case, we want the Spring Boot `user-management` application to start **only after MongoDB is up and accepting connections**. If we skip this step, the application might start early and crash due to MongoDB not being ready.

Using an init container in the `user-management` deployment solves this cleanly.

---

## 🛠️ Updated Deployment YAML with Init Container

Here’s the updated `user-management` deployment with an init container added:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user-management
spec:
  replicas: 1
  selector:
    matchLabels:
      app: user-management
  template:
    metadata:
      labels:
        app: user-management
    spec:
      initContainers:
        - name: wait-for-mongo
          image: busybox
          command: ['sh', '-c', 'until nc -z mongo 27017; do echo waiting for mongo; sleep 2; done']
      containers:
        - name: user-management
          image: ganadevops/user-management:latest
          ports:
            - containerPort: 8080
          env:
            - name: MONGO_DB_HOSTNAME
              valueFrom:
                configMapKeyRef:
                  name: mongo-config
                  key: MONGO_DB_HOSTNAME
            - name: MONGO_DB_USERNAME
              valueFrom:
                secretKeyRef:
                  name: mongo-secret
                  key: username
            - name: MONGO_DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mongo-secret
                  key: password
```

---

## 🎯 What We Achieve

By using an init container:

* The Spring Boot app **won’t start** until MongoDB is ready.
* We avoid app crashes or connection failures on startup.
* We separate setup logic from application logic — cleaner design.


```bash
kubectl describe pod <pod-name>
```

## 🧪 Debugging Tip: View Init Container Logs

To verify what the init container is doing, use:

```bash
## kubectl logs <Pod_Name> -c <Init_Container_Name>
kubectl logs user-management-6c9d847bcf-jxkz8 -c wait-for-mongo
```

This shows messages like:

```
waiting for mongo
waiting for mongo
waiting for mongo
```

This confirms the init container is actively waiting for MongoDB to become reachable on port 27017 before allowing the main application to start.

This is a **safe, reliable, and production-grade** method for handling app dependencies in Kubernetes.
