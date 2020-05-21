
$config = ""
if(-not (Test-Path -Path "config.json")){
    $config = "" | Select-Object -Property Exename,Rulename
}else{
    $config = Get-Content "config.json" -Raw | ConvertFrom-Json 
}
Disable-NetFirewallRule -Name $config.Rulename