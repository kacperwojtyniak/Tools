#Git Remote branches prune
Write-host "prune remote branches..."
git remote prune origin

#Git local branches prune
Write-Host "Prune local branches.."
git branch -vv | %{$_.trim()} | ? {$_-match ': gone'} | foreach {$_.split('')[0]} | % {git branch -D $_}
