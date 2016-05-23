# origin: https://github.com/psake/psake-contrib/blob/develop/teamcity.psm1

if ($env:TEAMCITY_VERSION) {
	# When PowerShell is started through TeamCity's Command Runner, the standard
	# output will be wrapped at column 80 (a default). This has a negative impact
	# on service messages, as TeamCity quite naturally fails parsing a wrapped
	# message. The solution is to set a new, much wider output width. It will
	# only be set if TEAMCITY_VERSION exists, i.e., if started by TeamCity.
	try {
		$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(8192,$host.UI.RawUI.MaxWindowSize.Height)
	} catch {
		Write-Warning "Could not set `$host.UI.RawUI.BufferSize. $_"
	}
}

function Write-TeamCityTestSuiteStarted([string]$name) {
	Write-TeamCityServiceMessage 'testSuiteStarted' @{ name=$name }
}
Set-Alias Teamcity-TestSuiteStarted Write-TeamCityTestSuiteStarted

function Write-TeamCityTestSuiteFinished([string]$name) {
	Write-TeamCityServiceMessage 'testSuiteFinished' @{ name=$name }
}
Set-Alias TeamCity-TestSuiteFinished Write-TeamCityTestSuiteFinished

function Write-TeamCityTestStarted([string]$name) {
	Write-TeamCityServiceMessage 'testStarted' @{ name=$name }
}
Set-Alias TeamCity-TestStarted Write-TeamCityTestStarted

function Write-TeamCityTestFinished([string]$name, [int]$duration) {
	$messageAttributes = @{name=$name; duration=$duration}

	if ($duration -gt 0) {
		$messageAttributes.duration=$duration
	}

	Write-TeamCityServiceMessage 'testFinished' $messageAttributes
}
Set-Alias TeamCity-TestFinished Write-TeamCityTestFinished

function Write-TeamCityTestIgnored([string]$name, [string]$message='') {
	Write-TeamCityServiceMessage 'testIgnored' @{ name=$name; message=$message }
}
Set-Alias TeamCity-TestIgnored Write-TeamCityTestIgnored

function Write-TeamCityTestOutput([string]$name, [string]$output) {
	Write-TeamCityServiceMessage 'testStdOut' @{ name=$name; out=$output }
}
Set-Alias TeamCity-TestOutput Write-TeamCityTestOutput

function Write-TeamCityTestError([string]$name, [string]$output) {
	Write-TeamCityServiceMessage 'testStdErr' @{ name=$name; out=$output }
}
Set-Alias TeamCity-TestError Write-TeamCityTestError

function Write-TeamCityTestFailed([string]$name, [string]$message, [string]$details='', [string]$type='', [string]$expected='', [string]$actual='') {
	$messageAttributes = @{ name=$name; message=$message; details=$details }

	if (![string]::IsNullOrEmpty($type)) {
		$messageAttributes.type = $type
	}

	if (![string]::IsNullOrEmpty($expected)) {
		$messageAttributes.expected=$expected
	}
	if (![string]::IsNullOrEmpty($actual)) {
		$messageAttributes.actual=$actual
	}

	Write-TeamCityServiceMessage 'testFailed' $messageAttributes
}
Set-Alias TeamCity-TestFailed Write-TeamCityTestFailed

# See http://confluence.jetbrains.net/display/TCD5/Manually+Configuring+Reporting+Coverage
function Write-TeamCityConfigureDotNetCoverage([string]$key, [string]$value) {
    Write-TeamCityServiceMessage 'dotNetCoverage' @{ $key=$value }
}
Set-Alias TeamCity-ConfigureDotNetCoverage Write-TeamCityConfigureDotNetCoverage

function Write-TeamCityImportDotNetCoverageResult([string]$tool, [Parameter(ValueFromPipeline)][string]$path) {
	process {
		Write-TeamCityServiceMessage 'importData' @{ type='dotNetCoverage'; tool=$tool; path=$path }
	}
}
Set-Alias TeamCity-ImportDotNetCoverageResult Write-TeamCityImportDotNetCoverageResult

# See http://confluence.jetbrains.net/display/TCD5/FxCop_#FxCop_-UsingServiceMessages
function Write-TeamCityImportFxCopResult([Parameter(ValueFromPipeline)][string]$path) {
	process {
		Write-TeamCityServiceMessage 'importData' @{ type='FxCop'; path=$path }
	}
}
Set-Alias TeamCity-ImportFxCopResult Write-TeamCityImportFxCopResult

function Write-TeamCityImportDuplicatesResult([Parameter(ValueFromPipeline)][string]$path) {
	process {
		Write-TeamCityServiceMessage 'importData' @{ type='DotNetDupFinder'; path=$path }
	}
}
Set-Alias TeamCity-ImportDuplicatesResult Write-TeamCityImportDuplicatesResult

function Write-TeamCityImportInspectionCodeResult([Parameter(ValueFromPipeline)][string]$path) {
	process {
		Write-TeamCityServiceMessage 'importData' @{ type='ReSharperInspectCode'; path=$path }
	}
}
Set-Alias TeamCity-ImportInspectionCodeResult Write-TeamCityImportInspectionCodeResult

function Write-TeamCityImportNUnitReport([Parameter(ValueFromPipeline)][string]$path) {
	process {
		Write-TeamCityServiceMessage 'importData' @{ type='nunit'; path=$path }
	}
}
Set-Alias TeamCity-ImportNUnitReport Write-TeamCityImportNUnitReport

function Write-TeamCityImportJSLintReport([Parameter(ValueFromPipeline)][string]$path) {
	process {
		Write-TeamCityServiceMessage 'importData' @{ type='jslint'; path=$path }
	}
}
Set-Alias TeamCity-ImportJSLintReport Write-TeamCityImportJSLintReport

function Write-TeamCityPublishArtifact([Parameter(ValueFromPipeline)][string]$path) {
	process {
		Write-TeamCityServiceMessage 'publishArtifacts' $path
	}
}
Set-Alias TeamCity-PublishArtifact Write-TeamCityPublishArtifact

function Write-TeamCityBuildStart([string]$message) {
	Write-TeamCityServiceMessage 'progressStart' $message
}
Set-Alias TeamCity-ReportBuildStart Write-TeamCityBuildStart

function Write-TeamCityBuildProgress([string]$message) {
	Write-TeamCityServiceMessage 'progressMessage' $message
}
Set-Alias TeamCity-ReportBuildProgress Write-TeamCityBuildProgress

function Write-TeamCityBuildFinish([string]$message) {
	Write-TeamCityServiceMessage 'progressFinish' $message
}
Set-Alias TeamCity-ReportBuildFinish Write-TeamCityBuildFinish

function Write-TeamCityBuildStatus([string]$status, [string]$text='') {
	Write-TeamCityServiceMessage 'buildStatus' @{ status=$status; text=$text }
}
Set-Alias TeamCity-ReportBuildStatus Write-TeamCityBuildStatus

function Write-TeamCityBuildNumber([string]$buildNumber) {
	Write-TeamCityServiceMessage 'buildNumber' $buildNumber
}
Set-Alias TeamCity-SetBuildNumber Write-TeamCityBuildNumber

function Write-TeamCityBuildStatistic([string]$key, [string]$value) {
	Write-TeamCityServiceMessage 'buildStatisticValue' @{ key=$key; value=$value }
}
Set-Alias TeamCity-SetBuildStatistic Write-TeamCityBuildStatistic

function New-TeamCityInfoDocument([string]$buildNumber='', [boolean]$status=$true, [string[]]$statusText=$null, [System.Collections.IDictionary]$statistics=$null) {
	$doc=New-Object xml;
	$buildEl=$doc.CreateElement('build');

	if (![string]::IsNullOrEmpty($buildNumber)) {
		$buildEl.SetAttribute('number', $buildNumber);
	}

	$buildEl=$doc.AppendChild($buildEl);

	$statusEl=$doc.CreateElement('statusInfo');
	if ($status) {
		$statusEl.SetAttribute('status', 'SUCCESS');
	} else {
		$statusEl.SetAttribute('status', 'FAILURE');
	}

	if ($statusText -ne $null) {
		foreach ($text in $statusText) {
			$textEl=$doc.CreateElement('text');
			$textEl.SetAttribute('action', 'append');
			$textEl.set_InnerText($text);
			$textEl=$statusEl.AppendChild($textEl);
		}
	}

	$statusEl=$buildEl.AppendChild($statusEl);

	if ($statistics -ne $null) {
		foreach ($key in $statistics.Keys) {
			$val=$statistics.$key
			if ($val -eq $null) {
				$val=''
			}

			$statEl=$doc.CreateElement('statisticsValue');
			$statEl.SetAttribute('key', $key);
			$statEl.SetAttribute('value', $val.ToString());
			$statEl=$buildEl.AppendChild($statEl);
		}
	}

	return $doc;
}
Set-Alias TeamCity-CreateInfoDocument New-TeamCityInfoDocument

function Save-TeamCityInfoDocument([xml]$doc) {
	$dir=(Split-Path $buildFile)
	$path=(Join-Path $dir 'teamcity-info.xml')

	$doc.Save($path);
}
Set-Alias TeamCity-WriteInfoDocument Save-TeamCityInfoDocument

function Write-TeamCityServiceMessage([string]$messageName, $messageAttributesHashOrSingleValue) {
	function escape([string]$value) {
		([char[]] $value |
				%{ switch ($_)
						{
								"|" { "||" }
								"'" { "|'" }
								"`n" { "|n" }
								"`r" { "|r" }
								"[" { "|[" }
								"]" { "|]" }
								([char] 0x0085) { "|x" }
								([char] 0x2028) { "|l" }
								([char] 0x2029) { "|p" }
								default { $_ }
						}
				} ) -join ''
		}

	if ($messageAttributesHashOrSingleValue -is [hashtable]) {
		$messageAttributesString = ($messageAttributesHashOrSingleValue.GetEnumerator() |
			%{ "{0}='{1}'" -f $_.Key, (escape $_.Value) }) -join ' '
	} else {
		$messageAttributesString = ("'{0}'" -f (escape $messageAttributesHashOrSingleValue))
	}

	Write-Host "##teamcity[$messageName $messageAttributesString]" -Fore Magenta
}
Set-Alias TeamCity-WriteServiceMessage Write-TeamCityServiceMessage

Export-ModuleMember -Function * -Alias *
