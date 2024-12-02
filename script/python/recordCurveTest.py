import argparse
import csv

def write_to_csv(args):
    i = args.i
    x = args.x
    slope = args.slope
    y_intersect = args.y_intersect
    id = args.id

    with open(f"csv/curve_data_{id}.csv", "a+") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow([i, x, slope, y_intersect])
        csvfile.close()

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("i", type=int)
    parser.add_argument("x", type=int)
    parser.add_argument("slope", type=int)
    parser.add_argument("y_intersect", type=int)
    parser.add_argument("id", type=int)
    return parser.parse_args()


def main():
    args = parse_args()
    write_to_csv(args)


if __name__ == "__main__":
    main()