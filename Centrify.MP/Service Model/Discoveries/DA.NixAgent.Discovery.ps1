param($SourceId,$ManagedEntityId,$TargetSystem,$StdOut)

# For testing discovery manually in PowerShell:
# $SourceId = '{00000000-0000-0000-0000-000000000000}'
# $ManagedEntityId = '{00000000-0000-0000-0000-000000000000}'
# $StdOut = "2,LINUX,kevinhol"
# $TargetSystem = "ubuntu.opsmgr.net"

#=================================================================================
# Constants section - modify stuff here:

# Assign script name variable for use in event logging
$ScriptName = "Centrify.MP.Discovery.NixAgent.Datasource.ps1"
#=================================================================================

# Gather script start time
$StartTime = Get-Date

# Gather who the script is running as
$WhoAmI = whoami

# Load MOMScript API
$momapi = New-Object -comObject MOM.ScriptAPI

# Load SCOM Discovery module
$DiscoveryData = $momapi.CreateDiscoveryData(0, $SourceId, $ManagedEntityId)

# Log an event for the script starting
$momapi.LogScriptEvent($ScriptName,6666,0, "Script is starting. *Nix Agent: ($TargetSystem) StdOut: ($StdOut) Running, as $WhoAmI.")

# Clear any previous errors
if($Error)
{
$Error.Clear()
}


#=================================================================================
# MAIN body of your script

if($StdOut -ne $null -and $StdOut -ne "0" -and $StdOut -ne "")
{
	$str = $StdOut
	$adclient = ""
	$daemon = ""
	$installation = ""
	$collector = ""
	$NssModule = ""
	$advMonitor = ""
	$deskAudit = ""

	foreach($line in $str.Split([Environment]::NewLine))
	{
		$keyVal = $line.Split(":")
		switch($keyVal[0].Trim().ToLower())
		{
			"pinging adclient"{ $adclient = $keyVal[1].Trim() }
			"daemon status"{ $daemon = $keyVal[1].Trim() }
			"current installation"{ $installation = $keyVal[1].Trim() }
			"current collector"{ $collector = $keyVal[1].Trim() }
			"directAudit nss module"{ $NssModule = $keyVal[1].Trim() }
			"directAudit advanced monitoring"{ $advMonitor = $keyVal[1].Trim() }
			"directAudit desktop auditing"{ $deskAudit = $keyVal[1].Trim() }
		}
	}

	# Create discovery data
	$Inst = $DiscoveryData.CreateClassInstance("$MPElement[Name='Centrify.MP.DA.NixAgent']$")
	$Inst.AddProperty("$MPElement[Name='Unix!Microsoft.Unix.Computer']/PrincipalName$", $TargetSystem)
	$Inst.AddProperty("$MPElement[Name='Centrify.MP.DA.NixAgent']/Adclient$", $adclient)
	$Inst.AddProperty("$MPElement[Name='Centrify.MP.DA.NixAgent']/Daemon$", $daemon)
	$Inst.AddProperty("$MPElement[Name='Centrify.MP.DA.NixAgent']/CurrentInstallation$", $installation)
	$Inst.AddProperty("$MPElement[Name='Centrify.MP.DA.NixAgent']/CurrentCollector$", $collector)
	$Inst.AddProperty("$MPElement[Name='Centrify.MP.DA.NixAgent']/NssModule$", $NssModule)
	$Inst.AddProperty("$MPElement[Name='Centrify.MP.DA.NixAgent']/AdvancedMonitoring$", $advMonitor)
	$Inst.AddProperty("$MPElement[Name='Centrify.MP.DA.NixAgent']/DesktopAuditing$", $deskAudit)
	$DiscoveryData.AddInstance($Inst)
	#=================================================================================

	# Return Discovery Items Normally
	$DiscoveryData

	# Return Discovery Bag to the command line for testing (does not work from ISE):
	#  $momapi.Return($DiscoveryData)
}
Else
{
# Log an event the StdOut was NULL
$momapi.LogScriptEvent($ScriptName,6667,2, "StdOut was NULL.  Did not get any data from *Nix Shell Command")
}

# End script and record total runtime
$EndTime = Get-Date
$ScriptTime = ($EndTime - $StartTime).TotalSeconds
# Log an event for script ending and total execution time.
$momapi.LogScriptEvent($ScriptName,6666,0, "Script has completed.  Runtime was $ScriptTime seconds")