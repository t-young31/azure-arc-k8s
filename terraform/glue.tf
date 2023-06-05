

# az connectedk8s connect --name "arc-tmpty" --resource-group "rg-tmpty" --location "uksouth" --correlation-id "c18ab9d0-685e-48e7-ab55-12588447b0ed" --tags "Datacenter City StateOrDistrict CountryOrRegion" --kube-config k8s/terraform/kube_config_workload.yaml  --distribution rancher_rke

# az k8s-extension create -n amlarc-extension --extension-type Microsoft.AzureML.Kubernetes --configuration-settings enableTraining=True --cluster-type connectedClusters --cluster-name "arc-tmpty" --resource-group rg-tmpty

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
