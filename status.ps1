# Fly.io アプリケーション状況確認スクリプト (PowerShell)

param(
    [switch]$Logs = $false,    # ログも表示
    [switch]$Watch = $false    # ログをリアルタイム監視
)

Write-Host "📊 Fly.io アプリケーションの状況を確認します..." -ForegroundColor Blue

try {
    # 基本ステータス
    Write-Host "`n=== アプリケーションステータス ===" -ForegroundColor Green
    flyctl status
    
    # アプリケーション情報
    Write-Host "`n=== アプリケーション情報 ===" -ForegroundColor Green
    flyctl info
    
    # ログ表示（オプション）
    if ($Logs) {
        Write-Host "`n=== 最新ログ ===" -ForegroundColor Yellow
        flyctl logs --lines 50
    }
    
    # リアルタイムログ監視（オプション）
    if ($Watch) {
        Write-Host "`n📋 リアルタイムログ監視を開始します（Ctrl+C で終了）:" -ForegroundColor Yellow
        flyctl logs
    }
    
    # 便利なコマンド表示
    Write-Host "`n=== 便利なコマンド ===" -ForegroundColor Cyan
    Write-Host "起動: .\start.ps1" -ForegroundColor White
    Write-Host "停止: .\stop.ps1" -ForegroundColor White
    Write-Host "ログ: .\status.ps1 -Logs" -ForegroundColor White
    Write-Host "ログ監視: .\status.ps1 -Watch" -ForegroundColor White
    Write-Host "アプリを開く: flyctl open" -ForegroundColor White
    
} catch {
    Write-Host "❌ エラーが発生しました: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}