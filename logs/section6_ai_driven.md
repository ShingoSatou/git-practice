# AI駆動開発（Step 15〜20）

## 目次

- [Step 15: `.gitignore` の徹底管理](#step-15-gitignore-の徹底管理)（完了）
- [Step 16: Git の履歴をきれいに保つ運用](#step-16-git-の履歴をきれいに保つ運用)（完了）
- [Step 17: Issue 駆動開発](#step-17-issue-駆動開発)（完了）
- [Step 18: モノレポ vs ポリレポ](#step-18-モノレポ-vs-ポリレポ)（完了）
- [Step 19: コードレビューの自動化](#step-19-コードレビューの自動化)（完了）
- [Step 20: Git Hooks + AI の組み合わせ](#step-20-git-hooks--ai-の組み合わせ)（完了）

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
<<<<<<< HEAD

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
- PR #6 を Squash merge → Issue #5 が自動クローズされることを確認

### AI駆動開発での位置づけ

Issue に「やりたいこと」「完了条件」を書いておけば、AI がそれを指示書として受け取り、ブランチ作成 → 実装 → PR 作成まで自動で行える。

### Q&A

**Q: Issue と PR の番号は共通か？**

A: はい、GitHub では Issue と PR が同じ番号の連番を共有する。Issue #5 が使われたら次の PR は #6 になり、Issue #5 と PR #5 が同時に存在することはない。

---

## Step 18: モノレポ vs ポリレポ

### 概要

複数プロジェクトを1リポジトリにまとめる（モノレポ）か、別々のリポジトリにする（ポリレポ）かの設計判断。

### 比較

| 観点 | モノレポ | ポリレポ |
|------|---------|---------|
| コード共有 | 簡単 | パッケージ公開が必要 |
| 横断的変更 | 1 PR でできる | 複数 PR に分散 |
| リポジトリサイズ | 巨大になりがち | 軽量 |
| CI 速度 | 遅くなりがち | 速い |
| 権限管理 | 複雑 | シンプル |

### AI駆動開発での違い

- **モノレポ**: AI がフロントもバックも全部見える → 横断的な提案が可能
- **ポリレポ**: AI は1リポジトリしか見えない → 他サービスとの整合性は人間が確認

### 判断基準

- 小〜中規模・1チーム・依存が強い → モノレポ
- 大規模・複数チーム・独立サービス → ポリレポ
- AI に全体を見せたい → モノレポ有利

### 関連ツール・機能

- **Turborepo / Nx**: モノレポの CI 高速化・変更影響分析
- **Sparse Checkout**: モノレポで必要なディレクトリだけチェックアウト（`git sparse-checkout set <dir>`）

---

## Step 19: コードレビューの自動化

### 概要

PR 作成時に GitHub Actions で AI にコードレビューさせる仕組み。人間のレビュー前に AI が問題点を指摘し、レビューの質と速度を上げる。

### ワークフローの流れ

1. PR 作成/更新がトリガー（`on: pull_request: types: [opened, synchronize]`）
2. `fetch-depth: 0` で全履歴を取得し `git diff` で差分を取得
3. AI API（例: Anthropic）に差分を送信してレビューを依頼
4. `actions/github-script` で PR にレビューコメントを投稿

### ポイント

- API キーは GitHub Secrets に保存（コードに直書きしない）
- `permissions` で最小権限を明示（`contents: read`, `pull-requests: write`）
- `fetch-depth: 0` がないと差分比較ができない

### 既製ツール

- **CodeRabbit**: AI レビューコメント自動投稿（無料プランあり）
- **GitHub Copilot Code Review**: GitHub 公式
- **Cursor + PR 連携**

### 実践

- `.github/workflows/ai-review.yml` を作成（Anthropic API を使ったレビューワークフロー）

### AI駆動開発での位置づけ

AI レビューは人間のレビューの補助。AI が typo・バグ・セキュリティを先に潰し、人間は設計やビジネスロジックに集中できる。

---

## Step 20: Git Hooks + AI の組み合わせ

### 概要

Git Hooks に AI API 呼び出しを組み込み、コミット時に AI が自動でチェック・生成を行う仕組み。

### パターン

| パターン | フック | 動作 |
|---------|--------|------|
| コミットメッセージ自動生成 | `prepare-commit-msg` | 差分から AI がメッセージを生成 |
| コード品質チェック | `pre-commit` | 変更内容にバグ・脆弱性がないか AI が確認 |
| push 前レビュー | `pre-push` | ブランチ全体の差分を AI が確認 |

### フックの共有方法

`.git/hooks/` は Git に追跡されないため、`scripts/` に置いてリポジトリで共有する。

| 方法 | 設定 |
|------|------|
| シンボリックリンク | `ln -s ../../scripts/hook.sh .git/hooks/hook` |
| `core.hooksPath` | `git config core.hooksPath scripts/` |
| pre-commit フレームワーク | `.pre-commit-config.yaml` で管理 |

### 注意点

- API 呼び出しでコミットが数秒遅くなる
- API エラー時はブロックせずスキップする設計が重要
- Haiku など高速・低コストなモデルを使う
- API キーは環境変数で管理（フック内にハードコードしない）

### 実践

- `scripts/prepare-commit-msg.sh`: コミットメッセージ自動生成フック
- `scripts/pre-commit-ai-check.sh`: コード品質チェックフック

### AI チェックの全体像

```
コミット時（Hooks+AI） → push時（Hooks） → PR時（Actions+AI）
即座にフィードバック      最終確認          詳細レビュー
```

Step 8（Hooks）、Step 19（Actions+AI）、Step 20 で開発フロー全段階に AI を組み込む方法が揃った。

### Q&A

**Q: コミット時・push時・PR時の全段階に AI を入れる意味はあるか？**

A: 全段階に入れる必要はない。実運用では **PR 時の AI レビューだけで十分**。コミット時は毎回 API を叩くので遅くなり開発テンポが落ちる。pre-commit は linter/フォーマッターなど高速でローカル完結するチェックに留めるのが現実的。

**Q: AI レビューは PR 新規作成時のみか？**

A: いいえ。`synchronize` トリガーにより、PR が開いている間にコミットを push するたびに AI レビューが再実行される。修正漏れや新たなバグ混入を防げる。レビュー対象は新しいコミットだけでなく PR 全体の差分（main との差分）。

**Q: Draft PR 中はレビューをスキップしたい場合は？**

A: トリガーに `ready_for_review` を追加し、Draft 解除時に初めてレビューを走らせることで API コストを抑えられる。
=======
>>>>>>> origin/main
