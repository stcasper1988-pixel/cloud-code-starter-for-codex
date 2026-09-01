#!/usr/bin/env bash
# Блокирует четыре категории команд из методологии starter-шаблона.
# Получает JSON события PreToolUse от Codex через stdin.

set -eu

payload=$(cat)

is_tool() {
  local tool_name="$1"
  printf '%s' "$payload" | grep -Eq "\"tool_name\"[[:space:]]*:[[:space:]]*\"${tool_name}\""
}

deny() {
  local reason="$1"
  printf '%s\n' "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":\"${reason}\"}}"
  exit 0
}

if is_tool "Bash"; then
  if printf '%s' "$payload" | grep -Eq '(^|[^[:alnum:]_])rm[[:space:]]+-[[:alnum:]-]*r[[:alnum:]-]*f([[:space:]]|$)'; then
    deny "Команда rm -rf заблокирована политикой проекта. Используй безопасную альтернативу и запроси явное подтверждение пользователя."
  fi

  if printf '%s' "$payload" | grep -Eq 'export[[:space:]][^;&]*(&&|;)[[:space:]]*curl([[:space:]]|$)'; then
    deny "Связка export + curl заблокирована политикой проекта: она может отправить переменные окружения наружу."
  fi

  if printf '%s' "$payload" | grep -Eq 'wget[^\n]*\$[A-Za-z_{]'; then
    deny "wget с подставленной переменной окружения заблокирован политикой проекта."
  fi

  if printf '%s' "$payload" | grep -Eq 'chmod[[:space:]]+777([[:space:]]|$)'; then
    deny "chmod 777 заблокирован политикой проекта. Используй минимально необходимые права доступа."
  fi
fi

if is_tool "Read" || is_tool "read_file" || is_tool "mcp__filesystem__read_file" || is_tool "mcp__filesystem__read_text_file"; then
  if printf '%s' "$payload" | grep -Eq '"(file_path|path)"[[:space:]]*:[[:space:]]*"([^"\\]*/)?\.env(\.local)?"'; then
    deny "Прямое чтение .env заблокировано политикой проекта. Запрашивай только конкретную переменную через grep."
  fi
fi

exit 0
