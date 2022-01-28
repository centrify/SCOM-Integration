param([string]$StdOut, [string]$StdErr, [string]$ReturnCode)

$ScriptName = "Centrify.MP.DA.NixAgent.DaemonMonitor.ps1"

# Gather script start time
$StartTime = Get-Date

# Gather who the script is running as
$WhoAmI = whoami

$api = New-Object -comObject 'MOM.ScriptAPI'

# Log an event for the script starting
$api.LogScriptEvent($ScriptName, 5555, 0, "Script is starting. *Nix Agent: StdOut: ($StdOut) Running, as $WhoAmI.")

# Clear any previous errors
if($Error)
{
	$Error.Clear()
}

$str = $StdOut
         
#=================================================================================
# MAIN body of your script

if($str -ne $null -and $str -ne "0" -and $str -ne "")
{
	foreach($line in $str.Split([Environment]::NewLine))
	{
		$keyVal = $line.Split(":")
		if($keyVal[0].Trim().ToLower() -eq "daemon status")
		{
			$sValue = $keyVal[1].Trim()

			if ($sValue -ne $null)
			{
				$bag = $api.CreatePropertyBag()
				$bag.AddValue("PropertyName", "DaemonStatus")
				$bag.AddValue("PropertyValue", "Daemon is " + $sValue)
				$bag
			}
		}
	}
}
Else
{
	# Log an event the StdOut was NULL
	$api.LogScriptEvent($ScriptName, 5557, 2, "StdOut was NULL.  Did not get any data from *Nix Shell Command: ($ScriptName)");
	$bag = $api.CreatePropertyBag()
	$bag.AddValue("PropertyName", "DaemonStatus")
	$bag.AddValue("PropertyValue", "Daemon is offline")
	$bag
}

# End script and record total runtime
$EndTime = Get-Date
$ScriptTime = ($EndTime - $StartTime).TotalSeconds
# Log an event for script ending and total execution time.
$api.LogScriptEvent($ScriptName, 5555, 0, "Script has completed.  Runtime was $ScriptTime seconds")