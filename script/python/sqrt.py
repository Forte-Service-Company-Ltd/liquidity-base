import argparse
from decimal import *
from math import sqrt

def calculate_sqrt(args):
    getcontext().prec = 45
    x = Decimal(args.x) 
    res = sqrt(x)
    print(int(res))

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("x", type=int)
    return parser.parse_args()


def main():
    args = parse_args()
    calculate_sqrt(args)


if __name__ == "__main__":
    main()