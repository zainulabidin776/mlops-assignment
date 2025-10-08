Write-Host "Testing service via Ingress..."
try {
  $root = (Invoke-WebRequest -Uri http://heart.local/ -UseBasicParsing).Content
  Write-Host "Root: $root"
} catch {
  Write-Error "Failed to reach root endpoint. Ensure hosts mapping to Minikube IP and ingress is ready."
}

if (Test-Path .\test_data_correct.json) {
  try {
    $resp = Invoke-WebRequest -Uri http://heart.local/predict -Method POST -ContentType 'application/json' -InFile .\test_data_correct.json -UseBasicParsing
    Write-Host "Predict response: $($resp.Content)"
  } catch {
    Write-Error "Prediction call failed: $($_.Exception.Message)"
  }
} else {
  Write-Warning "Missing test_data_correct.json in repo root."
}

