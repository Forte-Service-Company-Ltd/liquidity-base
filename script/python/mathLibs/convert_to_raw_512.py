import argparse
from eth_abi import encode

def convert_to_raw(args):
    a0 = int(args.a0) 
    a1 = int(args.a1) 

    word = int(2) ** int(256)
    result = (a1 * word) + a0
    result = int(result) // int(1e18)
    r0 = int(result) % int(word)
    r1 = int(result) // int(word)
    enc = encode(["(uint256,uint256)"], [(r0,r1)])
    print("0x" + enc.hex(), end="")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("a0", type=int)
    parser.add_argument("a1", type=int)
    return parser.parse_args()


def main():
    args = parse_args()
    convert_to_raw(args)


if __name__ == "__main__":
    main()