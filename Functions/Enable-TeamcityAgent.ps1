<#
.SYNOPSIS
Enable/Authorize a Teamcity Agent
.DESCRIPTION
Can enable/disable agent
Can authorize/deauthorize agent
Can set the agent pool
#>
function Enable-TeamcityAgent {
    [CmdletBinding()]
    param(
        # The name of the Teamcity agent
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory)]
        [string] $AgentName,

        # Enable the agent if set to $true. Disable if set to $false
        # If not specified, don't enable/disable the agent
        [bool] $Enable,

        # Authorize the agent if set to $true. deauthorize if set to $false
        # If not specified, don't authorize/deauthorize the agent
        [bool] $Authorize,

        # If set, associate the agent with the given agent pool
        [string] $PoolName
    )
    $local:VerbosePreference = 'Continue'

    $agentUrl = "$TeamcityServer/httpAuth/app/rest/agents/name:$AgentName"

    $agent = ([xml](Invoke-WebRequest "$agentUrl" -Credential $Credential -UseBasicParsing -verbose:$false).Content).agent

    if($PoolName -and $agent.Pool.Name -ne $PoolName) {
        Write-Verbose "Associating agent $AgentName with pool $PoolName"
        # Associate the agent with the given TC pool.
        $pool = Get-TeamcityAgentPools | ? name -eq $PoolName
        if(!$pool) {
            throw "Could not find agent pool '$PoolName'"
        }

        Invoke-WebRequest `
            "$TeamcityServer$($pool.href)/agents" `
            -Credential $Credential `
            -UseBasicParsing `
            -Method Post `
            -ContentType application/xml `
            -Body "<agent id='$($agent.id)' />" -verbose:$false
    } else {
        Write-Verbose "Agent $AgentName already belongs to pool '$PoolName'"
    }

    if($Enable -ne $null) {
        if([boolean]::Parse($agent.enabled) -ne $Enable) {
            Write-Verbose "Setting 'enabled' property of agent $AgentName to $Enable"
            Invoke-WebRequest `
                "$agentUrl/enabled" `
                -Credential $Credential `
                -UseBasicParsing `
                -Method Put `
                -Body $Enable -verbose:$false
        } else {
            Write-Verbose "Keeping 'authorized' property of $AgentName to $Enable"
        }
    }

    if($Authorize -ne $null) {
        if([boolean]::Parse($agent.authorized) -ne $Authorize) {
            Write-Verbose "Setting 'authorized' property of agent $AgentName to $Authorize"
            Invoke-WebRequest `
                "$agentUrl/authorized" `
                -Credential $Credential `
                -UseBasicParsing `
                -Method Put `
                -Body $Authorize -verbose:$false
        } else {
            Write-Verbose "Keeping 'authorized' property of $AgentName to $Authorize"
        }
    }
}
