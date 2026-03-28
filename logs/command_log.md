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

<!-- 以下、Step 3 以降を追記していく -->
