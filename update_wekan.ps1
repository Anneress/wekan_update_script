$downloadPath = "c:\wekan_versions\"
$extractPath ="c:\"
$uriOfUpdateServer = "https://releases.wekan.team/"

$webResponseObj = Invoke-WebRequest -Uri $uriOfUpdateServer
$zipFileName = $webResponseObj.Links.Href | Where-Object {$_ -like "*.zip"}
$zipFileName = $zipFileName -replace "./", ""
$zipFileName = $zipFileName -replace " ", ""

if (-Not (Test-Path "$($downloadPath)$($zipFileName)" -PathType leaf))
{
	Invoke-WebRequest -Uri "$($uriOfUpdateServer)$($zipFileName)" -Outfile "$($downloadPath)$($zipFileName)"
	
	stop-process -name node
	 
	Expand-Archive "$($downloadPath)$($zipFileName)" $extractPath -Force
	  
	$p = start-process "c:\bundle\start-wekan.bat" -PassThru -RedirectStandardOutput "c:\bundle\log.txt" -WindowStyle hidden
}
else
{
	write-out "no update available."
}	