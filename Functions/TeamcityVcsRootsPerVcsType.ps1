function Get-TeamcityVcsRootsPerVcsType
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('Git', 'Mercurial', 'SVN')]
        [string] $VcsType
    )
	
    $locator = 'type:jetbrains.git'
    if( $VcsType -ne 'Git') {
        $locator = "type:$($VcsType.ToLower())"
    }

    Get-TeamcityVcsRoots -locator $locator
}