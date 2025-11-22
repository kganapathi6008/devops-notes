## Kubernetes Pod Autoscaling Overview

In Kubernetes, Pod Autoscaling is a mechanism that automatically adjusts the number of running pod replicas or the resource limits of pods based on their CPU, memory usage, or other custom metrics. This allows applications to scale efficiently based on demand.

---

### Types of Pod Autoscaling

1. **Horizontal Pod Autoscaler (HPA)**

   * Automatically scales the number of pod replicas in a deployment, replication controller, or stateful set based on observed CPU utilization or custom metrics.
2. **Vertical Pod Autoscaler (VPA)**

   * Automatically adjusts the CPU and memory resource requests and/or limits for containers in pods.
   * It can either suggest, automatically update, or require manual approval depending on the update mode.

---

### Scenario-Based Explanation

Suppose we have a node group of 3 nodes, each of type `t3.medium` (2 vCPUs, 4 GiB memory).

Assume the pod resource settings:

* CPU: 0.5 vCPU
* Memory: 1 GiB

This means:

* Each node can theoretically host up to 4 such pods (2 vCPUs / 0.5 vCPU = 4, 4 GiB / 1 GiB = 4).
* So across the cluster (3 nodes), a maximum of 12 pods can be scheduled.

#### What Happens with VPA?

* VPA can **increase or decrease** the CPU and memory settings of an **existing pod**.
* However, **VPA cannot update a running pod**. Instead, it recommends new resource settings, and during the next pod restart (or with its `Auto` update mode), a **new pod is created** with the updated values.

---

### Importance of Setting Resource Requests and Limits

If resource limits and requests are **not** set:

* Kubernetes will not have a reference to schedule or throttle pod resource usage.
* A misbehaving pod can consume all CPU/memory on a node, impacting other pods (resource starvation).

If limits are set:

* The pod is throttled when it exceeds CPU limits.
* The pod is **OOMKilled** (terminated) if memory exceeds the limit.

You can set these as:

```yaml
resources:
  requests:
    cpu: "0.5"
    memory: "1Gi"
  limits:
    cpu: "0.5"
    memory: "1Gi"
```

These are **container-level** configurations.

> Note: Requests define the minimum guaranteed resources. Limits define the maximum usable resources.

#### Can Limits < Requests?

No. Kubernetes will throw an error during deployment. Limits must be >= requests.

---

### Pod Behavior on Resource Exhaustion

* **Running out of CPU:** Pod is throttled. It will be scheduled but runs slower.
* **Running out of Memory:** Pod is killed (OOMKilled). Node stability can be impacted if no limits are set.

---

### Scaling Considerations

Initially, a Deployment may define a fixed number of replicas. If the load increases:

* **HPA** will increase the pod count based on CPU/Memory usage or custom metrics.
* **VPA** will suggest/request more resources per pod instead of increasing count.

#### When to Use HPA vs VPA

* Use **HPA** for stateless applications where more replicas handle more traffic (web servers, APIs).
* Use **VPA** for resource-tuned workloads where single pods need better sizing (batch jobs, machine learning models).
* **Do not use HPA and VPA for CPU simultaneously** unless VPA is in `recommendation` mode only.

---

### Cluster Resource Availability

* **If the cluster lacks resources** (CPU/memory), autoscaling (HPA/VPA) will fail to scale as desired.
* To support more pods, the cluster must scale.

---

### Cluster Autoscaler

EKS **does not** autoscale node count by default.

* You must explicitly configure the **Cluster Autoscaler**.
* Once enabled, it scales node groups based on pending pods and unschedulable workloads.

---

### Metrics Server

The **metrics-server** collects resource metrics (CPU/memory) from Kubelets and exposes them through the Metrics API.

* HPA and VPA use this data to make scaling decisions.
* You can view metrics using:

  ```bash
  kubectl top nodes
  kubectl top pods
  ```
* The metrics server requires proper **RBAC** permissions.

By default, Kubernetes doesn’t include a metrics server — you must install it manually.

---

### Why Requests and Limits Are Recommended

* Guarantees that Kubernetes can schedule pods effectively.
* Prevents resource hogging by any single pod.
* Protects node and cluster stability.
* Enables autoscaling features (HPA, VPA, Cluster Autoscaler).

Without limits:

* One pod can consume excessive resources.
* Other pods on the node can suffer (throttling, eviction).

---

**Note:** Installation steps, deployment manifests, and metrics-server setup are excluded and will be documented separately.

---
## Metrics Server Releases:
Releases: https://github.com/kubernetes-sigs/metrics-server/releases

Install using the kubectl command:

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml





https://repost.aws/knowledge-center/eks-metrics-server-pod-autoscaler


https://artifacthub.io/packages/helm/metrics-server/metrics-server

helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/

helm upgrade --install metrics-server metrics-server/metrics-server


By using the add-on: