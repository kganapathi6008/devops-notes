# CrashLoopBackOff in Kubernetes - Troubleshooting Guide

## What is CrashLoopBackOff?

`CrashLoopBackOff` is a Kubernetes pod status indicating that a container inside the pod is repeatedly crashing and Kubernetes is backing off from restarting it immediately. It uses exponential backoff to delay retries.

---

## Common Reasons for CrashLoopBackOff

### 1. **Application Errors**

* Application crashes due to code bugs or runtime exceptions.
* Unhandled exceptions in the startup logic.

### 2. **Incorrect Command or Arguments**

* The container's entrypoint or command is misconfigured.

### 3. **Missing ConfigMap or Secret**

* Required environment variables or files are missing.

### 4. **Resource Limits**

* Container is getting killed due to exceeding memory or CPU limits (OOMKilled).

### 5. **Failed Liveness Probe**

* If a liveness probe fails, Kubernetes kills and restarts the container.

### 6. **Volume Mount Issues**

* PVC not bound, volume plugin errors, or missing permissions.

### 7. **Dependency Failures**

* The app depends on a service (e.g., DB) that is unavailable at startup.

---

## How to Troubleshoot CrashLoopBackOff

### 1. **Check Pod Logs**

```bash
kubectl logs <pod-name> -n <namespace>
```

* Use `kubectl logs <pod-name> -c <container-name>` if multiple containers.

### 2. **Describe the Pod**

```bash
kubectl describe pod <pod-name> -n <namespace>
```

* Look for `Last State`, `Events`, and probe failures.

### 3. **Check Events**

```bash
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
```

### 4. **Verify YAML Definitions**

* Check container `command`, `args`, `env`, `resources`, and `volumeMounts`.

### 5. **Check Probes**

* Inspect `livenessProbe` and `readinessProbe` definitions.
* Ensure the application is ready to serve requests.

### 6. **Validate Dependencies**

* Confirm that dependent services like databases, APIs, or queues are accessible.

---

## Best Practices to Avoid CrashLoopBackOff

* Implement proper exception handling and logging.
* Validate configuration before deployment.
* Use `initContainers` for setup or dependency checks.
* Gracefully handle application start and stop.
* Ensure readiness/liveness probes reflect true app health.
* Use resource requests and limits appropriately.

---

## Example: Crash due to missing environment variable

### Issue:

```yaml
        env:
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: db-config
              key: host
```

If `db-config` ConfigMap or the key `host` is missing, the container may crash on start.

### Fix:

Ensure the ConfigMap exists and has the required key:

```bash
kubectl get configmap db-config -n <namespace> -o yaml
```

---

## Final Tip

Use `kubectl get pod <pod-name> -o jsonpath='{.status.containerStatuses[*].lastState}'` to inspect previous crash reasons programmatically.

---

*Keep this guide handy when diagnosing pod issues!*
