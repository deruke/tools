function Invoke-Xor{
<#
  .SYNOPSIS
  This module single-byte XOR encodes a file and outputs the file to disk with a .out extension.
  
  .Description
  This module single-byte XOR encodes a file and outputs the file to disk with a .out extension.

  
  .Parameter
   InputFile - the target file to 
  
  .Parameter
  XorEncodeKey 

  .Example
  Invoke-Xor -DestinationFile .\go_r_https.exe -XorEncodeKey 6A


  #>

Param (

    [Parameter(Position = 0, Mandatory = $true)]
    [string]
    $InputFile = "",
 
    [Parameter(Position = 0, Mandatory = $true)]
    [string]
    $XorEncodeKey = ""

    )

$XorEncodeKey = "0x" + $XorEncodeKey
$outfile = $InputFile + ".out"
$bytes = [System.IO.File]::ReadAllBytes("$InputFile")

for($i=0; $i -lt $bytes.count ; $i++)
{
$bytes[$i] = $bytes[$i] -bxor $XorEncodeKey

}
[System.IO.File]::WriteAllBytes("$outFile", $bytes)

}