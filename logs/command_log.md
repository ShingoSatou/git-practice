# コマンド実行履歴

> 実行したGitコマンド・目的・結果を記録する台帳です。

---

## Step 0: 演習用リポジトリの準備

| # | コマンド | 目的 | 結果 |
|---|---------|------|------|
| 1 | `git init` | ローカルリポジトリの初期化 | ✅ 成功 |
| 2 | `git add -A` | 全ファイルをステージング | ✅ 成功 |
| 3 | `git commit -m "feat: ..."` | 初回コミット | ✅ `bda5174` |
| 4 | `gh repo create git-practice --private ...` | GitHubにprivateリポジトリ作成 & push | ✅ 成功 |
| 5 | `git add` → `git commit` → `git push` | AGENT.md, learning_log.md を追加 | ✅ `c898c8e` |

---

## Step 2: Worktree vs Branch【実践】

| # | コマンド | 目的 | 結果 |
|---|---------|------|------|
| 1 | `git worktree add ../git学習-feature -b feature/add-subtract` | 別フォルダにWorktreeとして新ブランチを展開 | ✅ 成功 |
| 2 | `git worktree list` | Worktree一覧を確認 | ✅ main + feature/add-subtract |
| 3 | `app.py` 編集（subtract関数追加） | Worktree側でコード変更 | ✅ 元フォルダ(main)は影響なし |
| 4 | `git commit` → `git push -u origin feature/add-subtract` | 変更をGitHubにpush | ✅ `5848f8a` |
| 5 | `gh pr create` | PR #1 を作成 | ✅ [PR #1](https://github.com/ShingoSatou/git-practice/pull/1) |

---

## Step 11: PR / Issue テンプレート

| # | コマンド | 目的 | 結果 |
|---|---------|------|------|
| 1 | `.github/pull_request_template.md` 作成 | PR テンプレートを追加 | ✅ 成功 |
| 2 | `.github/ISSUE_TEMPLATE/` にテンプレート作成 | バグ報告・機能要望テンプレートを追加 | ✅ 成功 |

---

## Step 12: タグ・リリース

| # | コマンド | 目的 | 結果 |
|---|---------|------|------|
| 1 | `git tag -a v1.0.0 -m "..."` | 注釈付きタグを作成 | ✅ 成功 |
| 2 | `git show v1.0.0 --no-patch` | タグの詳細を確認 | ✅ Tagger/Date/メッセージを確認 |
| 3 | `git push origin v1.0.0` | タグをリモートに push | ✅ 成功 |
| 4 | `gh release create v1.0.0 --title "..." --notes "..."` | GitHub リリースを作成 | ✅ [v1.0.0](https://github.com/ShingoSatou/git-practice/releases/tag/v1.0.0) |

---

## Step 13: GitHub CLI (`gh`)

| # | コマンド | 目的 | 結果 |
|---|---------|------|------|
| 1 | `gh auth status` | 認証状態を確認 | ✅ ShingoSatou でログイン済み |
| 2 | `gh repo view --json ...` | リポジトリ情報を JSON で取得 | ✅ 成功 |
| 3 | `gh issue create --title "..."` | Issue #4 を作成 | ✅ 成功 |
| 4 | `gh issue close 4 --comment "..."` | Issue #4 をクローズ | ✅ 成功 |
| 5 | `gh pr list --state all` | 過去の PR 一覧を確認 | ✅ PR #1〜#3（マージ済み） |

---

## Step 14: `git bisect` バグ探し

| # | コマンド | 目的 | 結果 |
|---|---------|------|------|
| 1 | `git checkout -b feature/bisect-practice` | 演習用ブランチを作成 | ✅ 成功 |
| 2 | 4つのコミットを作成（3つ目でバグ混入） | bisect 演習用の履歴を構築 | ✅ 成功 |
| 3 | `git bisect start` → `bad` → `good 851541f` | 二分探索を開始 | ✅ 成功 |
| 4 | `git bisect good` / `git bisect bad`（3回） | 各コミットをテストして判定 | ✅ `d66aee4` を特定 |
| 5 | `git bisect reset` | bisect を終了 | ✅ 元のブランチに復帰 |

---

## Step 16: Git の履歴をきれいに保つ運用

| # | コマンド | 目的 | 結果 |
|---|---------|------|------|
| 1 | `git commit --fixup 2d21d51` | typo 修正を fixup コミットとして作成 | ✅ `fixup!` プレフィックス付きで作成 |
| 2 | `GIT_SEQUENCE_EDITOR=true git rebase --autosquash b2a09ad` | fixup を元コミットに吸収 | ✅ 3コミット → 2コミットに |

---

## Step 17: Issue 駆動開発

| # | コマンド | 目的 | 結果 |
|---|---------|------|------|
| 1 | `gh issue create --title "feat: max関数を追加する"` | Issue #5 を作成 | ✅ 成功 |
| 2 | `git checkout -b feature/#5-add-max-value` | Issue 番号付きブランチを作成 | ✅ 成功 |
| 3 | `max_value` 関数を実装 + テスト追加 | コードを書いてコミット | ✅ 成功 |
| 4 | `gh pr create --title "..." --body "... Closes #5"` | PR #6 を作成（Issue 自動クローズ付き） | ✅ [PR #6](https://github.com/ShingoSatou/git-practice/pull/6) |
| 5 | `gh pr merge 6 --squash --delete-branch` | PR #6 を Squash merge | ✅ Issue #5 が自動クローズ |

---

## Step 19: コードレビューの自動化

| # | コマンド | 目的 | 結果 |
|---|---------|------|------|
| 1 | `.github/workflows/ai-review.yml` 作成 | AI レビューワークフローを追加 | ✅ 成功 |

---

## 最終: PR #7 で main にマージ

| # | コマンド | 目的 | 結果 |
|---|---------|------|------|
| 1 | `git push origin claude/amazing-buck` | ブランチをリモートに push | ✅ 成功 |
| 2 | `gh pr create --title "docs: Step 11〜20 ..."` | PR #7 を作成 | ✅ [PR #7](https://github.com/ShingoSatou/git-practice/pull/7) |
| 3 | `git merge origin/main` → コンフリクト解消 | main の変更を統合 | ✅ 成功 |
| 4 | `gh pr merge 7 --squash --delete-branch` | PR #7 を Squash merge | ✅ main に反映完了 |
