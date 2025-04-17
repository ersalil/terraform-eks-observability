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
├── README.md
├── main.tf
├── providers.tf
├── terraform.tfstate
├── terraform.tfvars
├── variable.tf
├── modules
│   ├── cluster
│   │   ├── access.tf
│   │   ├── alb-controller.tf
│   │   ├── data.tf
│   │   ├── iam_policy.tf
│   │   ├── outputs.tf
│   │   ├── variables.tf
│   │   └── vpc.tf
│   ├── dashboard
│   │   ├── kube-metric.tf
│   │   ├── kube-metrics.json
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── monitoring
│       ├── helm_values
│       │   ├── grafana_values.yaml
│       │   └── prom_values.yaml
│       ├── monitoring.tf
│       └── variables.tf
└── terraform.tfstate
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

### 3. (Optional) Create S3 Bucket for Terraform Backend

> Replace `<your-s3-bucket-name>` and `<your-region>` with actual values.

By default, the S3 backend is disabled for ease of use. To enable it, uncomment the following lines in the `providers.tf` file and configure the S3 bucket:

```hcl
terraform {
  backend "s3" {
    bucket = "<your-s3-bucket-name>"
    key    = "terraform.tfstate"
    region = "<your-region>"
  }
}
```

### 6. Update Terraform Variables

Update the following values in your `terraform.tfvars` or environment configuration:

```hcl
region                = "us-east-2"
SOURCE_GMAIL_ID       = "testsalilapp@gmail.com"
SOURCE_AUTH_PASSWORD  = "myyk fuac jnfg fveo"
DESTINATION_GMAIL_ID  = ""
```

> ⚠️ **NOTE:** All values are **mandatory** — if any are missing, the Alertmanager pod will crash.
>
> - A temporary **SOURCE Gmail ID** and **App Password** have been provided for your convenience.  
> - Please configure your own **source Gmail credentials** before moving to production.
> - **Set `DESTINATION_GMAIL_ID` to your email** to receive alerts.

### 5. Initialize Terraform

```bash
terraform init
```

### 6. Deploy EKS Cluster

```bash
terraform apply -target=module.cluster
```

### 7. Deploy Monitoring Stack (Prometheus & Grafana)

```bash
terraform apply -target=module.monitoring
```

### 8. Provision Grafana Dashboard

```bash
terraform apply -target=module.dashboard
```

> 📌 After the final step, Terraform will output the LoadBalancer URL to access Grafana.
>
> **Login Credentials**  
> Username: `admin`  
> Password: `admin`

ℹ️ **Note:** At this stage, not all variables have been configured, including those for the EKS cluster name and other related settings. These variables will be properly defined and included in future commits to ensure a complete and customizable setup.


