import argparse
import csv
from util.parce_input_array import get_array_from_input
from plot_csv import plot_csv

def write_vars_to_csv(args):
    vars = get_array_from_input(args.vars_raw)
    file_name = args.file_name
    names = get_array_from_input(args.col_names_raw)
    if(len(vars)!= len(names)):
        print("Error: number of vars and column names must be equal")
        return

    with open(f"csv/{file_name}.csv", "a+") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(vars)
        csvfile.close()

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("vars_raw", type=str)
    parser.add_argument("col_names_raw", type=str)
    parser.add_argument("file_name", type=str)

    return parser.parse_args()


def main():
    args = parse_args()
    write_vars_to_csv(args)


if __name__ == "__main__":
    main()