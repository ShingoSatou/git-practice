# === Git学習用サンプルアプリケーション ===
# このファイルはコンフリクト演習やCI演習で編集していきます。


def greet(name: str) -> str:
    """挨拶メッセージを返す"""
    return f"やあ、{name}さん！おはよう！"


def add(a: int, b: int) -> int:
    """2つの数値を足す"""
    return a + b


def multiply(a: int, b: int) -> int:
    """2つの数値を掛ける"""
    return a * b


def subtract(a: int, b: int) -> int:
    """2つの数値を引く（a から b を引く）"""
    return a - b


def divide(a: int, b: int) -> float:
    """2つの数値を割る"""
    if b == 0:
        raise ValueError("0で割ることはできません")
    return a / b


if __name__ == "__main__":
    print(greet("太郎"))
    print(f"1 + 2 = {add(1, 2)}")
    print(f"3 × 4 = {multiply(3, 4)}")
    print(f"5 - 3 = {subtract(5, 3)}")
