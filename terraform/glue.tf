resource "random_uuid" "correlation_id" {
}

resource "null_resource" "create_arc" {
  triggers = {
    ec2_id = module.k8s.workload_ec2_id
  }

  provisioner "local-exec" {
    command = <<EOF
    az provider register --namespace Microsoft.Kubernetes && \
    az provider register --namespace Microsoft.KubernetesConfiguration && \
    az provider register --namespace Microsoft.ExtendedLocation && \
    KUBECONFIG=${path.module}/kube_config_workload.yaml ${path.module}/wait_for_workload_cluster.sh && \
    az connectedk8s connect --name "arc-${var.azure_suffix}" --resource-group "${module.aml.rg_name}" --location "${module.aml.location}" --correlation-id "${random_uuid.correlation_id.result}" --kube-config ${path.module}/kube_config_workload.yaml --distribution rancher_rke
    EOF
  }
}

resource "null_resource" "create_aml_extension" {
  triggers = {
    create_arc = null_resource.create_arc.id
  }

  provisioner "local-exec" {
    command = <<EOF
    az k8s-extension create -n amlarc-extension --extension-type Microsoft.AzureML.Kubernetes --configuration-settings enableTraining=True --cluster-type connectedClusters --cluster-name "arc-${var.azure_suffix}" --resource-group "${module.aml.rg_name}"
    EOF
  }
}
