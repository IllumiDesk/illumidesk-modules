package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestIllumideskDeploymentHelmTemplateEngine(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../modules/illumidesk",
		VarFiles:     []string{"./varfile.tfvars"},
		EnvVars: map[string]string{
			"KUBECONFIG": "/root/.kube/config.yml",
		},
	})

	//at end of test run terraform destroy
	defer terraform.Destroy(t, terraformOptions)

	//will initialize and apply terraform and fail if any error exists
	terraform.InitAndApply(t, terraformOptions)

}
