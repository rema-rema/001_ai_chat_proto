# Fly.io deploy script (PowerShell)

param(
    [switch]$SkipBuild = $false,
    [switch]$NoOpen = $false
)

Write-Host "Deploy starting..." -ForegroundColor Green

try {
    # Git status check
    Write-Host "Git status check..." -ForegroundColor Yellow
    $gitStatus = git status --porcelain
    if ($gitStatus) {
        Write-Host "Uncommitted changes found:" -ForegroundColor Yellow
        git status --short
        $commitChoice = Read-Host "`nContinue deploy? (y/n)"
        if ($commitChoice -ne 'y' -and $commitChoice -ne 'Y') {
            Write-Host "Deploy cancelled" -ForegroundColor Yellow
            exit 0
        }
    }
    
    # Deploy execution
    Write-Host "`nDeploying..." -ForegroundColor Blue
    $deployArgs = @()
    if ($SkipBuild) {
        $deployArgs += "--no-build"
    }
    
    $deployResult = flyctl deploy @deployArgs 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Deploy completed" -ForegroundColor Green
        
        # Status check
        Write-Host "`nPost-deploy status:" -ForegroundColor Blue
        flyctl status
        
        # Open application
        if (-not $NoOpen) {
            $openChoice = Read-Host "`nOpen application? (y/n)"
            if ($openChoice -eq 'y' -or $openChoice -eq 'Y') {
                Write-Host "Opening application..." -ForegroundColor Cyan
                flyctl open
            }
        }
        
        Write-Host "`nDeploy successful!" -ForegroundColor Green
        
    } else {
        Write-Host "Deploy failed: $deployResult" -ForegroundColor Red
        Write-Host "`nCheck logs:" -ForegroundColor Yellow
        Write-Host "flyctl logs" -ForegroundColor White
        exit 1
    }
    
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}