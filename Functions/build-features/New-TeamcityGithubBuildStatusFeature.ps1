<#
.SYNOPSIS
    Add a new Github 'Commit status publisher' build feature to an existing build configuration

.OUTPUTS


.EXAMPLE

#>
Function New-TeamcityGithubBuildStatusFeature
{
    [CmdletBinding()]
    Param
    (
        # The id of the build configuration
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=0)]
        [string] $BuildTypeId,

        # GitHub personal access token
        [string] $Token
    )
    Begin
    {
        # code
    }
    Process
    {
        $body = @"
<feature type="commit-status-publisher">
    <properties>
        <property name="github_authentication_type" value="token"/>
        <property name="github_host" value="https://api.github.com"/>
        <property name="publisherId" value="githubStatusPublisher"/>
        <property name="secure:github_access_token" value="$Token" />
    </properties>
</feature>
"@

        Invoke-RestMethod `
            -Uri "$TeamcityServer/httpAuth/app/rest/buildTypes/id:$BuildTypeId/features" `
            -Credential $Credential `
            -Method Post `
            -Body $body `
            -ContentType 'application/xml'
    }
    End
    {
    }
}
