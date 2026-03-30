#!/bin/bash
# =============================================================
# pre-commit: AI によるコード品質チェックフック
# =============================================================
#
# 【使い方】
#   このスクリプトを .git/hooks/pre-commit にコピーまたはシンボリックリンク:
#     ln -s ../../scripts/pre-commit-ai-check.sh .git/hooks/pre-commit
#
# 【動作】
#   コミット前に変更内容を AI に送信し、重大な問題があればコミットをブロック。

# API キーが未設定ならスキップ
if [ -z "$ANTHROPIC_API_KEY" ]; then
    exit 0
fi

# ステージされた差分を取得
DIFF=$(git diff --cached --diff-algorithm=minimal)

if [ -z "$DIFF" ]; then
    exit 0
fi

echo "AI がコードをチェック中..."

RESPONSE=$(curl -s https://api.anthropic.com/v1/messages \
    -H "Content-Type: application/json" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -d "{
        \"model\": \"claude-haiku-4-5-20251001\",
        \"max_tokens\": 512,
        \"messages\": [{
            \"role\": \"user\",
            \"content\": \"以下のコード差分に重大な問題（セキュリティ脆弱性、明らかなバグ、ハードコードされた秘密情報）がないか確認してください。問題がなければ 'OK' とだけ返してください。問題があれば簡潔に指摘してください。\n\n\${DIFF}\"
        }]
    }")

REVIEW=$(echo "$RESPONSE" | jq -r '.content[0].text' 2>/dev/null)

if [ -z "$REVIEW" ] || [ "$REVIEW" = "null" ]; then
    # API エラー時はブロックしない
    echo "AI チェックをスキップしました（API エラー）"
    exit 0
fi

if [ "$REVIEW" = "OK" ]; then
    echo "AI チェック: 問題なし"
    exit 0
else
    echo "============================================"
    echo "AI が問題を検出しました:"
    echo "============================================"
    echo "$REVIEW"
    echo "============================================"
    echo "コミットをブロックしました。修正後に再度 git commit してください。"
    echo "チェックをスキップするには: git commit --no-verify"
    exit 1
fi
