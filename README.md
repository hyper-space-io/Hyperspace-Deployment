# Hyperspace Deployment Repository

This repository serves as a template for customers to deploy and manage their self-hosted Hyperspace application using ArgoCD. 
It works in conjunction with the [Hyperspace Terraform Cloud module](https://github.com/hyper-space-io/Hyperspace-terraform-module) to provision the necessary infrastructure.

## Repository Structure

```
.
├── argocd/                    # ArgoCD configuration
│   ├── envs/                  # Environment-specific configurations
│   │   └── example-env/       # Example environment template
│   ├── root-applications/     # Root ArgoCD applications
│   └── ecr-credentials-sync/  # ECR credentials synchronization
└── values/                    # Environment values
    └── example-env/           # Example environment values
```

## Prerequisites

- Hyperspace Terraform Cloud module Deployed
- Access to your Kubernetes cluster (Using TF-Agent)
- ArgoCD installed in your cluster (Handled By Hyperspace Terraform Cloud module)
- `kubectl` CLI configured to access your cluster
- Hyperspace account ID (contact Hyperspace support to obtain this)
- Access to ArgoCD UI

## Getting Started

### 1. Fork and Clone this Repository

```bash
git clone https://github.com/hyper-space-io/Hyperspace-Deployment.git
cd Hyperspace-Deployment
```

### 2. Set Up Your Environment

1. **Configure Environment Values**

   Edit the following files with your environment-specific values:

   a. **Update Root Application Configuration**
   
   Edit `argocd/root-applications/example-root-application.yaml`:
   ```yaml
   metadata:
     name: your-environment  # Change this to your environment name
     namespace: argocd
   spec:
     project: your-environment  # Change this to your environment name
     source:
       repoURL: https://github.com/your-org/Hyperspace-Deployment.git  # Update with your forked repository URL
       targetRevision: master
       path: argocd/envs/your-environment  # Update with your environment path
   ```

   b. **Update Environment Values**
   
   Edit `argocd/envs/your-environment/values.yaml`:
   ```yaml
   ECR_REGISTRY: hyperspace-account-id.dkr.ecr.hyperspace-region.amazonaws.com  # Provided By Hyperspace
   ORG_NAME: your-org  # Update with your GitHub organization
   Deployment_Repo: Hyperspace-Deployment  # Update if you renamed the repository
   environment: your-environment  # Update with your environment name
   ```

   c. **Update ApplicationSet Configuration**
   
   Edit `argocd/envs/your-environment/templates/example-applicationset.yaml`:
   ```yaml
   metadata:
     name: {{ .Values.environment }}-deployment
   spec:
     generators:
     - list:
         elements:
         - name: your-app  # Update with your application name
           targetRevision: 1.1.180  # Update with your desired version
   ```

   d. **Update Environment Values**
   
   Edit `values/your-environment/test-env.yaml`:
   ```yaml
   global:
     environment: your-environment  # Update with your environment name
     project: your-environment  # Update with your environment name
     ecr_repository: hyperspace-account-id.dkr.ecr.hyperspace-region.amazonaws.com  # Update with your ECR repository
   
   # Update application-specific configurations
   data-node:
     replicaCount: 1
     # ... other configurations ...
   
   search-master:
     ingress:
       hosts:
         - host: your-environment.your-domain.com  # Update with your domain
   ```

### 3. Deploy ArgoCD Applications

1. **Apply Root Application**

   ```bash
   kubectl apply -f argocd/root-applications/your-environment.yaml
   ```

2. **Access ArgoCD UI**
   - Login with your Github Account
   - Navigate to your environment's root application
   - Click "Sync" to deploy your applications

## Managing Applications

### Adding New Applications

1. **Update ApplicationSet**

   Edit the ApplicationSet Manifest `argocd/envs/<environment>/templates/applicationset-<environment>.yaml` file to include your new application.

2. **Create Application Configuration**

   Add a new YAML file in `/values/<environment>/your-app.yaml` with your application's configuration (Copy from an existing one)

3. **Commit and Push Changes**

   ```bash
   git add .
   git commit -m "Add new application: your-app"
   git push
   ```
   
4. **Sync in ArgoCD UI**
   - Navigate to your environment's root application
   - Click "Sync" to apply the new application configuration

## Troubleshooting

If you encounter issues with your deployments:

1. Check the ArgoCD UI for error messages
2. Verify your configuration files are valid YAML
3. Ensure the target Kubernetes namespace exists
4. Check application logs in ArgoCD UI
5. Verify container registry access and credentials
6. Check if the root application is healthy in ArgoCD UI

## Support

For additional support:
- Contact Hyperspace support team
- Check the [Terraform Cloud module documentation](https://github.com/hyper-space-io/Hyperspace-terraform-module)