import argparse
from decimal import *
from math import log
from float_utils import normalize_and_print


def calculate_last_revenue_claim(args):
    getcontext().prec = 200
    hn = Decimal(args.hn) / Decimal(1e18) 
    wj = Decimal(args.wjMan) * (10 ** args.wjExp) if args.wjExp >= 0 else Decimal(args.wjMan) / (10 ** -args.wjExp)
    r_hat = Decimal(args.r_hat) / Decimal(1e18)
    w_hat = Decimal(args.w_hat) / Decimal(1e18)

    return ((hn * wj) + (r_hat * w_hat)) / Decimal((w_hat + wj))


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("wjMan", type=int)
    parser.add_argument("wjExp", type=int)
    parser.add_argument("hn", type=int)
    parser.add_argument("r_hat", type=int)
    parser.add_argument("w_hat", type=int)
    
    return parser.parse_args()


def main():
    args = parse_args()
    result = calculate_last_revenue_claim(args)
    normalize_and_print(result)


if __name__ == "__main__":
    main()