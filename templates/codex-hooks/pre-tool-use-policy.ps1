# Блокирует четыре категории команд из методологии starter-шаблона.
# Получает JSON события PreToolUse от Codex через stdin.

$payloadText = [Console]::In.ReadToEnd()

try {
    $payload = $payloadText | ConvertFrom-Json -ErrorAction Stop
} catch {
    exit 0
}

function Deny-ToolUse {
    param([string]$Reason)

    @{
        hookSpecificOutput = @{
            hookEventName          = "PreToolUse"
            permissionDecision     = "deny"
            permissionDecisionReason = $Reason
        }
    } | ConvertTo-Json -Compress

    exit 0
}

$toolName = [string]$payload.tool_name
$command = if ($null -ne $payload.tool_input -and $null -ne $payload.tool_input.command) {
    [string]$payload.tool_input.command
} else {
    ""
}

if ($toolName -eq "Bash") {
    if ($command -match '(^|[^A-Za-z0-9_])rm\s+-[A-Za-z-]*r[A-Za-z-]*f(\s|$)') {
        Deny-ToolUse "Команда rm -rf заблокирована политикой проекта. Используй безопасную альтернативу и запроси явное подтверждение пользователя."
    }

    if ($command -match 'export\s+[^;&]*(&&|;)\s*curl(\s|$)') {
        Deny-ToolUse "Связка export + curl заблокирована политикой проекта: она может отправить переменные окружения наружу."
    }

    if ($command -match 'wget[^\r\n]*\$[A-Za-z_{]') {
        Deny-ToolUse "wget с подставленной переменной окружения заблокирован политикой проекта."
    }

    if ($command -match 'chmod\s+777(\s|$)') {
        Deny-ToolUse "chmod 777 заблокирован политикой проекта. Используй минимально необходимые права доступа."
    }
}

if ($toolName -in @("Read", "read_file", "mcp__filesystem__read_file", "mcp__filesystem__read_text_file")) {
    $toolInputJson = $payload.tool_input | ConvertTo-Json -Compress -Depth 20
    if ($toolInputJson -match '"(file_path|path)"\s*:\s*"([^"\\]*/)?\.env(\.local)?"') {
        Deny-ToolUse "Прямое чтение .env заблокировано политикой проекта. Запрашивай только конкретную переменную через grep."
    }
}

exit 0
