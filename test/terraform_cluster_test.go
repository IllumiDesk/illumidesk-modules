package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
)

const (
	remoteChartSource  = "https://illumidesk.github.io/helm-chart/"
	remoteChartName    = "illumidesk/cluster"
	remoteChartVersion = "0.0.1"
)

func TestClusterDeploymentHelmTemplateEngine(t *testing.T) {
	t.Parallel()

	helm.AddRepo(t)
	namespaceName := "kube-system"
	kubectlOptions := k8s.NewKubectlOptions("", "", namespaceName)

	options := &Options{
		kubectlOptions: kubectlOptions,
		setValues: 
	}

}
