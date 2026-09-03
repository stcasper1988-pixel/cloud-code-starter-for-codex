# templates/ - образцы файлов для генерации

Codex берёт файлы отсюда как образцы, когда создаёт конкретные файлы под проект пользователя.

## AGENTS.md.tmpl

Шаблон для генерации корневого `AGENTS.md` на шаге 9a AUTOPILOT. Содержит плейсхолдеры:
- `{{PROJECT_NAME}}` - имя проекта
- `{{PROJECT_ONE_LINER}}` - одно предложение о чём проект
- `{{STACK}}` - технический стек
- `{{LANGUAGE_RULE}}` - на каком языке Codex общаться с пользователем

Codex заполняет плейсхолдеры ответами из интервью и записывает в корень как `AGENTS.md`.

## codex-hooks-audio.json.example

Образец `.codex/hooks.json` после шага 4 AUTOPILOT. Содержит только звуковые hooks `Stop` и `PermissionRequest`; на этом шаге policy scripts ещё не устанавливаются.

## codex-hooks.json.example

Образец `.codex/hooks.json` после прохождения шагов 4 и 5 AUTOPILOT (hooks + 4 запрета безопасности).

Это итоговый пример формата hooks Codex. На шаге 5 Codex добавляет из него блок `PreToolUse` к уже существующим звуковым hooks, а соответствующий policy script из `templates/codex-hooks/` копирует в `.codex/hooks/`. Project-local hooks нужно отдельно проверить и доверить через `/hooks`.

Структура:
- `hooks.Stop` - звук при завершении задачи
- `hooks.PermissionRequest` - звук при запросе разрешения
- `hooks.PreToolUse` - запреты опасных команд до их запуска

Кросс-платформенная команда звука использует `afplay` (Mac) с fallback на PowerShell `console.beep` (Windows) и терминальный bell `\a`.
