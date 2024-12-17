import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import argparse
import csv
from decimal import *
from util.parce_input_array import get_array_from_input
from pandas.plotting import parallel_coordinates
import plotly.express as px

def get_labels(names):
    labels = {}
    for name in names:
        if name == "error":
            labels[name] = "Error (expressed as 1/1e18)"
        elif name == "x":
            labels[name] = "x"
        elif name == "C":
            labels[name] = "Constant C"
        elif name == "D":
            labels[name] = "D"
        elif name == "V":
            labels[name] = "V"
        elif name == "AnPositive":
            labels[name] = "AnPositive"
        elif name == "P":
            labels[name] = "Pn"
        elif name == "X":
            labels[name] = "Xn"
        elif name == "L":
            labels[name] = "Ln"
        elif name == "c":
            labels[name] = "Cn"
        elif name == "Z":
            labels[name] = "Zn"
        elif name == "Cconstant":
            labels[name] = "Cconstant"
    return labels

def plot_csv(file_name, names):
    getcontext().prec = 1

    try:
        df = pd.read_csv(f'./csv/{file_name}.csv')
        df.columns = names
    except pd.errors.EmptyDataError:
        df = pd.DataFrame(columns=names)

    for column in names:
        df[column] = df[column].astype(float)
        df[column] = df[column].div(1e18)

    reversion_df = df[df["error"] >= precision] # reversions only
    fig = px.parallel_coordinates(
            reversion_df, color="error",
            color_continuous_scale=px.colors.sequential.Jet,
            labels=get_labels(names),
            range_color=[df["error"].min(), df["error"].max()*1.15],
            title = "Reversions"
        )
    fig.show()

    precision_df = df[df["error"] < precision] # except reversions
    fig = px.parallel_coordinates(
            precision_df, color="error",
            color_continuous_scale=px.colors.sequential.Jet,
            labels=get_labels(names),
            range_color=[df["error"].min(), df["error"].max()*1.15],
            title = "Error vs. Input"
        )
    fig.show()

    

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("file_name", type=str)
    parser.add_argument("col_names_raw", type=str)

    return parser.parse_args()


def main():
    args = parse_args()
    file_name = args.file_name
    names = get_array_from_input(args.col_names_raw)
    plot_csv(file_name, names)


if __name__ == "__main__":
    main()