param([string]$StdOut, [string]$StdErr, [string]$ReturnCode)

$ScriptName = "Centrify.MP.DA.NixAgent.DiskSpaceMonitor.ps1"

# Gather script start time
$StartTime = Get-Date

# Gather who the script is running as
$WhoAmI = whoami

$api = New-Object -comObject 'MOM.ScriptAPI'

# Log an event for the script starting
$api.LogScriptEvent($ScriptName, 4444, 0, "Script is starting. *Nix Agent: StdOut: ($StdOut) Running, as $WhoAmI.")

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
		if($keyVal[0].Trim().ToLower() -eq "database filesystem use")
		{
			foreach($item in $keyVal[1].Trim().Split(","))
			{
				$arr = $item.Trim().Split(" ")
				if($arr.IndexOf("total") -gt -1) {
					$total = $arr[0]
				}
				elseif($arr.IndexOf("free") -gt -1) {
					$free = $arr[0]
				}
			}
			$percFree = ($free / $total) * 100
        
			$bag = $api.CreatePropertyBag()

			if($percFree -lt 20) {
				$bag.AddValue("PropertyName", "DiskSpaceStatus")
				$bag.AddValue("PropertyValue", "Free Disk Space ["+ [System.Math]::Round($percFree, 2) +"%] is low, less than 20%")
			}
			else {
				$bag.AddValue("PropertyName", "DiskSpaceStatus")
				$bag.AddValue("PropertyValue", "ok")
			}
			$bag
		}
	}
}
Else
{
	# Log an event the StdOut was NULL
	$api.LogScriptEvent($ScriptName, 4447, 2, "StdOut was NULL.  Did not get any data from *Nix Shell Command")
}

# End script and record total runtime
$EndTime = Get-Date
$ScriptTime = ($EndTime - $StartTime).TotalSeconds
# Log an event for script ending and total execution time.
$api.LogScriptEvent($ScriptName, 4444, 0, "Script has completed.  Runtime was $ScriptTime seconds")