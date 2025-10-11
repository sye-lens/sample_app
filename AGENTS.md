# Repository Guidelines

## AGENTS.mdの影響範囲
- Codex CLIのAGENTS.mdの影響範囲はそれが存在するプロジェクト内のみにとどめてください

## 使用言語
- ユーザーとの対話は日本語で対応してください

## Project Structure & Module Organization
- `app/` hosts the Rails MVC layers; pair controllers with views, keep helpers small and reusable.
- `app/javascript/` contains ES modules loaded via `application.js`; place custom Stimulus controllers under `custom/`.
- Assets build from `app/assets/stylesheets` into `app/assets/builds`; keep compiled output out of version control.
- Tests live in `test/`, mirroring the `app/` tree; fixtures support fast model coverage.

## Build, Test, and Development Commands
- `bin/dev` boots the Rails server and CSS watcher defined in `Procfile.dev` for local hacking.
- `bin/rails test` runs the full Minitest suite; pass `TEST=...` to target a single file.
- `bin/rails db:migrate` applies pending migrations; run before test or server commands after schema changes.
- `yarn build:css` compiles Sass to `app/assets/builds/application.css`; add `--watch` during manual CSS work.

## Coding Style & Naming Conventions
- Ruby files use two-space indentation, snake_case methods, and CamelCase classes; keep controllers thin.
- Prefer plain ERB in `app/views/`; partials start with `_` and live alongside their consumers.
- JavaScript modules remain ES6, export defaults sparingly, and name controllers with the `*_controller.js` pattern.
- Follow default Rails i18n and config structure; introduce new initializers under `config/initializers`.

## Testing Guidelines
- Stick with Minitest in `test/`; new tests should mirror `app/` namespaces and use descriptive method names.
- Favor fixtures already under `test/fixtures`; add factories only if the fixture model grows unwieldy.
- Aim for high-traffic controller and model coverage before merging; measure with `bin/rails test`.

## Commit & Pull Request Guidelines
- Write imperative, descriptive commit subjects (e.g., `Add bootstrap navbar`) and keep bodies wrapped at 72 chars.
- Reference related issues with `Refs #ID` in commit bodies when applicable.
- Pull requests need a short summary, testing notes, and screenshots for UI changes; link issues in the description.
- Ensure CI passes before requesting review; rebase on `main` to avoid merge commits.
