import fibertools as ft
import argparse
import logging
import sys
import re
import numpy as np
from functools import partial
import os
import dask.dataframe as dd
from dask.multiprocessing import get
from multiprocessing import Pool
import pandas as pd
from numba import njit

MOTIFS = [("GAATTC", [2, 3]), ("GATC", [1, 2]), ("TCGA", [1, 2])]
MOTIFS = ["GAATTC", "GATC", "TCGA"]


def parse():
    """Console script for fibertools."""
    parser = argparse.ArgumentParser(
        description="", formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument(
        "tbl", nargs="+", help="fibertools-rs all table"
    )
    parser.add_argument("-n", default=None, type=int)
    parser.add_argument("-b", default=0, type=int)
    # parser.add_argument("-o", "--out", help="Output bam file.", default=sys.stdout)
    parser.add_argument(
        "-v", "--verbose", help="increase logging verbosity", action="store_true"
    )
    args = parser.parse_args()
    log_format = "[%(levelname)s][Time elapsed (ms) %(relativeCreated)d]: %(message)s"
    log_level = logging.DEBUG if args.verbose else logging.WARNING
    logging.basicConfig(format=log_format, level=log_level)
    return args


def get_stats(row, buffer=0, motifs=None):
    seq = np.frombuffer(bytes(row.fiber_sequence, "utf-8"), dtype="S1")
    mask = np.zeros(seq.shape)
    # for motif in motifs:
    # search = "|".join(["(" + motif + ")" for motif in motifs])
    # search = "|".join(["(?=" + motif + ")" for motif in motifs])
    search = "|".join(motifs)
    if motifs[0] == "All-AT-bp":
        mask[0:mask.shape[0]] = 1
    else:
        for m in re.finditer(search, row.fiber_sequence):
            s = m.start()
            e = m.end()
            if s == e:
                continue
            # only set m6A positions
            if len(m.group()) == 6:
                mask[s + 2 : e - 2] = 1
            else:
                mask[s:e] = 1

    if row.m6a is None:
        m6a = np.array([], dtype=int)
        # return None
    else:
        m6a = np.array(row.m6a)
    is_at = (seq == b"A") | (seq == b"T")
    # set motif values not AT to zero
    mask[~is_at] = 0
    row["on_target"] = (mask[m6a] == 1).sum()
    row["off_target"] = (mask[m6a] == 0).sum()
    row["total_targets"] = mask.sum()
    # row["motif_at_count"] = motif_at_count
    # row["at_count"] = at_count
    row["motif_at_count"] = (seq[mask == 1] == b"A").sum() + (
        seq[mask == 1] == b"T"
    ).sum()
    row["at_count"] = (seq == b"A").sum() + (seq == b"T").sum()
    sys.stderr.write(f"\r{row.st}")
    return row


def by_table(inputs, buffer=0, n_rows=None):
    tbl, m = inputs
    sys.stderr.write(f"Reading {tbl} for {m}")

    fd = ft.read_fibertools_rs_all_file(tbl, pandas=True, n_rows=n_rows)
    # ddata = dd.from_pandas(fd, npartitions=30)
    rtn=""
    helper_fun = partial(get_stats, buffer=buffer, motifs=m)
    results = fd.apply(helper_fun, axis=1)
    # results = ddata.map_partitions(
    #    lambda df: df.apply(helper_fun, axis=1)
    # ).compute()

    sys.stderr.write("\n")
    on_target = results.on_target.sum()
    off_target = results.off_target.sum()
    motif_at_count = results.motif_at_count.sum()
    at_count = results.at_count.sum()
    total_targets = results.total_targets.sum()
    on_target_rate = on_target / (on_target + off_target)
    
    rtn +=(f"{os.path.basename(tbl)}"
        + f"\t{';'.join(m)}"
        + f"\t{on_target_rate:.3%}"
        + f"\t{on_target/total_targets:.3%}"
        + f"\t{motif_at_count / at_count:.3%}"
        + f"\t{total_targets:,}"
        + f"\t{fd.total_m6a_bp.sum()/fd.total_AT_bp.sum():.3%}"
        + f"\t{fd.total_m6a_bp.sum()}\n")
    return rtn

def main():
    args = parse()
    print(
        f"file\tmotif(s)\tm6A-within-motif(s)"
        + "\tmotif(s)-covered-by-m6A\tAT-bases-covered-by-motif(s)\t#-of-motifs"
        + "\tm6A-coverage"
        + "\t#-of-m6A-bp"
    )
    combos = [] 
    for tbl in args.tbl:
        for m in ["All-AT-bp"] + [MOTIFS] + MOTIFS:
            if type(m) != list:
                m = [m]
            combos.append((tbl, m))
    #print(combos)

    with Pool(8) as p:
        helper_by_table = partial(by_table, buffer=args.b, n_rows=args.n)
        for s in p.map(helper_by_table, combos):
            print(s)

    return 0


if __name__ == "__main__":
    main()
