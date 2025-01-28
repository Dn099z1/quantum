
$ports = 3000..3010

foreach ($port in $ports) {
    $ruleName = "Abrir Porta HTTP $port"
    Write-Output "Abrindo porta $port no firewall..."
    
    # Adiciona a regra ao firewall
    New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow
}

Write-Output "Todas as portas foram abertas com sucesso!"
