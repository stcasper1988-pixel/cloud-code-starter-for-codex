# Cloud Code Starter for Codex

[![Version](https://img.shields.io/github/v/release/stcasper1988-pixel/cloud-code-starter-for-codex?include_prereleases&label=version)](https://github.com/stcasper1988-pixel/cloud-code-starter-for-codex/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![Security Audit](https://github.com/stcasper1988-pixel/cloud-code-starter-for-codex/actions/workflows/security-audit.yml/badge.svg)](https://github.com/stcasper1988-pixel/cloud-code-starter-for-codex/actions)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](./CONTRIBUTING.md)

Техническая адаптация Claude Code Starter для любого проекта с Codex. Клонируй → открой в VS Code → напиши одну фразу → через 90-120 минут у тебя настроенная среда: заполненный бизнес-контекст, правила работы с агентом, библиотека готовых промптов, первый план и ретроспектива.

> 👀 **Хочешь увидеть что получится?** Открой пример заполненного проекта — [examples/coffeeshop/](./examples/coffeeshop/). Это вымышленная сеть кофеен с полностью заполненной `.business/`, реальным планом (подписка на напитки) и одной ретроспективой. По нему видно что у тебя окажется через 90-120 минут после клонирования.

> ⚖️ Это именно адаптация интерфейсов Claude Code для Codex: методология автора сохранена. Полная карта замен - в [ADAPTATION.md](./ADAPTATION.md).

## TL;DR

1. Клонируй → открой в VS Code → открой Codex → напиши «привет»
2. Codex сам проведёт тебя через 10 шагов онбординга (~90-120 мин)
3. Получишь настроенную среду под твой проект + 16 готовых промптов

---

## Что ты получаешь после онбординга

- 📁 **Папка `.business/`** - второй мозг проекта, заполненный по твоим ответам на интервью (7 блоков: company, products, audience, goals, economics, marketing, assets)
- 📋 **`AGENTS.md`** - правила работы с агентом под твой стек и тип проекта
- 🗂 **`plans/`** и **`retrospectives/`** с готовыми шаблонами и первыми рабочими примерами
- 🔒 **Безопасность:** звуковые хуки, 4 запрета опасных команд, правильный `.gitignore`
- 📚 **Библиотека промптов** - 16 готовых промптов под любые задачи (установка скилов, Playwright, деплой, критика плана, «10 причин обосраться»)

## Прежде чем начать

Убедись, что у тебя есть:

- [ ] **VS Code** установлен ([скачать](https://code.visualstudio.com))
- [ ] **Codex IDE extension** установлен в VS Code ([инструкция](https://developers.openai.com/codex/ide))
- [ ] **Доступ к Codex** настроен: вход через ChatGPT или API key ([инструкция](https://developers.openai.com/codex/auth))
- [ ] **Авторизация в Codex** пройдена

Если какой-то пункт не получается - открой [TROUBLESHOOTING.md](TROUBLESHOOTING.md), там решения на все типовые проблемы.

## Как запустить

**Вариант A - через кнопку GitHub:**

1. Нажми **«Use this template»** вверху этой страницы
2. Дай имя своему проекту (например, `moy-magazin-obuvi`)
3. Склонируй к себе: `git clone https://github.com/твой-логин/moy-magazin-obuvi`

**Вариант B - через терминал:**

```bash
git clone https://github.com/stcasper1988-pixel/cloud-code-starter-for-codex moy-proekt
cd moy-proekt
rm -rf .git && git init
```

## Что делать дальше

1. Открой папку в **VS Code**
2. Открой **Codex** (иконка в левой панели)
3. Напиши любую фразу - `привет`, `начинаем`, `проведи меня`
4. Codex сам начнёт онбординг и проведёт тебя через 10 шагов

**Длительность:** 90-120 минут. Можно разбить на 2 сессии (технические настройки + интервью про бизнес) - Codex сам предложит паузу.

## Структура репо

```
cloud-code-starter-for-codex/
├── README.md              ← ты сейчас здесь
├── AGENTS.md              ← правила работы с Codex
├── AUTOPILOT.md           ← сценарий первого запуска (удалится после онбординга)
├── TROUBLESHOOTING.md     ← решения типовых проблем
├── CONTRIBUTING.md        ← если хочешь предложить правку в шаблон
├── CHANGELOG.md           ← история версий
├── LICENSE                ← MIT
├── .vscode/settings.json  ← настройки VS Code (видимость .business/ и др.)
├── .github/
│   ├── workflows/         ← CI: security-audit при push
│   └── hooks/             ← pre-commit hook против утечки секретов (sample)
├── scripts/               ← локальный security-audit.sh
├── .business/             ← скрытая папка: бизнес-контекст твоего проекта
├── plans/                 ← технические планы реализации
├── retrospectives/        ← рефлексии после каждой сессии
├── prompts/               ← библиотека готовых промптов
│   ├── INDEX.md           ← оглавление: «если надо X - возьми Y»
│   ├── setup/             ← настройка: hooks, security, скиллы, Playwright
│   ├── launch/            ← запуск: GitHub, деплой, платежи
│   └── methodology/       ← методология: критика плана, планирование недели
└── templates/             ← шаблоны для генерации файлов
```

## Что этот шаблон НЕ делает

- Не устанавливает VS Code, Codex, Node.js (это до клонирования)
- Не оплачивает подписку или API-использование Codex
- Не настраивает доступ к аккаунту или API key (решай сам)
- Не отвечает за тебя в интервью про бизнес - **вся ценность в твоих ответах**

## Безопасность

- `.env` в `.gitignore` из коробки - секреты не попадут в публичный репозиторий
- `.business/` в исходном шаблоне содержит плейсхолдеры и tracked в git намеренно. Codex добавит `.business/` в `.gitignore` и снимет с tracking автоматически на последнем шаге онбординга (10a). До этого шага не делай `git commit` вручную, иначе промежуточные данные окажутся в истории
- Codex настраивает 4 запрета опасных команд (`rm -rf`, `curl+export`, `.env`, `wget`) в `.codex/hooks.json`
- Режим полного доступа (`--dangerously-bypass-approvals-and-sandbox`) не включается автоматически - включаешь сам, когда почувствуешь уверенность

**Рекомендуем** включить pre-commit hook для защиты от случайной утечки секретов:

```bash
cp .github/hooks/pre-commit.sample .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

После этого каждая попытка `git commit` будет проверять staged файлы на API-ключи, `.env`, приватные ключи. Если найдёт - заблокирует коммит.

## Обновления шаблона

Когда выйдет новая версия - загляни в [CHANGELOG.md](CHANGELOG.md) исходного репо и скопируй к себе то, что полезно.

**Что можно безопасно обновлять:**
- `prompts/` - новые готовые промпты под задачи
- `TROUBLESHOOTING.md` - новые решения типовых проблем
- `scripts/security-audit.sh` - обновлённые проверки
- `.github/hooks/pre-commit.sample` - улучшения защиты

**Что НЕ трогать при обновлении:**
- `.business/` - там твои данные, не перезаписывай
- `AGENTS.md` - он уже под твой проект, не откатывай
- `plans/`, `retrospectives/` - твоя история работы
- `AUTOPILOT.md` - с флагом `completed: true` не нужен больше

Способ обновления - просто скачай нужные файлы вручную. Автоматический `npx`-апдейтер появится в v1.1.0+.

## FAQ

### Почему этот шаблон, а не пустой AGENTS.md?

Пустой `AGENTS.md` — это «напиши туда правила сам». Ты не знаешь что туда писать, пока не набил шишки. Этот шаблон — **выжимка методологии после 3 потоков практикума**: `.business/` как второй мозг, `plans/` с критикой через субагентов, `retrospectives/` для памяти между сессиями, 16 готовых промптов под типовые задачи. Ты получаешь результат которого иначе достигнешь через 3-4 месяца работы.

### Это бесплатно?

Шаблон — **полностью бесплатно** (MIT). Доступ к Codex через ChatGPT или API оплачивается отдельно по правилам OpenAI. Платный практикум Школы Смысло-кодинга — опционально, для тех кому нужна методология на 2-3 уровне и обратная связь.

### У меня уже есть проект — как его интегрировать?

Используй промпт [`prompts/methodology/import-existing-project.md`](./prompts/methodology/import-existing-project.md) — Codex прочитает твой код, структуру папок, README и сам заполнит `.business/` на основе того что найдёт. Вопросов задаст 5-7 чтобы закрыть пробелы.

### Я не из России. Часть документации русская. Это проблема?

Сейчас шаблон только на русском. Английская версия — в [roadmap](./CHANGELOG.md) v2.0.0. Пока что — всё работает, просто тебе нужно знать русский или готов использовать Google Translate на файлы-подсказки. Промпты внутри ты пишешь на том языке который выберешь на шаге 8 онбординга.

### Сколько стоит Codex?

Стоимость зависит от выбранного способа входа: ChatGPT-подписка или API key. Шаблон не меняет расход Codex: главный фактор - интенсивность разработки, а не сама методология. Перед стартом проверь актуальные условия в [официальной документации по авторизации](https://developers.openai.com/codex/auth).

### Что если я закрою ноут посреди онбординга?

Без паники. AUTOPILOT ведёт файл прогресса. Откроешь проект через день → напишешь любую фразу → Codex скажет «вижу мы остановились на шаге N, продолжаем?». Сценарий протестирован.

### Что если AUTOPILOT ошибётся или задаст странный вопрос?

Напиши Issue через [репозиторий](https://github.com/stcasper1988-pixel/cloud-code-starter-for-codex/issues) — шаблон «bug-report» попросит нужные детали. Или запусти более узкий промпт вручную: вместо AUTOPILOT целиком — промпты из [`prompts/setup/`](./prompts/setup/) по отдельности.

### Это работает только с Codex?

Рассчитан на **VS Code + Codex**. Частично работает в других агентных IDE: структура `.business/`, `plans/`, `retrospectives/` универсальна, промпты тоже. AUTOPILOT использует `AGENTS.md`, `.codex/` и `.agents/skills/`; в другой среде эти механизмы могут не загрузиться. Для Claude Code используй [оригинальный репозиторий](https://github.com/artemiimillier/claude-code-starter).

### Могу ли я использовать шаблон для коммерческого проекта?

Да. Лицензия MIT. Используй как хочешь, включая закрытый коммерческий софт. Атрибуция в footer README желательна, но не требуется юридически.

### Куда писать если не работает что-то не из этого списка?

- Bug → [Issues](https://github.com/stcasper1988-pixel/cloud-code-starter-for-codex/issues) с шаблоном «🐛 Bug report»
- Идея → [Issues](https://github.com/stcasper1988-pixel/cloud-code-starter-for-codex/issues) с шаблоном «💡 Feature request»
- Вопрос → [Issues](https://github.com/stcasper1988-pixel/cloud-code-starter-for-codex/issues) с шаблоном «❓ Question»
- Утечка данных / safety → [Security Advisory](https://github.com/stcasper1988-pixel/cloud-code-starter-for-codex/security/advisories/new) приватно

## Лицензия

MIT. Используй как хочешь, включая коммерческие проекты.

---

<sub>Методология разработана в [Школе Смысло-кодинга](https://smyslokod.ru). Адаптация интерфейсов для Codex - [Cloud Code Starter for Codex](./ADAPTATION.md).</sub>
