function Get-TeamcityBuildAgentDetails
{
    [CmdletBinding(DefaultParametersetName='ById')]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true, ParameterSetName='ById')]
        [int] $Id,

        [Parameter(ValueFromPipelineByPropertyName=$true, ParameterSetName='ByName')]
        [string] $Name
    )

    process {

        $locator = switch($PsCmdlet.ParameterSetName) {
            'ById' { "id:$Id" }
            'ByName' { "name:$Name" }
        }

        $agentData = ([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/agents/$locator" -Credential $Credential -UseBasicParsing).Content).agent

        [pscustomobject] @{
            Id = $agentData.id
            Name = $agentData.name
            Typeid = $agentData.typeid
            Connected = $agentData.connected
            Enabled = $agentData.enabled
            Authorized = $agentData.authorized
            Uptodate = $agentData.uptodate
            Ip = $agentData.ip
            Properties = $agentData.properties.property
            Pool = $agentData.pool
            Hostname = try { [System.Net.Dns]::gethostentry($agentData.ip).hostname } catch { $agentData.ip }
        }

    }

}
