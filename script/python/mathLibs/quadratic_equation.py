import argparse
from decimal import *
from eth_abi import encode

def solve_quadratic_equation(args):
    getcontext().prec = 180
    a = Decimal(args.a) / Decimal(1e18) / Decimal(1e18)
    b = Decimal(args.b) / Decimal(1e18) / Decimal(1e18)
    c = Decimal(args.c) / Decimal(1e18) / Decimal(1e18)
    if (args.c_negative > 0): c = -c

    flag = 0
    result = 0

    b_sq = b * b
    four_a_c = Decimal(4) * a * c
    sqrt_term = b_sq - four_a_c
    if sqrt_term < 0: 
        flag = 1
    else:
        result = (sqrt_term.sqrt() - b) / (Decimal(2) * a)
        if (result < 0): 
            flag = 2
            result = 0
        else:
            result = int(result * Decimal(1e18) * Decimal(1e18))
    enc = encode(["(uint256,uint256)"], [(result, flag)])
    print("0x" + enc.hex(), end="")

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("a", type=int)
    parser.add_argument("b", type=int)
    parser.add_argument("c", type=int)
    parser.add_argument("c_negative", type=int)
    return parser.parse_args()

def main():
    args = parse_args()
    solve_quadratic_equation(args)


if __name__ == "__main__":
    main()