# === app.py のテスト ===
# GitHub Actions（CI）演習で、自動テストとして実行します。

from app import greet, add, multiply, subtract, divide


def test_greet():
    assert greet("太郎") == "やあ、太郎さん！おはよう！"


def test_add():
    assert add(1, 2) == 3
    assert add(-1, 1) == 0
    assert add(0, 0) == 0


def test_multiply():
    assert multiply(3, 4) == 12
    assert multiply(0, 5) == 0
    assert multiply(-2, 3) == -6


def test_subtract():
    assert subtract(5, 3) == 2
    assert subtract(0, 0) == 0
    assert subtract(1, 5) == -4


def test_divide():
    assert divide(10, 2) == 5.0
    assert divide(7, 2) == 3.5
    # ゼロ除算のテスト
    try:
        divide(1, 0)
        assert False, "ValueErrorが発生するはず"
    except ValueError:
        pass  # 期待通り


if __name__ == "__main__":
    test_greet()
    test_add()
    test_multiply()
    test_subtract()
    test_divide()
    print("全テスト合格！✅")
