from decimal import *
from eth_abi import encode

max_digits = 38

def normalize_and_print(result):
    if(type(result) == Decimal):
        log_10 = 0 if result == 0 else Decimal(abs(result)).log10()
        result_digits = int(log_10) + 1
        if (result_digits < 0): result_digits -= 1
        result_exp = Decimal(result_digits - max_digits)
        result_man = int(result*10**(-result_exp))
        enc = encode(["(int256,int256)"], [(int(result_man), int(result_exp))])
        print("0x" + enc.hex(), end="")
    elif(type(result) == list):
        encodeTypes = []
        encodeValues = []
        for _result in result:
            log_10 = 0 if _result == 0 else Decimal(abs(_result)).log10()
            result_digits = int(log_10) + 1
            if (result_digits < 0): result_digits -= 1
            result_exp = Decimal(result_digits - max_digits)
            encodeValues.append(int(result_exp))
            encodeTypes.append("int256")
            result_man = int(_result*10**(-result_exp))
            encodeValues.append(int(result_man))
            encodeTypes.append("int256")
        types = "(" + f"{[*encodeTypes]}"[1: -1].replace(" ","").replace("'","") + ")"
        enc = encode([types], [tuple(encodeValues)])
        print("0x" + enc.hex(), end="")