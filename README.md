# Hyperspace Deployment Repository

This repository serves as a template for customers to deploy and manage their self-hosted Hyperspace application using ArgoCD. 

It works in conjunction with the [Hyperspace Terraform module](https://github.com/hyper-space-io/Hyperspace-terraform-module) to provision the necessary infrastructure.

## Repository Structure

```
.
├── root-application.yaml      # Root ArgoCD application
├── argocd/                    # ArgoCD configuration
│   └── envs/                  # Environment-specific configurations
│       └── env-1/             # Environment template
│           ├── Chart.yaml     # Environment Helm chart
│           ├── values.yaml    # Default values
│           └── templates/     # ApplicationSet templates
└── values/                    # Environment values
    └── example-env/           # Example environment values
        └── env-1.yaml         # Environment-specific values
```

## Prerequisites

- Hyperspace Terraform module Deployed
- Access to your Kubernetes cluster
- ArgoCD installed in your cluster (Handled By Hyperspace Terraform module)
- `kubectl` CLI configured to access your cluster
- Hyperspace account ID (contact Hyperspace support to obtain this)
- Access to ArgoCD UI

## Getting Started

### 1. Fork, Clone or Import this Repository

```bash
git clone https://github.com/hyper-space-io/Hyperspace-Deployment.git
cd Hyperspace-Deployment
```

### 2. Set Up Your Environment

1. **Configure Root Application**

   Edit `root-application.yaml`:
   ```yaml
   metadata:
     name: your-environment  # Change this to your environment name
     namespace: argocd
   spec:
     project: default
     source:
       repoURL: https://github.com/your-org/Hyperspace-Deployment.git  # Update with your forked repository URL
       targetRevision: master
       path: argocd/envs/your-environment  # Update with your environment path
   ```

2. **Configure Environment Values**

   Edit `argocd/envs/your-environment/values.yaml`:
   ```yaml
   # Environment Configuration
   hyperspace_account_id: "HYPERSPACE_ACCOUNT_ID"  # Required: Hyperspace account ID

   # Repository Configuration
   vcsRepository: "https://github.com/your-org/your-values-repo.git"  # Your values repository

   # Sync Policy Configuration
   syncPolicy:
     automated:
       prune: true
       selfHeal: true
     syncOptions:
       - RespectIgnoreDifferences=true
       - CreateNamespace=true
   ```

   Required changes:
   1. Set your Hyperspace account ID
   2. (Optional) Disable automated sync by removing the `automated` section if you don't want automatic synchronization

3. **Create Environment Values**

   Create a new file in `values/example-env/your-environment.yaml`:
   ```yaml
   global:
     environment: your-environment
     ecr_repository: HYPERSPACE_ACCOUNT_ID

   data-node:
     replicaCount: 1
     # ... other configurations ...

   search-master:
     ingress:
       hosts:
         - host: your-environment.your-domain.com
   ```

### 3. Deploy ArgoCD Applications

1. **Apply Root Application**

   ```bash
   kubectl apply -f root-application.yaml
   ```

2. **Access ArgoCD UI**
   - Login with your Github Account
   - Navigate to your environment's root application
   - Click "Sync" to deploy your applications

## How It Works

1. **Root Application**
   - Bootstraps the environment by installing the environment Helm chart
   - Points to your environment configuration in `argocd/envs/your-environment/`

2. **Environment Helm Chart**
   - Contains the ApplicationSet template
   - Uses default values from `values.yaml`
   - References your company's ECR for the application chart
   - References your values repository for environment-specific configurations

3. **ApplicationSet**
   - Generates applications for each environment
   - Uses values from your values repository
   - Deploys the application from your company's ECR

## Managing Applications

### Adding New Environments

1. **Create Environment Directory**

   ```bash
   cp -r argocd/envs/env-1 argocd/envs/your-new-environment
   ```

2. **Update Environment Values**

   - Edit `argocd/envs/your-new-environment/values.yaml`
   - Create new values file in `values/example-env/your-new-environment.yaml`

3. **Create Root Application**

   ```bash
   cp root-application.yaml root-application-new-env.yaml
   # Edit the new file with your environment details
   ```

4. **Apply and Sync**

   ```bash
   kubectl apply -f root-application-new-env.yaml
   ```

## Troubleshooting

If you encounter issues with your deployments:

1. Check the ArgoCD UI for error messages
2. Verify your configuration files are valid YAML
3. Ensure the target Kubernetes namespace exists
4. Check application logs in ArgoCD UI
5. Verify ECR access and credentials
6. Check if the root application is healthy in ArgoCD UI

## Support

For additional support:
- Contact Hyperspace support team
- Check the [Terraform module documentation](https://github.com/hyper-space-io/Hyperspace-terraform-module)