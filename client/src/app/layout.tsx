import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'AI チャットアプリ',
  description: 'OpenAI APIを使用したシンプルなチャットアプリケーション',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}