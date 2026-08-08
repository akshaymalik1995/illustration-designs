param([string]$StyleId, [string]$Source, [string[]]$Urls)
$out = "D:\Code\illustration-designs\references\$StyleId"
New-Item -ItemType Directory -Force $out | Out-Null
$i = 1
foreach ($u in $Urls) {
  $ext = if ($u -match '\.png($|\?)') { 'png' } else { 'jpg' }
  try {
    Invoke-WebRequest -UseBasicParsing $u -OutFile ("$out\{0:D2}.$ext" -f $i) -TimeoutSec 30
    $i++
  } catch { Write-Output "failed: $u" }
}
"source: $Source" | Out-File "$out\SOURCE.txt" -Encoding utf8
"$StyleId : downloaded $($i-1)"
