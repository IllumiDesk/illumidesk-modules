package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestIllumideskDeploymentHelmTemplateEngine(t *testing.T) {
	t.Parallel()

	terraformClusterOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/cluster",
		VarFiles:     []string{"./varfile.tfvars"},
		EnvVars: map[string]string{
			"KUBE_CONFIG_PATH": "~/.kube/config",
		},
	})

	terraformIllumideskOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/illumidesk",
		VarFiles:     []string{"./varfile.tfvars"},
		EnvVars: map[string]string{
			"KUBE_CONFIG_PATH": "~/.kube/config",
		},
	})

	//at end of test run terraform destroy
	defer terraform.Destroy(t, terraformClusterOptions)
	defer terraform.Destroy(t, terraformIllumideskOptions)

	//will initialize and apply terraform and fail if any error exists
	terraform.InitAndApply(t, terraformClusterOptions)
	terraform.InitAndApply(t, terraformIllumideskOptions)

}
