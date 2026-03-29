# AI駆動開発（Step 15〜20）

## 目次

- [Step 15: `.gitignore` の徹底管理](#step-15-gitignore-の徹底管理)（完了）
- [Step 16: Git の履歴をきれいに保つ運用](#step-16-git-の履歴をきれいに保つ運用)（完了）
- [Step 17: Issue 駆動開発](#step-17-issue-駆動開発)（完了）
- [Step 18: モノレポ vs ポリレポ](#step-18-モノレポ-vs-ポリレポ)（未着手）
- [Step 19: コードレビューの自動化](#step-19-コードレビューの自動化)（未着手）
- [Step 20: Git Hooks + AI の組み合わせ](#step-20-git-hooks--ai-の組み合わせ)（未着手）

---

## Step 15: `.gitignore` の徹底管理

### 概要

`.gitignore` は Git に追跡させないファイルを指定するファイル。AI駆動開発では管理すべきファイルが増えるため、体系的な設定が必要。

### パターン構文

| パターン | 意味 |
|---------|------|
| `*.log` | ワイルドカード |
| `dir/` | ディレクトリ全体 |
| `!file` | 除外の例外（追跡する） |
| `**/dir` | 任意の階層のディレクトリ |

### AI駆動開発で追加すべきカテゴリ

| カテゴリ | パターン例 | 理由 |
|---------|-----------|------|
| シークレット | `.env.*`, `*.pem`, `*.key` | 漏洩防止 |
| AI ツール | `.claude/`, `.cursor/`, `.aider*` | 個人設定の混入防止 |
| ビルド成果物 | `dist/`, `build/` | リポジトリ肥大化防止 |

### ポイント

- `!.env.example` で例外指定 → テンプレートだけ共有できる
- すでに追跡されたファイルは `git rm --cached <file>` でキャッシュから削除が必要
- 個人環境固有のパターンはグローバル `.gitignore`（`core.excludesfile`）に分離できる

---

## Step 16: Git の履歴をきれいに保つ運用

### 概要

履歴が汚いと AI がコードの経緯を読み取りにくい。きれいな履歴は人間にも AI にも優しい。

### 3つの手法

#### 1. Squash Merge

PR マージ時にブランチ内の複数コミットを1つにまとめる。GitHub の PR 画面で「Squash and merge」を選ぶだけ。**最も一般的で推奨**。

| マージ方法 | 結果 |
|-----------|------|
| Create a merge commit | 全コミット + マージコミットが残る |
| Squash and merge | 1コミットにまとまる（推奨） |
| Rebase and merge | コミットが直列に並ぶ |

#### 2. `git commit --fixup` + `git rebase --autosquash`

「あのコミットを修正したい」とき、fixup コミットを作って元のコミットに吸収する。

```bash
git commit --fixup <修正したいコミットのハッシュ>
GIT_SEQUENCE_EDITOR=true git rebase --autosquash <起点>
```

#### 3. コミット単位の考え方

- 1つの目的に対して1コミット
- テストが通る状態でコミット
- "WIP", "fix" だけのメッセージは避ける

### 推奨フロー

1. feature ブランチで自由にコミット
2. push 前に fixup + autosquash で整理
3. PR では Squash and merge → main には1コミットとして残る

### 実践

- `--fixup` で typo 修正を作成し、`--autosquash` で元コミットに吸収する演習を実施

### AI駆動開発での位置づけ

AI は `git log` / `git blame` で履歴を読むため、きれいな履歴だと正確にコンテキストを把握できる。`git bisect` の精度も向上する。

### Q&A

**Q: `--no-verify` の意味は？**

A: `git commit --no-verify` は pre-commit フック（自動チェック）をスキップするオプション。本来は使わないのが正しい運用で、フック失敗時は原因を修正すべき。

**Q: fixup は対象コミットの後にコミットがあっても有効か？**

A: 有効。`rebase --autosquash` が fixup コミットを対象コミットの直後に自動移動して吸収する。

**Q: fixup で衝突（コンフリクト）が起きたらどうする？**

A: 通常の rebase コンフリクトと同じ。手動修正 → `git add` → `git rebase --continue`。中止は `git rebase --abort`。fixup はなるべく早めに実行するとコンフリクトのリスクが減る。

---

## Step 17: Issue 駆動開発

### 概要

すべての作業を Issue（チケット）から始める開発スタイル。Issue → ブランチ → コード → PR → Issue 自動クローズの流れ。

### 流れ

1. `gh issue create` で Issue を作成
2. `feature/#番号-説明` でブランチを作成
3. コードを書いてコミット（メッセージに `#番号` を含める）
4. PR を作成し、本文に `Closes #番号` と書く
5. PR マージ時に Issue が自動クローズ

### Issue 自動クローズのキーワード

`Closes`, `Fixes`, `Resolves` + `#番号`（大文字小文字不問）

### ブランチ命名規則

| パターン | 用途 |
|---------|------|
| `feature/#番号-説明` | 新機能 |
| `fix/#番号-説明` | バグ修正 |
| `chore/#番号-説明` | 雑務 |

### 実践

- Issue #5「max関数を追加する」を作成
- `feature/#5-add-max-value` ブランチで `max_value` 関数を実装
- PR #6 を作成（`Closes #5` 付き）

### AI駆動開発での位置づけ

Issue に「やりたいこと」「完了条件」を書いておけば、AI がそれを指示書として受け取り、ブランチ作成 → 実装 → PR 作成まで自動で行える。
