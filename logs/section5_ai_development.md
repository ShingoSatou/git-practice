# 応用（Step 13〜14）

## 目次

- [Step 13: GitHub CLI (`gh`)](#step-13-github-cli-gh)（完了）
- [Step 14: `git bisect` バグ探し](#step-14-git-bisect-バグ探し)（完了）

---

## Step 13: GitHub CLI (`gh`)

### 概要

`gh` は GitHub 公式の CLI ツール。ブラウザを開かずにターミナルから GitHub の操作ができる。

### 主要コマンド

| カテゴリ | コマンド | 効果 |
|---------|---------|------|
| 認証 | `gh auth login` / `gh auth status` | ログイン / 状態確認 |
| リポジトリ | `gh repo view` | リポジトリ情報を表示 |
| Issue | `gh issue list` / `gh issue create` / `gh issue close` | 一覧 / 作成 / クローズ |
| PR | `gh pr list` / `gh pr create` / `gh pr merge` | 一覧 / 作成 / マージ |
| リリース | `gh release create <tag>` | リリース作成 |
| API | `gh api <endpoint>` | GitHub API を直接叩く |

### `--json` と `--jq` の活用

ほとんどのコマンドで `--json` による構造化出力と `--jq` によるフィルタが使える。スクリプトや AI からの利用で特に便利。

```bash
gh pr list --json number,title --jq '.[].title'
```

### 実践

- `gh repo view` でリポジトリ情報を確認
- `gh issue create` で Issue #4 を作成し、`gh issue close` でクローズ
- `gh pr list --state all` で過去の PR 一覧を確認

### AI駆動開発での位置づけ

`gh` は AI 駆動開発の要。AI ツールが PR 作成・Issue 管理・CI 確認・リリースをすべてターミナルから実行できる。

### Q&A

**Q: `gh pr list` の結果を JSON で取得し、タイトルだけ抽出するには？**

A: `--json` と `--jq` フラグを組み合わせる。
```bash
gh pr list --json number,title --jq '.[].title'
```

**Q: ターミナルから Issue を作成するコマンドは？**

A: `gh issue create`。`--title` と `--body` で内容を指定できる。

**Q: `gh` が AI 駆動開発で重要な理由は？**

A: AI ツールがコマンドを使ってターミナルだけで GitHub 操作を完結できるから。ブラウザ不要で PR 作成・Issue 管理・リリースなどが可能。

---

## Step 14: `git bisect` バグ探し

### 概要

`git bisect` は、**どのコミットでバグが混入したかを二分探索で特定する**コマンド。100 コミットでも最大 7 回のテストで原因コミットを見つけられる。

### 使い方

```bash
git bisect start           # 開始
git bisect bad             # 今のコミットは「バグあり」
git bisect good <commit>   # このコミットは「バグなし」
# → Git が中間コミットをチェックアウト → テストして good/bad を判定 → 繰り返し
git bisect reset           # 終了、元のブランチに戻る
```

### 自動モード（`git bisect run`）

テストスクリプトを渡して自動判定できる。

```bash
git bisect start
git bisect bad HEAD
git bisect good <commit>
git bisect run <テストコマンド>
```

テスト成功（exit 0）→ good、失敗（exit 1）→ bad と自動判定。

### 実践

- `feature/bisect-practice` ブランチで演習
- 4つのコミットを作成し、3つ目で `add` 関数にバグを混入（`a + b` → `a - b`）
- `git bisect` で 3 回のテストでバグ混入コミット `d66aee4 refactor: add関数を整理` を特定

### AI駆動開発での位置づけ

`git bisect run` でテストを自動実行させれば、AI がバグ混入コミットの特定まで自動で行える。大規模プロジェクトで特に有効。
