# Адаптация для Codex

Этот репозиторий - техническая адаптация [Claude Code Starter](https://github.com/artemiimillier/claude-code-starter) Артемии Миллер / Школы Смысло-кодинга для Codex.

- **Источник:** `artemiimillier/claude-code-starter`
- **Исходная версия:** `v1.0.3`, commit `c8d1105ec17cbf3d435a4c1561e99ed1e920128f`
- **Лицензия источника:** MIT; исходный copyright и текст лицензии сохранены в [`LICENSE`](./LICENSE).

## Что сохранено без изменения

- 10-шаговый `AUTOPILOT` с паузой после шага 7 и возобновлением через `last_completed_step`;
- `.business/` как второй мозг проекта, включая коммерческую и некоммерческую ветки;
- Reality Check после блока products;
- обязательный цикл «план → реализация → ретроспектива»;
- библиотека промптов, структура `plans/`, `retrospectives/`, `prompts/` и все авторские методологические правила;
- модель безопасности: звуковые уведомления, четыре категории опасных операций, аудит skills/MCP и pre-commit защита.

## Технические соответствия

| В исходнике Claude Code | В этой адаптации Codex |
|---|---|
| `CLAUDE.md` | `AGENTS.md` |
| `templates/CLAUDE.md.tmpl` | `templates/AGENTS.md.tmpl` |
| `.claude/settings.json` | `.codex/hooks.json` |
| `permissions.deny` | hook `PreToolUse` в `.codex/hooks.json` и локальные policy scripts |
| hook `Notification` | hook `PermissionRequest` |
| `.claude/skills/` | `.agents/skills/` |
| `~/.claude/skills/` | `~/.agents/skills/` |
| `.mcp.json` / настройки Claude Code | `.codex/config.toml` |
| Bypass Permissions | `--dangerously-bypass-approvals-and-sandbox` / режим полного доступа Codex |

## Важное ограничение Codex

Project-local hooks в `.codex/hooks.json` запускаются только в доверенном проекте и после явного review/trust через `/hooks`. Поэтому AUTOPILOT создаёт hooks после согласия пользователя и просит проверить их перед использованием. Это техническое требование Codex, а не дополнительный шаг методологии.

## Официальные источники Codex

- [AGENTS.md](https://developers.openai.com/codex/guides/agents-md)
- [Hooks](https://developers.openai.com/codex/hooks)
- [Skills](https://developers.openai.com/codex/skills)
- [Project configuration](https://developers.openai.com/codex/config-advanced)
- [MCP](https://developers.openai.com/codex/mcp)
