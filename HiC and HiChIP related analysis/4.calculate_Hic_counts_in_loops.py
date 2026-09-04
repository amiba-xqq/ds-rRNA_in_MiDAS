#!/usr/bin/env python3
import sys
import gzip
import argparse
from collections import defaultdict
from tqdm import tqdm

def main():
    parser = argparse.ArgumentParser(description="统计Hi-C pairs在扩展loop区域内的contacts数量")
    parser.add_argument("pairs_gz", help="输入的pairs.gz文件路径")
    parser.add_argument("input_bedpe", help="输入的bedpe文件路径（两端5kb）")
    parser.add_argument("output_bedpe", help="输出的带计数的bedpe文件路径")
    args = parser.parse_args()

    # 读取pairs文件，仅保留intra-chromatin contacts
    chrom_pairs = defaultdict(lambda: ([], []))
    print("读取pairs.gz文件...")
    with gzip.open(args.pairs_gz, 'rt') as f:
        for line in tqdm(f, desc="Processing pairs", unit="lines"):
            if line.startswith("#") or line.strip() == "":
                continue
            cols = line.strip().split()
            if len(cols) < 7:
                continue
            # 格式: ID chr1 start1 strand1 chr2 start2 strand2
            chr1, start1, chr2, start2 = cols[1], int(cols[2]), cols[4], int(cols[5])
            if chr1 != chr2:
                continue
            chrom_pairs[chr1][0].append(start1)
            chrom_pairs[chr1][1].append(start2)

    # 处理bedpe并写输出
    with open(args.input_bedpe, 'r') as fin, open(args.output_bedpe, 'w') as fout:
        for line in tqdm(fin, desc="Processing bedpe", unit="lines"):
            if line.startswith("#") or line.strip() == "":
                continue
            parts = line.strip().split()
            if len(parts) < 6:
                continue
            chr1, s1, e1, chr2, s2, e2 = parts[0], int(parts[1]), int(parts[2]), parts[3], int(parts[4]), int(parts[5])
            # 扩展到50kb窗口（中心±25000bp）
            c1 = (s1 + e1) // 2
            w1_start = c1 - 25000
            w1_end = c1 + 25000
            c2 = (s2 + e2) // 2
            w2_start = c2 - 25000
            w2_end = c2 + 25000

            count = 0
            if chr1 in chrom_pairs:
                starts1, starts2 = chrom_pairs[chr1]
                for x, y in zip(starts1, starts2):
                    if w1_start <= x <= w1_end and w2_start <= y <= w2_end:
                        count += 1

            fout.write(f"{chr1}\t{s1}\t{e1}\t{chr2}\t{s2}\t{e2}\t{count}\n")

    print(f"完成，结果已写入 {args.output_bedpe}")

if __name__ == "__main__":
    main()