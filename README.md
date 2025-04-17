# 🛰️ EKS Observability with Grafana Dashboard using Terraform

This project demonstrates how to set up a complete observability stack on **AWS EKS** using **Terraform**, **Prometheus**, and **Grafana**. The setup includes automated provisioning of a Kubernetes metrics dashboard in Grafana using Terraform modules.

---

## 📌 Objective

Provision a monitoring stack on an EKS cluster using Terraform:
- Deploy Prometheus and Grafana using Helm.
- Expose Grafana via a LoadBalancer.
- Auto-provision a Kubernetes dashboard in Grafana as code.

---

## 🧰 Components

- **EKS Cluster**
- **Prometheus** – Installed via Helm
- **Grafana** – Installed via Helm and exposed via AWS LoadBalancer
- **Grafana Dashboard** – Auto-created via Terraform

---

## 🔧 Prerequisites

Ensure you have the following tools installed:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.3+)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)

---

## 📁 Project Structure

```bash
terraform-eks-observability/
├── main.tf
├── providers.tf
├── terraform.tfvars
├── alb-controller.tf
├── variable.tf
└── modules/
    ├── cluster/
    ├── monitoring/
    │   ├── helm_values/
    │   │   ├── grafana_values.yaml
    │   │   └── prom_values.yaml
    └── dashboard/
        ├── kube-metrics.json
        ├── kube-metric.tf
        ├── main.tf
        └── variables.tf
```

## 🚀 Getting Started

Follow the steps below to set up the EKS observability stack on your system:

### 1. Clone the Repository

```bash
git clone https://github.com/ersalil/terraform-eks-observability.git
cd terraform-eks-observability
```

### 2. Configure AWS Credentials

```bash
aws configure
```

### 3. Create S3 Bucket for Terraform Backend

> Replace `<your-s3-bucket-name>` and `<your-region>` with actual values.

```bash
aws s3api create-bucket --bucket <your-s3-bucket-name> --region <your-region>
```

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Update Terraform Variables

Edit the `terraform.tfvars` file with your environment-specific values:

```hcl
region       = "us-east-2"
cluster_name = "eks-observability-cluster"
...
```

### 6. Deploy EKS Cluster

```bash
terraform apply --target=module.cluster
```

### 7. Deploy Monitoring Stack (Prometheus & Grafana)

```bash
terraform apply --target=module.monitoring
```

### 8. Provision Grafana Dashboard

```bash
terraform apply --target=module.dashboard
```

> 📌 After the final step, Terraform will output the LoadBalancer URL to access Grafana.
>
> **Login Credentials**  
> Username: `admin`  
> Password: `admin`


