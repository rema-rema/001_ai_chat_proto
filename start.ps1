# Fly.io アプリケーション起動スクリプト (PowerShell)

param(
    [switch]$NoLogs = $false  # ログ監視をスキップ
)

Write-Host "🚀 Fly.io アプリケーションを起動します..." -ForegroundColor Green

try {
    # マシン数を1に設定
    Write-Host "📈 マシン数を1に設定中..." -ForegroundColor Yellow
    $scaleResult = flyctl scale count 1 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ スケーリング完了" -ForegroundColor Green
    } else {
        Write-Host "❌ スケーリング失敗: $scaleResult" -ForegroundColor Red
        exit 1
    }
    
    # ステータス確認
    Write-Host "`n📊 アプリケーションのステータス:" -ForegroundColor Blue
    flyctl status
    
    # アプリケーションURL表示
    Write-Host "`n🌐 アプリケーションを開くには:" -ForegroundColor Cyan
    Write-Host "flyctl open" -ForegroundColor White
    
    # ログ監視（オプション）
    if (-not $NoLogs) {
        $logChoice = Read-Host "`nログを監視しますか？ (y/n)"
        if ($logChoice -eq 'y' -or $logChoice -eq 'Y') {
            Write-Host "📋 ログ監視を開始します（Ctrl+C で終了）:" -ForegroundColor Yellow
            flyctl logs
        }
    }
    
    Write-Host "`n✅ アプリケーションが起動しました" -ForegroundColor Green
    
} catch {
    Write-Host "❌ エラーが発生しました: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}