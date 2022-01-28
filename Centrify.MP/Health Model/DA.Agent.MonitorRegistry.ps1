$api = New-Object -ComObject "MOM.ScriptAPI"
$api.LogScriptEvent("Centrify MP DA.Agent.MonitorRegistry.ps1 Executed", 101, 4, "HKLM:\SOFTWARE\Centrify\DirectAudit\Agent\CurrentState")

$da_agent_state_number = (Get-ItemProperty -Path HKLM:\SOFTWARE\Centrify\DirectAudit\Agent -Name CurrentState).CurrentState
$da_agent_state = ""
$da_agent_down = 1

switch ($da_agent_state_number)
{
    0 {$da_agent_state = "Unknown"; Break}
	1 {$da_agent_state = "Stopped"; Break}
	2 {$da_agent_state = "Initializing"; Break}
	3 {$da_agent_state = "DeterminingInstallation"; Break}
	4 {$da_agent_state = "InstallationNotConfigured"; Break}
	5 {$da_agent_state = "DeterminingAuditStore"; Break}
	6 {$da_agent_state = "AgentNotInAuditStoreScope"; Break}
	7 {$da_agent_state = "CollectorNotConnected"; Break}
	8 {$da_agent_state = "SpoolPartitionFull"; Break}
	9 {$da_agent_state = "Running"; $da_agent_down = 0; Break}
	10 {$da_agent_state = "Initialized"; Break}
	11 {$da_agent_state = "AwaitingCertificate"; Break}
}


$bag = $api.CreatePropertyBag()
$bag.AddValue("DaAgentStateNumber", $da_agent_state_number)
$bag.AddValue("DaAgentState", $da_agent_state)
$bag.AddValue("DaAgentDown", $da_agent_down)

# $api.return($bag)
$bag