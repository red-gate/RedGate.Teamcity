function Remove-TeamcityBuild
{
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $Id,

        [string] $Comment = 'Canceled using Teamcity REST API, RedGate.Teamcity/Remove-TeamcityBuild'
    )
    process {
        $request = "<buildCancelRequest comment='$Comment' readdIntoQueue='true' />"

        $result = Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/builds/id:$Id" -Credential $Credential -Method Post -Body $request -ContentType 'application/xml' -UseBasicParsing

        "$($result.StatusCode) - $($result.StatusDescription)"
    }
}
