# Блокирует четыре категории команд из методологии starter-шаблона.
# Получает JSON события PreToolUse от Codex через stdin.

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

$payloadText = [Console]::In.ReadToEnd()

try {
    $payload = $payloadText | ConvertFrom-Json -ErrorAction Stop
} catch {
    Deny-ToolUse "Не удалось безопасно разобрать JSON события. Вызов инструмента заблокирован политикой проекта."
}

if ($payload -isnot [System.Management.Automation.PSCustomObject]) {
    Deny-ToolUse "Некорректная структура JSON события. Вызов инструмента заблокирован политикой проекта."
}

if ($payload.tool_name -isnot [string] -or [string]::IsNullOrWhiteSpace([string]$payload.tool_name)) {
    Deny-ToolUse "В JSON события отсутствует корректное имя инструмента. Вызов заблокирован политикой проекта."
}

if ($payload.tool_input -isnot [System.Management.Automation.PSCustomObject]) {
    Deny-ToolUse "В JSON события отсутствует корректный tool_input. Вызов инструмента заблокирован политикой проекта."
}

$toolName = [string]$payload.tool_name
$toolInput = $payload.tool_input

if ($toolName -eq "Bash") {
    if ($toolInput.command -isnot [string]) {
        Deny-ToolUse "В JSON события Bash отсутствует корректная команда. Вызов заблокирован политикой проекта."
    }

    $command = [string]$toolInput.command

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

    $referencesEnvFile = $command -match '(?i)(^|[\\/\s"''])\.env(\.local)?([^A-Za-z0-9_.-]|$)'
    $isSafeEnvGrep = $command -match '(?i)^\s*grep\s+"\^[A-Za-z_][A-Za-z0-9_]*="\s+(\./)?\.env(\.local)?\s*$'
    if ($referencesEnvFile -and -not $isSafeEnvGrep) {
        Deny-ToolUse 'Обращение к .env через shell заблокировано политикой проекта. Запрашивай только конкретную переменную командой grep "^VAR_NAME=" .env.'
    }

    if ($command -match '(?i)\bRemove-Item\b(?=[^\r\n;&|]*-(Recurse|r)\b)(?=[^\r\n;&|]*-(Force|fo)\b)') {
        Deny-ToolUse "Массовое удаление через Remove-Item -Recurse -Force заблокировано политикой проекта. Используй безопасную альтернативу и запроси явное подтверждение пользователя."
    }
}

if ($toolName -match '(?i)^(Read|read_file|read_text_file|mcp__.+__read_(file|text_file))$') {
    $filePath = if ($toolInput.file_path -is [string] -and -not [string]::IsNullOrEmpty([string]$toolInput.file_path)) {
        [string]$toolInput.file_path
    } elseif ($toolInput.path -is [string] -and -not [string]::IsNullOrEmpty([string]$toolInput.path)) {
        [string]$toolInput.path
    } else {
        Deny-ToolUse "В JSON события чтения отсутствует корректный путь. Вызов заблокирован политикой проекта."
    }

    if ([System.IO.Path]::GetFileName($filePath) -match '^\.env(\.local)?$') {
        Deny-ToolUse "Прямое чтение .env заблокировано политикой проекта. Запрашивай только конкретную переменную через grep."
    }
}

exit 0
