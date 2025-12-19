# Kubernetes Scheduling – Interview Questions & Answers

This document contains concise, interview‑ready answers related to Kubernetes Pod Scheduling.

---

## **1. By default on which Kubernetes nodes are Pods scheduled?**

* Pods are scheduled on **any available worker node**.
* The scheduler selects the node based on:

  * available CPU and memory resources
  * taints & tolerations
  * affinity/anti-affinity rules
  * resource requests & limits
* No manual selection unless configured.

---

## **2. Can I control the placement of Pods?**

Yes — using the following mechanisms:

* **nodeName** → hard pin to a specific node
* **nodeSelector** → match simple node labels
* **Node Affinity** → advanced scheduling rules (In, NotIn, Exists, Gt, Lt)
* **Taints & Tolerations** → restrict certain nodes; allow only specific pod types
* **Pod Affinity / Anti-affinity** → place pods near/away from other pods
* **Combined Labels + Taints + Node Affinity** → strongest control; full node isolation

---

## **3. What is the difference between nodeSelector and nodeAffinity?**

* `nodeSelector` → simple equality match (`key=value`)
* Node Affinity → supports multiple operators and soft/hard preferences

---

## **4. What is the difference between taints and tolerations?**

* **Taints** are applied on nodes to repel pods.
* **Tolerations** are applied on pods to allow scheduling onto tainted nodes.

---

## **5. When would you use Pod Anti-Affinity?**

* To spread replicas across nodes.
* To ensure high availability.
* To avoid all Pods being placed on a single node.

---

## **6. What happens if a Pod has hard node affinity but no matching node exists?**

* The Pod stays in a **Pending** state indefinitely.
* The scheduler will never place it on a non-matching node.

---

## **7. What is `preferredDuringSchedulingIgnoredDuringExecution`?**

* A **soft preference**.
* Scheduler will **try** to satisfy it.
* If not possible, the Pod may still run on other nodes.

---

## **8. How do you dedicate a node only for a specific workload?**

* Label the node.
* Taint the node.
* Add toleration + node affinity to the Pod.
* Only intended workloads can run on that node.

---

## **9. What is the scheduler’s main responsibility?**

* Detect unscheduled Pods.
* Evaluate nodes based on constraints & resources.
* Bind Pods to the most suitable node.

---

## **10. What happens if a node is tainted with `NoExecute`?**

* Existing Pods without toleration are **evicted**.
* New Pods without toleration cannot schedule here.

---

## **11. How can you spread Pods evenly across nodes?**

* Use **Pod Anti-Affinity**.
* OR use **Topology Spread Constraints**.

---

## **12. How do you ensure a Pod runs on a GPU node?**

* Label GPU nodes → `gpu=true` (or similar).
* Taint GPU nodes → `gpu=true:NoSchedule`.
* Pod must include:

  * toleration for GPU taint
  * node affinity for GPU label

---

## **13. What is the difference between soft and hard scheduling rules?**

* **Hard rules** → must be satisfied (e.g., requiredDuringSchedulingIgnoredDuringExecution)
* **Soft rules** → scheduler tries to satisfy but may ignore (e.g., preferredDuringSchedulingIgnoredDuringExecution)

---

## **14. What factors does the scheduler consider when placing Pods?**

* CPU and memory availability
* Node taints
* Node affinity rules
* Pod affinity/anti-affinity
* Resource requests & limits
* Topology constraints

---

## **15. How to prevent normal workloads from running on a sensitive node?**

* Apply a taint to that node.
* Only Pods with matching tolerations can run there.

---

If you want, I can also create a **"Kubernetes Scheduling Cheat Sheet"** in another document or convert this into a **PDF** for your GitHub.
