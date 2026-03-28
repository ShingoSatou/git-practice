# CI/CD と自動化（Step 7〜9）

## 目次

- [Step 7: GitHub Actions / CI 基礎](#step-7-github-actions--ci-基礎)
  - [Q22: GitHub ActionsはAI駆動開発で理解が必要か](#q22-github-actionsはai駆動開発で理解が必要か)
  - [Q23: GitHub Actionsの仕組み](#q23-github-actionsの仕組みをわかりやすく)
  - [Q24: CIはGitHub Actionsの機能の一部か](#q24-ciはgithub-actionsの機能の一部か)
  - [Q25: デプロイとは何か](#q25-デプロイ自動デプロイとはどんな意味か)
- [Step 8: Pre-commit Hooks](#step-8-pre-commit-hooks)（未着手）
  - [Q29: .git/hooks/が見えないがどこにあるのか](#q29-githooks-が見えないがどこにあるのか)
  - [Q30: pre-commit installはターミナルで行うのか](#q30-pre-commit-installはターミナルで行うのか)
  - [Q31: pre-commit実行時にpythonを先頭に入れなくていいのか](#q31-pre-commit実行時にpythonを先頭に入れなくていいのか)
- [Step 9: シークレット管理](#step-9-シークレット管理)（未着手）

---

## Step 7: GitHub Actions / CI 基礎

### 概要

**CI（継続的インテグレーション）** とは「コードを変更するたびに、自動でチェック（テスト・構文チェック等）を走らせる仕組み」。GitHub Actions は、YAML ファイルで定義したワークフローを自動実行するサービス。

### CI がある場合 / ない場合

```
CI なし:
  コード変更 → push → PR → レビュー → マージ → 😱「動かない！」

CI あり:
  コード変更 → push → 🤖 自動テスト実行 → ✅ or ❌ → PR → レビュー → マージ
```

### GitHub Actions の構造

```
.github/
  workflows/
    ci.yml       ← このファイルが自動チェックの設定
```

3階層:
- **Workflow（ワークフロー）**: ci.yml ファイル全体
- **Job（ジョブ）**: 「テストを実行する」などの作業単位
- **Step（ステップ）**: 1つ1つのコマンド

### ci.yml の基本構造

```yaml
name: CI                          # ワークフロー名

on:                               # 「いつ実行するか」（トリガー）
  push:
    branches: [main]              # main に push した時
  pull_request:
    branches: [main]              # main への PR を作った時

jobs:                             # 「何を実行するか」
  test:
    runs-on: ubuntu-latest        # GitHub が用意した Linux マシンで動かす
    steps:
      - uses: actions/checkout@v4       # ① コードをダウンロード
      - uses: actions/setup-python@v5   # ② Python をインストール
        with:
          python-version: '3.12'
      - run: python test_app.py         # ③ テスト実行
```

### 実践で体験したこと

1. `.github/workflows/ci.yml` を作成
2. `feature/add-ci` ブランチで push → PR #2 を作成
3. **CI 失敗を体験**: `test_app.py` の期待値が `greet` 関数の変更後の内容と合っていなかった
4. テストを修正して再push → **CI 成功** ✅
5. squash merge で PR をマージ

### CI の本質

> 「人間がチェックし忘れる」ミスを、**機械が毎回自動で確認してくれる**仕組み。

### Q&A

---

### Q22: GitHub ActionsはAI駆動開発で理解が必要か

`#CI` `#AI駆動開発` `#GitHub_Actions`

**質問**: GitHub ActionはAI駆動開発において理解する必要がありますか？

**回答**:

**はい、必要。ただし「ゼロから書ける」必要はない。**

| レベル | 必要度 | 内容 |
|-------|-------|------|
| 仕組みの理解 | **必須** ✅ | 「pushしたらテストが走る」「CI失敗 = マージ不可」を知る |
| 既存ワークフローの読解 | **必須** ✅ | チームのCI設定を読んで「何をチェックしているか」理解する |
| 設定の修正 | あると便利 | Pythonバージョンの変更、テストコマンドの追加等 |
| ゼロから複雑な設定を書く | 不要 | AIに書かせればよい |

Step 7 で体験したことが理解できていれば十分。「CI が落ちた → ログを読む → 原因を特定 → 修正する」という対処力が大事。

---

### Q23: GitHub Actionsの仕組みをわかりやすく

`#GitHub_Actions` `#CI` `#基礎概念`

**質問**: GitHub Action自体を理解していないので、わかりやすく説明してください。

**回答**:

**GitHub が用意した「パソコン」を、あなたの代わりに動かしてくれるサービス。**

```
あなたが push する
→ GitHub がサーバー上に仮想PCを立ち上げる
→ そのPCでテスト等を自動実行する
→ 結果（✅ or ❌）を PR に表示する
```

ci.yml は「ロボットへの指示書」:
```yaml
name: CI                    # 指示書の名前
on: push / pull_request     # いつ動くか
jobs:
  test:
    runs-on: ubuntu-latest  # 使うPCの種類
    steps:                  # 手順（上から順に実行）
      - コードをダウンロード
      - Python をインストール
      - テストを実行
```

テスト以外にも、コード品質チェック・ビルド・自動デプロイ・通知など様々な作業を自動化できる。

料金: パブリックリポジトリは無料。プライベートは月2,000分まで無料。

---

### Q24: CIはGitHub Actionsの機能の一部か

`#CI` `#GitHub_Actions` `#無料枚`

**質問**: CIもGitHub Actionの機能の一部という認識であっている？ CIを起動するもの無料枚を消費する？

**回答**:

**両方とも合っている。**

```
GitHub Actions（サービス全体）
  ├── CI（テスト自動実行）         ← 今回やったこと
  ├── CD（自動デプロイ）
  ├── 自動通知（Slack連携等）
  └── その他なんでも
```

CIを動かすたびに無料枚を消費する。ただし:
- パブリックリポジトリ: **無制限**
- プライベートリポジトリ: 月**2,000分**まで無料

今回の演習のCIは1回約6秒なので、学習レベルでは使い切ることはまずない。

---

### Q25: デプロイ・自動デプロイとはどんな意味か

`#デプロイ` `#CD` `#基礎概念`

**質問**: デプロイを理解していません。デプロイ、自動デプロイとはどんな意味？

**回答**:

**「作ったコードを、実際にユーザーが使えるサーバーに置くこと」。**

| 用語 | 意味 | 例えると |
|------|------|--------|
| 開発 | 自分のPCでコードを書く | 料理を試作する |
| **デプロイ** | **本番サーバーに配置して公開** | **お店に出す** |
| ロールバック | デプロイを取り消して前の版に戻す | メニューから引っ込める |

**手動 vs 自動**:
- 手動デプロイ: 人間がサーバーにログインしてコマンドを打つ
- 自動デプロイ(CD): PRマージ後にGitHub Actionsが自動でサーバーに配置

CI/CD の「CD」が Continuous Deployment/Delivery（継続的デプロイ）。今回の学習範囲では CI だけ理解できていれば十分。

---

## Step 8: Pre-commit Hooks

### 概要

Pre-commit Hooks は **`git commit` する直前に、自分の PC 上で自動チェックを走らせる仕組み**。GitHub Actions（CI）が push 後にサーバーでチェックするのに対し、Pre-commit はコミット前にローカルでチェックする。

### CI との違い

```
Pre-commit Hook: コミットする前 → 自分の PC でチェック → 問題があればコミットを止める
GitHub Actions:  push した後   → GitHub のサーバーでチェック → 結果が PR に表示
```

> CI が「最終チェック」なら、Pre-commit は「最初のフィルター」。

### よくあるチェック項目

| チェック | 内容 |
|---------|------|
| フォーマット | コードの書き方が統一されているか |
| 構文エラー | そもそもコードが動くか |
| 不要ファイル | `.env`（パスワード入り）等がコミットされていないか |
| ファイルサイズ | 巨大なファイルが含まれていないか |

### Git の Hook 機能

`.git/hooks/` に特定の名前のスクリプトを置くと自動実行される:
- `pre-commit` — `git commit` 直前
- `pre-push` — `git push` 直前
- `commit-msg` — コミットメッセージをチェック

実務では Python の `pre-commit` パッケージで管理するのが一般的。

### AI駆動開発での位置づけ

仕組みを知っておき、チームで導入されていれば使えれば十分。自分で設定をゼロから書く必要はない（AIに任せればよい）。

### 実践で体験したこと

1. `py -3.11 -m venv .venv` で Python 仮想環境を作成
2. `pip install pre-commit` でツールをインストール
3. `.pre-commit-config.yaml` でチェック項目を定義
4. `pre-commit install` で Git hook に登録
5. コミット時に `trailing-whitespace` が Failed → 自動修正 → 再コミットで Pass

### Q&A

---

### Q26: .pre-commit-config.yaml は .git/hooks/ にないけど大丈夫か

`#pre-commit` `#hooks` `#設定`

**質問**: `.git/hooks/` の位置に `.pre-commit-config.yaml` が存在しないけど、それでも問題ないの？

**回答**:

**大丈夫。** 2つは別の役割で連携して動く。

| ファイル | 場所 | 役割 |
|---------|------|------|
| `.git/hooks/pre-commit` | `.git/` 内（非公開） | 「pre-commit ツールを起動しろ」という橋渡し（`pre-commit install` が自動生成） |
| `.pre-commit-config.yaml` | プロジェクトルート（公開） | 「何をチェックするか」のリスト（自分で作る） |

`.pre-commit-config.yaml` はリポジトリに含まれるのでチーム全員が同じチェックを使える。`.git/hooks/` はリポジトリに含まれないので、各メンバーが `pre-commit install` を実行する必要がある。

---

### Q27: trailing-whitespace等のIDは自分で定義するのか既に決まっているものか

`#pre-commit` `#hooks` `#設定`

**質問**: `trailing-whitespace` などのIDは、自分で定義するのではなく、既に決まっているもの？

**回答**:

**既に決まっている。** 公開されているチェック集（`repo`）の中から「使いたいもの」を選ぶ仕組み。`https://github.com/pre-commit/pre-commit-hooks` が公式チェック集で、`trailing-whitespace`, `check-yaml`, `check-merge-conflict` 等のメニューが用意されている。公式以外にも他の人が作ったチェック集を追加できる。

---

### Q28: pre-commitの使用には制限があるか

`#pre-commit` `#料金` `#制限`

**質問**: pre-commitの使用には使用制限などはありますか？

**回答**:

**ありません。完全に無料・無制限。** 自分のPCで動くオープンソースツールなので、GitHub Actions（サーバーで動く → 無料枠あり）と違い、実行回数・料金の制限は一切ない。初回だけチェックツールのダウンロードにネットが必要だが、以降はオフラインで動く。

---

### Q29: .git/hooks/ が見えないがどこにあるのか

`#hooks` `#.git` `#隠しフォルダ`

**質問**: repo内に `.git/hooks/` が見当たらない。pre-commit install はどこにインストールされる？

**回答**:

`.git/` は**隠しフォルダ**なので VSCode やエクスプローラーに表示されない。しかし存在している。`pre-commit install` は `プロジェクト/.git/hooks/pre-commit` にスクリプトを生成する。

`.git/` にはリポジトリの内部データ（全コミット履歴、ブランチ情報、設定等）が入っており、普段触る必要がないので隠されている。間違って削除すると全履歴が失われるので注意。

---

### Q30: pre-commit installはターミナルで行うのか

`#pre-commit` `#ターミナル` `#セットアップ`

**質問**: pre-commit installはターミナルで行っているの？

**回答**:

**はい、ターミナルで実行するコマンド。** プロジェクトごとに1回だけ実行すればOK。以降は `git commit` するたびに自動でチェックが走る。

```
ターミナル: pip install pre-commit           ← ① ツールをPCにインストール
エディタ:   .pre-commit-config.yaml を作成    ← ② チェック項目を定義
ターミナル: pre-commit install                ← ③ Git の hooks に登録
```

---

### Q31: pre-commit実行時にpythonを先頭に入れなくていいのか

`#pre-commit` `#Python` `#CLI`

**質問**: pre-commitはPythonライブラリですよね？ターミナルで実行するときに、pythonを先頭に入れて実行する必要はないの？

**回答**:

**不要。** `pip install pre-commit` すると、`.venv/Scripts/pre-commit.exe` が自動的に作られる。仮想環境を有効化すると `Scripts/` にパスが通るので、`pre-commit` とだけ打てばOK。`pip` も同じ仕組み（`python -m pip` とも書けるが、普段は `pip` だけで使える）。

---

## Step 9: シークレット管理

### 概要

**シークレット** = パスワード・APIキー・トークンなど、絶対に他人に見せてはいけない情報。これをGitHubに公開してしまう事故を防ぐための3つの防御ラインを学ぶ。

### 3つの防御ライン

| # | 方法 | 守るもの |
|---|------|---------|
| 1 | `.gitignore` | そもそもリポジトリに入れない |
| 2 | `.env` ファイル | コードとシークレットを分離する |
| 3 | GitHub Secrets | CI で使う秘密情報を安全に保管する |

### .env と .env.example の使い分け

| ファイル | 内容 | Git に含む？ |
|---------|------|------------|
| `.env` | 実際のパスワード | **❌ 含めない**（.gitignore で除外） |
| `.env.example` | 変数名だけのテンプレート | **✅ 含める** |

```
❌ 悪い例: config.py に DATABASE_URL = "postgresql://user:password@..."
✅ 良い例: .env に外出し → config.py は os.environ["DATABASE_URL"] で読む
```

### GitHub Secrets

CI で秘密情報が必要な場合、GitHub の Settings → Secrets に登録。`${{ secrets.DEPLOY_TOKEN }}` のように参照する。コード上に直接書かず、GitHub が安全に保管してくれる。

### 鉄則

> **パスワードやキーをコードに直接書かない。**
