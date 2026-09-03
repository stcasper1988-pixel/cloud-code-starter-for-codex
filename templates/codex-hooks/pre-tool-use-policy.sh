#!/usr/bin/env bash
# Блокирует четыре категории команд из методологии starter-шаблона.
# Получает JSON события PreToolUse от Codex через stdin.

set -eu

payload=$(cat)

is_read_tool() {
  printf '%s' "$tool_name" | grep -Eqi '^(Read|read_file|read_text_file|mcp__.+__read_(file|text_file))$'
}

select_json_parser() {
  if command -v jq >/dev/null 2>&1; then
    json_parser="jq"
    return 0
  fi

  if command -v python3 >/dev/null 2>&1; then
    json_parser="python3"
    return 0
  fi

  if command -v node >/dev/null 2>&1; then
    json_parser="node"
    return 0
  fi

  return 1
}

extract_tool_name() {
  case "$json_parser" in
    jq)
      printf '%s' "$payload" | jq -er 'select(type == "object") | .tool_name | select(type == "string" and length > 0)' 2>/dev/null
      ;;
    python3)
      printf '%s' "$payload" | python3 -c 'import json,sys; data=json.load(sys.stdin); isinstance(data, dict) or sys.exit(1); value=data.get("tool_name"); isinstance(value, str) and value or sys.exit(1); sys.stdout.write(value)' 2>/dev/null
      ;;
    node)
      printf '%s' "$payload" | node -e 'let data=""; process.stdin.setEncoding("utf8"); process.stdin.on("data", chunk => data += chunk); process.stdin.on("end", () => { try { const payload=JSON.parse(data); if (payload === null || Array.isArray(payload) || typeof payload !== "object") process.exit(1); const value=payload.tool_name; if (typeof value !== "string" || value.length === 0) process.exit(1); process.stdout.write(value); } catch { process.exit(1); } });' 2>/dev/null
      ;;
  esac
}

extract_command() {
  case "$json_parser" in
    jq)
      printf '%s' "$payload" | jq -er 'select(type == "object") | .tool_input | select(type == "object") | .command | select(type == "string")' 2>/dev/null
      ;;
    python3)
      printf '%s' "$payload" | python3 -c 'import json,sys; data=json.load(sys.stdin); isinstance(data, dict) or sys.exit(1); tool_input=data.get("tool_input"); isinstance(tool_input, dict) or sys.exit(1); value=tool_input.get("command"); isinstance(value, str) or sys.exit(1); sys.stdout.write(value)' 2>/dev/null
      ;;
    node)
      printf '%s' "$payload" | node -e 'let data=""; process.stdin.setEncoding("utf8"); process.stdin.on("data", chunk => data += chunk); process.stdin.on("end", () => { try { const payload=JSON.parse(data); if (payload === null || Array.isArray(payload) || typeof payload !== "object") process.exit(1); const toolInput=payload.tool_input; if (toolInput === null || Array.isArray(toolInput) || typeof toolInput !== "object") process.exit(1); const value=toolInput.command; if (typeof value !== "string") process.exit(1); process.stdout.write(value); } catch { process.exit(1); } });' 2>/dev/null
      ;;
  esac
}

extract_file_path() {
  case "$json_parser" in
    jq)
      printf '%s' "$payload" | jq -er 'select(type == "object") | .tool_input | select(type == "object") | (.file_path // .path) | select(type == "string" and length > 0)' 2>/dev/null
      ;;
    python3)
      printf '%s' "$payload" | python3 -c 'import json,sys; data=json.load(sys.stdin); isinstance(data, dict) or sys.exit(1); tool_input=data.get("tool_input"); isinstance(tool_input, dict) or sys.exit(1); value=tool_input.get("file_path"); value=tool_input.get("path") if value is None else value; isinstance(value, str) and value or sys.exit(1); sys.stdout.write(value)' 2>/dev/null
      ;;
    node)
      printf '%s' "$payload" | node -e 'let data=""; process.stdin.setEncoding("utf8"); process.stdin.on("data", chunk => data += chunk); process.stdin.on("end", () => { try { const payload=JSON.parse(data); if (payload === null || Array.isArray(payload) || typeof payload !== "object") process.exit(1); const toolInput=payload.tool_input; if (toolInput === null || Array.isArray(toolInput) || typeof toolInput !== "object") process.exit(1); const value=toolInput.file_path ?? toolInput.path; if (typeof value !== "string" || value.length === 0) process.exit(1); process.stdout.write(value); } catch { process.exit(1); } });' 2>/dev/null
      ;;
  esac
}

references_env_file() {
  local env_reference_pattern="(^|[/\\\\[:space:]\"'])\\.env(\\.local)?([^[:alnum:]_.-]|$)"
  printf '%s' "$command_text" | grep -Eq "$env_reference_pattern"
}

is_safe_env_grep() {
  printf '%s' "$command_text" | grep -Eq '^[[:space:]]*grep[[:space:]]+"\^[A-Za-z_][A-Za-z0-9_]*="[[:space:]]+(\./)?\.env(\.local)?[[:space:]]*$'
}

deny() {
  local reason="$1"
  printf '%s\n' "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"permissionDecisionReason\":\"${reason}\"}}"
  exit 0
}

json_parser=""
if ! select_json_parser; then
  deny "Не найден JSON parser для проверки события. Вызов инструмента заблокирован политикой проекта. Установи jq, python3 или node и повтори попытку."
fi

tool_name=""
if ! tool_name=$(extract_tool_name); then
  deny "Не удалось безопасно разобрать JSON события. Вызов инструмента заблокирован политикой проекта."
fi

if [ "$tool_name" = "Bash" ]; then
  command_text=""
  if ! command_text=$(extract_command); then
    deny "Не удалось безопасно разобрать JSON события Bash. Команда заблокирована политикой проекта. Установи jq, python3 или node и повтори попытку."
  fi

  if printf '%s' "$command_text" | grep -Eq '(^|[^[:alnum:]_])rm[[:space:]]+-[[:alnum:]-]*r[[:alnum:]-]*f([[:space:]]|$)'; then
    deny "Команда rm -rf заблокирована политикой проекта. Используй безопасную альтернативу и запроси явное подтверждение пользователя."
  fi

  if printf '%s' "$command_text" | grep -Eq 'export[[:space:]][^;&]*(&&|;)[[:space:]]*curl([[:space:]]|$)'; then
    deny "Связка export + curl заблокирована политикой проекта: она может отправить переменные окружения наружу."
  fi

  if printf '%s' "$command_text" | grep -Eq 'wget[^$]*\$[A-Za-z_{]'; then
    deny "wget с подставленной переменной окружения заблокирован политикой проекта."
  fi

  if printf '%s' "$command_text" | grep -Eq 'chmod[[:space:]]+777([[:space:]]|$)'; then
    deny "chmod 777 заблокирован политикой проекта. Используй минимально необходимые права доступа."
  fi

  if references_env_file && ! is_safe_env_grep; then
    deny "Обращение к .env через shell заблокировано политикой проекта. Запрашивай только конкретную переменную командой grep с шаблоном ^VAR_NAME= для файла .env."
  fi
fi

if is_read_tool; then
  file_path=""
  if ! file_path=$(extract_file_path); then
    deny "Не удалось безопасно разобрать путь из JSON события чтения. Вызов инструмента заблокирован политикой проекта."
  fi

  if printf '%s' "$file_path" | grep -Eq '(^|[/\\])\.env(\.local)?$'; then
    deny "Прямое чтение .env заблокировано политикой проекта. Запрашивай только конкретную переменную через grep."
  fi
fi

exit 0
