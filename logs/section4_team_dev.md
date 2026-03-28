# チーム開発（Step 10〜11）

## 目次

- [Step 10: ブランチ保護ルール](#step-10-ブランチ保護ルール)（未着手）
- [Step 11: Pull Request のベストプラクティス](#step-11-pull-request-のベストプラクティス)（未着手）

---

## Step 10: ブランチ保護ルール

### 概要

main ブランチに「保護ルール」を設定し、壊れないように守る仕組み。GitHub の Settings → Rules → Rulesets で設定する。

### 主な保護ルール

| ルール | 効果 | 個人開発 | チーム開発 |
|-------|------|---------|-----------|
| Require pull request | main への直接 push を禁止 | △ | ✅ 必須 |
| Require status checks | CI が通らないとマージ不可 | ✅ 推奨 | ✅ 必須 |
| Require approvals | レビュー承認がないとマージ不可 | ✗ 不要 | ✅ 必須 |
| Restrict force push | `git push --force` を禁止 | ✅ 推奨 | ✅ 必須 |

### 料金

- パブリックリポジトリ: 無料
- プライベートリポジトリ: GitHub Pro（月$4）が必要

### AI駆動開発での位置づけ

チームに参加した時、「main に直接 push できない」のはバグではなくブランチ保護ルール。PR 経由でマージするのが正しい手順。

---

## Step 11: Pull Request のベストプラクティス

（未着手 — 後のステップで学習予定）
