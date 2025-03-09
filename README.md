# Hypersapce-Deployment


## Getting Started

### Prerequisites

- Access to a Kubernetes cluster with ArgoCD installed
- `kubectl` CLI configured to access your cluster
- Git credentials with access to this repository

### Deploying to a New Environment

1. **Clone the repository**

   ```bash
   git clone https://github.com/hyper-space-io/Hyperspace-Deployment.git
   cd Hyperspace-Deployment
   ```

2. **Create a new environment configuration**

   Copy an existing environment as a template:

   ```bash
   cp -r argocd/envs/development argocd/envs/your-new-environment
   ```

3. **Update the environment values**

   Edit `argocd/envs/your-new-environment/values.yaml` to set appropriate values for your environment.

4. **Create configuration files**

Add your application's configuration files to `argocd/conf-files/your-new-environment/`, using the values defined in the hyperspace helm chart as a reference.

5. **Create a root application**

   Create a new file in `argocd/root-applications/your-new-environment.yaml` based on the development example.

6. **Apply the root application to ArgoCD**

   ```bash
   kubectl apply -f argocd/root-applications/your-new-environment.yaml
   ```

### Adding a New Application

1. **Create a configuration file**

   Add a new YAML file in `argocd/conf-files/<environment>/your-app.yaml` with your application's configuration.

2. **Update the ApplicationSet**

   Edit the appropriate `argocd/envs/<environment>/templates/applicationset-<environment>.yaml` file to include your new application in the list elements.

3. **Commit and push your changes**

   ```bash
   git add .
   git commit -m "Add new application: your-app"
   git push
   ```

4. **ArgoCD will automatically detect and apply the changes**

## Configuration Reference

### Application Values

The `conf-files/<environment>/<app>.yaml` files contain application-specific configuration values, including:

- Global settings (environment, project)
- Component configurations (data-node, compiler-service, etc.)
- Image settings (tag, pull policy)
- Infrastructure settings (volumes, ingress, etc.)

### Environment Values

The `envs/<environment>/values.yaml` files contain environment-wide settings:

- `ECR_REGISTRY`: Container registry URL
- `ORG_NAME`: GitHub organization name
- `Deployment_Repo`: Name of this deployment repository
- `environment`: Environment name

## Troubleshooting

If you encounter issues with your deployments:

1. Check the ArgoCD UI for error messages
2. Verify that your configuration files are valid YAML
3. Check that the target Kubernetes namespace exists or that `CreateNamespace=true` is set