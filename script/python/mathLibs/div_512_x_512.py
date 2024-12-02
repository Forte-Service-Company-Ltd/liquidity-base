import argparse
from eth_abi import encode
import math

def calculate_div_512_x_512(args):
    a0 = int(args.a0) 
    a1 = int(args.a1) 
    b0 = int(args.b0) 
    b1 = int(args.b1) 

    word = int(2) ** int(256)
    numerator = (a1 * int(word)) + a0
    denominator = (b1 * int(word)) + b0
    result = int(int(numerator) // int(denominator))
    enc = encode(["uint256"], [result])
    print("0x" + enc.hex(), end="")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("a0", type=int)
    parser.add_argument("a1", type=int)
    parser.add_argument("b0", type=int)
    parser.add_argument("b1", type=int)
    return parser.parse_args()


def main():
    args = parse_args()
    calculate_div_512_x_512(args)


if __name__ == "__main__":
    main()