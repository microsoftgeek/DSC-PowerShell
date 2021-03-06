#--------------------------------------------------------------------------------- #The sample scripts are not supported under any Microsoft standard support #program or service. The sample scripts are provided AS IS without warranty  #of any kind. Microsoft further disclaims all implied warranties including,  #without limitation, any implied warranties of merchantability or of fitness for #a particular purpose. The entire risk arising out of the use or performance of  #the sample scripts and documentation remains with you. In no event shall #Microsoft, its authors, or anyone else involved in the creation, production, or #delivery of the scripts be liable for any damages whatsoever (including, #without limitation, damages for loss of business profits, business interruption, #loss of business information, or other pecuniary loss) arising out of the use #of or inability to use the sample scripts or documentation, even if Microsoft #has been advised of the possibility of such damages #--------------------------------------------------------------------------------- 

function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
		[String]
		$TimeZone
	)

    #Get the current TimeZone
    $CurrentTimeZone = Invoke-Expression "tzutil.exe /g"

	$returnValue = @{
		TimeZone = $CurrentTimeZone
	}

    #Output the target resource
	$returnValue
}


function Set-TargetResource
{
	[CmdletBinding(SupportsShouldProcess=$true)]
	param
	(
		[parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
		[String]
		$TimeZone
	)
    
    #Output the result of Get-TargetResource function.
    $GetCurrentTimeZone = Get-TargetResource -TimeZone $TimeZone

    If($PSCmdlet.ShouldProcess("'$TimeZone'","Replace the System Time Zone"))
    {
        Try
        {
            Write-Verbose "Setting the TimeZone"
            Invoke-Expression "tzutil.exe /s ""$TimeZone"""
        }
        Catch
        {
            $ErrorMsg = $_.Exception.Message
            Write-Verbose $ErrorMsg
        }
    }
}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
		[String]
		$TimeZone
	)

    #Output from Get-TargetResource
    $Get = Get-TargetResource -TimeZone $TimeZone

    If($TimeZone -eq $Get.TimeZone)
    {
        return $true
    }
    Else
    {
        return $false
    }
}

Export-ModuleMember -Function *-TargetResource

