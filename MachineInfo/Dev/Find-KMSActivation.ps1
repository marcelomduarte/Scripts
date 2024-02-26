Function Find-KMSActivation{
    # Obtém o objeto de licença ativa do computador
    $license = Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.PartialProductKey }

    # Verifica se a licença é do tipo KMS (Key Management Service)
    if ($license.Description -like "*KMS*") {
        # Se for uma licença KMS
        Write-Host "A licença é do tipo KMS (Key Management Service)."
    } else {
        # Se não for uma licença KMS
        Write-Host "A licença não é do tipo KMS."
    }
}