# Fly.io アプリケーション停止スクリプト (PowerShell)

Write-Host "🛑 Fly.io アプリケーションを停止します..." -ForegroundColor Red

try {
    # 現在のステータス確認
    Write-Host "📊 停止前のステータス:" -ForegroundColor Blue
    flyctl status
    
    # マシン数を0に設定
    Write-Host "`n📉 マシン数を0に設定中..." -ForegroundColor Yellow
    $scaleResult = flyctl scale count 0 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ スケーリング完了" -ForegroundColor Green
    } else {
        Write-Host "❌ スケーリング失敗: $scaleResult" -ForegroundColor Red
        exit 1
    }
    
    # 停止後のステータス確認
    Write-Host "`n📊 停止後のステータス:" -ForegroundColor Blue
    flyctl status
    
    Write-Host "`n✅ アプリケーションが停止しました" -ForegroundColor Green
    Write-Host "💰 課金が停止されました（マシン数: 0）" -ForegroundColor Green
    Write-Host "🚀 再起動するには: .\start.ps1 または flyctl scale count 1" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ エラーが発生しました: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}