# === app.py のテスト ===
# GitHub Actions（CI）演習で、自動テストとして実行します。

from app import greet, add, multiply


def test_greet():
    assert greet("太郎") == "こんにちは、太郎さん！"


def test_add():
    assert add(1, 2) == 3
    assert add(-1, 1) == 0
    assert add(0, 0) == 0


def test_multiply():
    assert multiply(3, 4) == 12
    assert multiply(0, 5) == 0
    assert multiply(-2, 3) == -6


if __name__ == "__main__":
    test_greet()
    test_add()
    test_multiply()
    print("全テスト合格！✅")
