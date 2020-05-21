Set-Location $PSScriptRoot
$config = ""
if(-not (Test-Path -Path "config.json")){
    $config = "" | Select-Object -Property Exename,Rulename
}else{
    $config = Get-Content "config.json" -Raw | ConvertFrom-Json 
}
if(-not $config.Rulename){
    $rule = New-NetFirewallRule -Action Allow -DisplayName "GTA5 Host Whitelist" -Direction Inbound -Program $config.Exename
    $config.Rulename = $rule.Name
}
$config | ConvertTo-Json | Out-File -FilePath "config.json" 
$gtavrules = (Get-Content "GTA5.rules")
$whitelist = New-Object -TypeName System.Collections.ArrayList 
$whitelist.AddRange((Get-Content "whitelist.txt"))
$whitelist.AddRange($gtavrules)
foreach($i in $gtavrules){
    $i=$i.TrimStart();
    if(!($i.TrimStart().StartsWith("#"))&&!($i.TrimStart().StartsWith("="))){
        $nul = $whitelist.Add($i);
    }
}
foreach($i in $whitelist){
    $i
}
Set-NetFirewallRule -Name $config.Rulename -RemoteAddress $whitelist
Enable-NetFirewallRule -Name $config.Rulename

