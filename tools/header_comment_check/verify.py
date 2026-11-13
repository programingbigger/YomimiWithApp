#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
先頭コメント追加の「既存コードを1文字も書き換えていない」ことを証明するスクリプト

# 使い方（ターミナルで）
    cd ~/Desktop/Yomimi
    python3 tools/header_comment_check/verify.py

# 何を確かめているか（Swiftファイル1つずつ、バイト単位で比較）
    1. 追加は「1か所にまとまった連続した行」だけである
    2. 追加された行を取り除くと、変更前のファイルと完全に一致する
       （SHA-256ハッシュが、変更前に記録した manifest_before.sha256 と一致する）
    3. 追加された行は「/* 〜 */ のコメント」と空行だけである（＝実行されるコードを含まない）
    4. 追加した場所は、ファイル先頭のヘッダーコメントの直後（コードより前）である

# 比較に使うもの
    originals/            … 変更前の全Swiftファイルのコピー（.orig）
    manifest_before.sha256 … 変更前の全Swiftファイルのハッシュ値

1つでもNGがあれば、最後に「NG」と表示して終了コード1で終わる。
"""
import difflib
import hashlib
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent                      # Yomimi/（gitのルート）
ORIGINALS = HERE / "originals"
MANIFEST = HERE / "manifest_before.sha256"
SOURCE_DIR = ROOT / "YomimiApp" / "YomimiApp"  # Swiftファイルの置き場所


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def load_manifest() -> dict:
    """manifest_before.sha256 を {相対パス: ハッシュ} にして返す"""
    result = {}
    for line in MANIFEST.read_text(encoding="utf-8").splitlines():
        if line.strip():
            digest, rel = line.split(None, 1)
            result[rel.strip()] = digest
    return result


def check_file(rel: str, expected_hash: str):
    """1ファイルを検査して (OKかどうか, 説明, 追加行数) を返す"""
    orig_path = ORIGINALS / (rel + ".orig")
    cur_path = ROOT / rel
    if not orig_path.exists():
        return False, "変更前のコピー（.orig）が見つからない", 0
    if not cur_path.exists():
        return False, "現在のファイルが見つからない（削除 or 改名された）", 0

    orig_bytes = orig_path.read_bytes()
    cur_bytes = cur_path.read_bytes()

    # 変更前コピー自体が、記録したハッシュと一致しているか（コピーの改ざん防止）
    if sha256(orig_bytes) != expected_hash:
        return False, "変更前のコピーが manifest のハッシュと一致しない", 0

    # まったく同じ＝未変更
    if cur_bytes == orig_bytes:
        return True, "変更なし（元のまま）", 0

    orig = orig_bytes.splitlines(keepends=True)
    cur = cur_bytes.splitlines(keepends=True)

    added_count = len(cur) - len(orig)
    if added_count <= 0:
        return False, "行数が増えていないのに内容が違う（既存行が変更・削除された）", 0

    # 「現在 = 変更前の前半 + 追加行 + 変更前の後半」と分けられる位置 i をすべて探す
    #   front_ok[i] : 変更前の先頭 i 行が、現在の先頭 i 行と完全一致
    #   back_ok[i]  : 変更前の i 行目以降が、現在の末尾側と完全一致
    front_ok = [True]
    for k in range(len(orig)):
        front_ok.append(front_ok[-1] and orig[k] == cur[k])
    back_ok = [True] * (len(orig) + 1)
    for k in range(len(orig) - 1, -1, -1):
        back_ok[k] = back_ok[k + 1] and orig[k] == cur[k + added_count]
    candidates = [i for i in range(len(orig) + 1) if front_ok[i] and back_ok[i]]

    # 1. 既存の全行がそのままの順番で残っているか（分け方が1つも無ければ、既存行が変わっている）
    if not candidates:
        matcher = difflib.SequenceMatcher(None, orig, cur, autojunk=False)
        bad = [i1 + 1 for tag, i1, _, _, _ in matcher.get_opcodes() if tag in ("replace", "delete")]
        where = f"変更前の {bad[0]} 行目付近" if bad else "追加が2か所以上に分かれている"
        return False, f"既存の行が変更・削除されている（{where}）", 0

    reason = ""
    for i in candidates:
        added = cur[i:i + added_count]
        restored = b"".join(cur[:i] + cur[i + added_count:])

        # 2. 追加行を取り除くと、変更前と完全一致するか
        if restored != orig_bytes or sha256(restored) != expected_hash:
            reason = "追加行を取り除いても変更前と一致しない"
            continue

        # 3. 追加行はコメントと空行だけか
        texts = [line.decode("utf-8").strip() for line in added]
        body = [t for t in texts if t != ""]
        if len(body) < 2 or body[0] != "/*" or body[-1] != "*/":
            reason = "追加行が /* 〜 */ のコメントになっていない"
            continue
        if any("/*" in t or "*/" in t for t in body[1:-1]):
            reason = "追加コメントの途中にコメント記号があり、コードが紛れる恐れがある"
            continue

        # 4. 追加場所は、先頭のヘッダーコメントの直後（コードより前）か
        before = [line.decode("utf-8").strip() for line in cur[:i]]
        if any(t != "" and not t.startswith("//") for t in before):
            reason = "追加場所がコードの途中になっている"
            continue

        return True, f"コメント {added_count} 行の追加のみ（既存 {len(orig)} 行は完全一致）", added_count

    return False, reason, added_count


def main() -> int:
    manifest = load_manifest()
    ok_count = 0
    ng_count = 0

    print("=== 先頭コメント追加の検証（既存コードが書き換わっていないこと） ===\n")
    for rel in sorted(manifest):
        ok, message, _ = check_file(rel, manifest[rel])
        mark = "✅ OK" if ok else "❌ NG"
        print(f"{mark}  {rel}\n        {message}")
        if ok:
            ok_count += 1
        else:
            ng_count += 1

    # スナップショット取得後に増えたSwiftファイル（参考情報。NGにはしない）
    current = {p.relative_to(ROOT).as_posix() for p in SOURCE_DIR.rglob("*.swift")}
    new_files = sorted(current - set(manifest))
    if new_files:
        print("\n（参考）スナップショットの後に追加されたSwiftファイル:")
        for rel in new_files:
            print(f"        {rel}")

    print(f"\n合計 {ok_count + ng_count} ファイル / OK {ok_count} / NG {ng_count}")
    if ng_count == 0:
        print("結果: OK ― 既存のコードは1バイトも書き換わっていません")
        return 0
    print("結果: NG ― 上の ❌ のファイルを確認してください")
    return 1


if __name__ == "__main__":
    sys.exit(main())
