function Get-TeamcityAgentPools {
    [CmdletBinding()]
    param()

    ([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/agentPools" -Credential $Credential -UseBasicParsing).Content).agentPools.agentPool |
        select id, name, href
}
