# .env.local 파일을 읽어 환경변수로 설정한 뒤 Supabase MCP 서버를 실행합니다.
$envFile = Join-Path (Split-Path $PSScriptRoot) ".env.local"

if (Test-Path $envFile) {
    Get-Content $envFile | Where-Object { $_ -notmatch '^\s*#' -and $_ -match '=' } | ForEach-Object {
        $parts = $_ -split '=', 2
        if ($parts.Count -eq 2 -and $parts[1].Trim() -ne '') {
            [System.Environment]::SetEnvironmentVariable($parts[0].Trim(), $parts[1].Trim(), 'Process')
        }
    }
} else {
    Write-Error ".env.local 파일을 찾을 수 없습니다: $envFile"
    exit 1
}

if (-not $env:SUPABASE_PROJECT_REF) {
    Write-Error "SUPABASE_PROJECT_REF 값이 .env.local에 없습니다."
    exit 1
}

if (-not $env:SUPABASE_ACCESS_TOKEN) {
    Write-Error "SUPABASE_ACCESS_TOKEN 값이 .env.local에 없습니다."
    exit 1
}

npx -y @supabase/mcp-server-supabase@latest --project-ref $env:SUPABASE_PROJECT_REF
