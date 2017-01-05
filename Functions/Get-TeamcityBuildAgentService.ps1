function Get-TeamcityBuildAgentService
{
	[CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [int] $Id
    )

		process {

			$agent = Get-TeamcityBuildAgentDetails -Id $Id

			if( $agent ) {
				# grab the agent letter from its name
				$letter = $agent.Name.ToCharArray() | select -Last 1

				Get-Service "TCBuildAgent$letter" -ComputerName $agent.Hostname -verbose
			}

		}

}
