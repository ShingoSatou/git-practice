#!/bin/bash
# =============================================================
# prepare-commit-msg: AI によるコミットメッセージ自動生成フック
# =============================================================
#
# 【使い方】
#   このスクリプトを .git/hooks/prepare-commit-msg にコピーまたはシンボリックリンク:
#     ln -s ../../scripts/prepare-commit-msg.sh .git/hooks/prepare-commit-msg
#
# 【必要な環境変数】
#   ANTHROPIC_API_KEY: Anthropic の API キー
#
# 【動作】
#   git commit 実行時に:
#   1. ステージされた差分を取得
#   2. AI API に送信してコミットメッセージを生成
#   3. エディタに自動入力（ユーザーが編集可能）

COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2

# マージコミットやテンプレート使用時はスキップ
if [ -n "$COMMIT_SOURCE" ]; then
    exit 0
fi

# API キーが未設定ならスキップ（通常のコミットにフォールバック）
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "ANTHROPIC_API_KEY が未設定のため、AI メッセージ生成をスキップします。"
    exit 0
fi

# ステージされた差分を取得
DIFF=$(git diff --cached --diff-algorithm=minimal)

# 差分がなければスキップ
if [ -z "$DIFF" ]; then
    exit 0
fi

echo "AI がコミットメッセージを生成中..."

# Anthropic API を呼び出し
RESPONSE=$(curl -s https://api.anthropic.com/v1/messages \
    -H "Content-Type: application/json" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -d "{
        \"model\": \"claude-haiku-4-5-20251001\",
        \"max_tokens\": 256,
        \"messages\": [{
            \"role\": \"user\",
            \"content\": \"以下の git diff からコミットメッセージを1行で生成してください。Conventional Commits 形式(feat:, fix:, docs: 等)で、日本語で書いてください。メッセージのみ出力し、説明は不要です。\n\n\${DIFF}\"
        }]
    }")

# レスポンスからメッセージを抽出
MESSAGE=$(echo "$RESPONSE" | jq -r '.content[0].text' 2>/dev/null)

# 生成に成功したらコミットメッセージファイルに書き込み
if [ -n "$MESSAGE" ] && [ "$MESSAGE" != "null" ]; then
    echo "$MESSAGE" > "$COMMIT_MSG_FILE"
    echo "AI 生成メッセージ: $MESSAGE"
    echo "(エディタで編集できます)"
fi
