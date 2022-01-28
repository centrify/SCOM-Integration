$api = New-Object -ComObject "MOM.ScriptAPI"
$api.LogScriptEvent("Centrify MP DZ.Agent.MonitorRegistry.ps1 Executed", 101, 4, "HKLM:\SOFTWARE\Centrify\DirectAuthorize\Agent\CurrentState")

$dz_agent_state_number = (Get-ItemProperty -Path HKLM:\SOFTWARE\Centrify\DirectAuthorize\Agent -Name CurrentState).CurrentState
$dz_agent_state = ""
$dz_agent_down = 1

switch ($dz_agent_state_number)
{
    0 {$dz_agent_state = "Unknown"; Break}
	1 {$dz_agent_state = "Initializing"; Break}
	2 {$dz_agent_state = "NotJoinedZone"; Break}
	3 {$dz_agent_state = "Connected"; $dz_agent_down = 0;  Break}
	4 {$dz_agent_state = "Disconnected"; Break}
	5 {$dz_agent_state = "Stopping"; Break}
	6 {$dz_agent_state = "Stopped"; Break}
	7 {$dz_agent_state = "Rescue"; Break}
}


$bag = $api.CreatePropertyBag()
$bag.AddValue("DzAgentStateNumber", $dz_agent_state_number)
$bag.AddValue("DzAgentState", $dz_agent_state)
$bag.AddValue("DzAgentDown", $dz_agent_down)

# $api.return($bag)
$bag