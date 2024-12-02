import subprocess
import argparse

valid_equations = ["CofN", "VofN", "priceFunction_fx", "LofN", "FofX", "Singularity", "ZofN", "CConstant", "SigmaSq", "Finversed"]
test_base = ["forge", "test", "--ffi", "--optimize", "--optimizer-runs", "200", "--match-test"]

def enable_tests(enable, file_name):
    print("Opening file: ", file_name)
    with open(file_name, 'r') as file: filedata = file.read()
    if(enable): filedata = filedata.replace('vm.skip(true)', 'vm.skip(false)')
    else: filedata = filedata.replace('vm.skip(false)', 'vm.skip(true)')
    with open(file_name, 'w') as file: file.write(filedata)

def run_logger(equation):
    subprocess.run([*test_base,f"testEquations_{equation}PrecisionLogger"])

def run_plotter(equation):
    subprocess.run([*test_base,f"testEquations_{equation}PrecisionPlotter"])

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("equation", type=str)
    return parser.parse_args()

def validate_equation(_equation):
    if _equation in valid_equations: return True
    else: return False 

def main():
    args = parse_args()
    equation = args.equation
    curve = args.curve
    if(validate_equation(equation)):
        file_name = f"test/equations/{curve}/{equation}/{equation}PrecisionLogger.sol"
        enable_tests(True, file_name)
        print("enabled tests")
        print("runing logger...")
        run_logger(equation)
        print("logger done")
        print("plotting")
        run_plotter(equation)
        print("disabling tests")
        enable_tests(False, file_name)
        print("done")
    else:
        print("invalid equation. The valid equations are:")
        msg = "\n - ".join(valid_equations)
        msg = " - " + msg
        print(msg)
        

if __name__ == "__main__":
    main()