function Get-TeamcityBuildAgentDetails
{
	[CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string] $Id
    )

		process {

			$agentData = ([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/agents/id:$Id" -Credential $Credential -UseBasicParsing).Content).agent

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
