# === Git学習用サンプルアプリケーション ===
# このファイルはコンフリクト演習やCI演習で編集していきます。


def greet(name: str) -> str:
    """挨拶メッセージを返す"""
    return f"こんにちは、{name}さん！"


def add(a: int, b: int) -> int:
    """2つの数値を足す"""
    return a + b


def multiply(a: int, b: int) -> int:
    """2つの数値を掛ける"""
    return a * b


if __name__ == "__main__":
    print(greet("太郎"))
    print(f"1 + 2 = {add(1, 2)}")
    print(f"3 × 4 = {multiply(3, 4)}")
