
import itertools
import pandas as pd

transition = {
    "p": {
        0: "pq",
        1: "p"
    },
    "q": {
        0: "rs",
        1: "t",
    },
    "r": {
        0: "pr",
        1: "t"
    },
    "s": {
        0: None,
        1: None
    },
    "t": {
        0: None,
        1: None
    }
}


def convert_tuple(tup):
    return ','.join(tup)


def get_next_state(s: tuple, i: int):
    """
        Input string can be a set of initial states such as ('p') or ('p', 'q').
        In the case of multiple states, the function will return the next state
        of each substate concatenated.
    """
    if s is None:
        return None

    s = list(s)

    next_state = []
    for state in s:
        temp = transition[state][i]
        if temp is not None:
            for t in temp:
                if t not in next_state:
                    next_state.append(t)

    next_state = tuple(sorted(next_state))
    return convert_tuple(next_state)


def p2():
    symbols = list('pqrst')

    for L in range(0, len(symbols)+1):
        for subset in itertools.combinations(symbols, L):
            t0 = get_next_state(subset, 0)
            t1 = get_next_state(subset, 1)
            _set = convert_tuple(subset)
            print(f"$\{{{_set}\}}$ & $\{{{t0}\}}$ & $\{{{t1}\}}$ \\\\")
            print("\hline")


def p3():
    def find_r(data: pd.DataFrame, i: int, j: int, k: int):
        print(f"i:{i+1}, j:{j+1}")
        res = f"${data.loc[i, j]} + ({data.loc[i, k-1]})({data.loc[k-1, k-1]})^*({data.loc[k-1, j]})$"
        return res

    # table of r_{ij}^k where k = 0
    df_0 = pd.DataFrame([
        ['\epsilon + 1', '0', '\emptyset'],
        ['1', '\epsilon', '0'],
        ['\emptyset', '1', '\epsilon + 0']
    ])

    # table of r_{ij}^k where k = 1
    df_1 = df_0.copy()
    # for i in range(3):
    #     for j in range(3):
    #         print(find_r(df_1, i, j, 1))

    # simplified df_1
    df_1 = pd.DataFrame([
        ['1^*', '1^*0', '\emptyset'],
        ['1^*', '1^*0', '0'],
        ['\emptyset', '1', '\epsilon + 0']
    ])

    # table of r_{ij}^k where k = 2
    df_2 = df_1.copy()
    for i in range(3):
        for j in range(3):
            print(find_r(df_2, i, j, 2))


if __name__ == '__main__':
    p3()
