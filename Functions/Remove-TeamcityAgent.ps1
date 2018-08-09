<#
.SYNOPSIS
    Delete a Teamcity Agent from Teamcity server
#>
function Remove-TeamcityAgent {
    [CmdletBinding()]
    param(
        # The name of the Teamcity agent
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Name
    )
    process {
        Invoke-RestMethod `
            -Uri "$TeamcityServer/httpAuth/app/rest/agents/name:$Name" `
            -Method Delete `
            -UseBasicParsing `
            -Credential $Credential
    }
}
