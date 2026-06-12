#!/usr/bin/env python3
"""The exact check from the reel: find invoices that were paid twice.
Usage: python3 find_duplicates.py expenses_q2.csv"""
import csv
import sys
from collections import Counter, defaultdict

path = sys.argv[1] if len(sys.argv) > 1 else "expenses_q2.csv"
with open(path) as f:
    rows = list(csv.DictReader(f))

count = Counter(r["invoice"] for r in rows)
amounts = defaultdict(list)
for r in rows:
    amounts[r["invoice"]].append(float(r["amount_eur"]))

dupes = sorted(k for k, v in count.items() if v > 1)
total = sum(amounts[k][1] for k in dupes)

print(f"rows scanned: {len(rows)}")
for k in dupes:
    print(f"PAID TWICE: {k}  EUR {amounts[k][1]:,.2f}")
print(f"money out the door: EUR {total:,.2f}")

