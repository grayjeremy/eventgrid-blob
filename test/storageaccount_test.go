package test

import (
	"fmt"
	"net/http"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformStorageAccount(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "fixture",

		Vars: map[string]interface{}{},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	storageAccountBaseURL := terraform.Output(t, terraformOptions, "storageAccountEndpoint")

	maxRetries := 15
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("HTTP to %s", storageAccountBaseURL)

	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {

		response, err := http.Get(storageAccountBaseURL)
		if err != nil {
			return "", err
		}

		defer response.Body.Close()
		fmt.Println("HTTP succeeded")

		return "", nil
	})
}
