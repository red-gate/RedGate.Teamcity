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
        # If we want to be able to remove an agent, we need to make sure no build is currently
        # running on it. So cancel any running build on the agent.
        Get-TeamcityBuilds -Locator "running:true,agentName:${Name}" | Remove-TeamcityBuild -Comment "Agent ${Name} is being deleted. Canceling and readding build to queue."

        Invoke-RestMethod `
            -Uri "$TeamcityServer/app/rest/agents/name:$Name" `
            -Method Delete `
            -UseBasicParsing `
            -Headers $Headers
    }
}
