
import re

import pandas as pd
import numpy as np
from Levenshtein import distance


def print_match(example, pattern):
    print(f'{example} matches {pattern}') \
        if re.match(pattern, example) \
        else print(f'{example} does not match {pattern}')


def regex_1():
    """
        Match all binary strings.
    """
    examples = ['1001', '1011', '1111']
    pattern = r'^[01]+$'
    for example in examples:
        print_match(example, pattern)


def regex_2():
    """
        Match all email addresses which contain only letters, @, and \. Symbols
        (both lower and upper cases).
    """
    examples = ['alice@gmail.com', 'bob@yahoo.com']
    pattern = r'^[a-zA-Z0-9]+[@][a-zA-Z0-9]+\.[a-zA-Z0-9]+$'
    for example in examples:
        print_match(example, pattern)


def regex_3():
    """
        Match valid integer numbers.
    """
    examples = ['123', '-123', '+123', '0', '-0', '+0']
    pattern = r'^[-+]?[0-9]+$'
    for example in examples:
        print_match(example, pattern)


def regex_4():
    """
        Match valid phone numbers that only contain 10 digits.

        Formats: xxx-xxx-xxxx, (xxx)xxx-xxxx
    """
    examples = ['453-126-4570', '(453)126-4570']
    pattern = r'^\([0-9]{3}\)[0-9]{3}-[0-9]{4}$|^[0-9]{3}-[0-9]{3}-[0-9]{4}$'
    for example in examples:
        print_match(example, pattern)


def problem_1():
    regex_1()
    regex_2()
    regex_3()
    regex_4()


def tokenize_1(example: str):
    """
        Tokenize a string of words.
    """
    pattern = r'\w+'
    print(re.findall(pattern, example))


def vocabulary_1(example: str):
    """
        Count the number of words in a string.
    """
    pattern = r'\w+'
    print(len(re.findall(pattern, example)))


def types_1(example: str):
    """
        Count the number of words in a string.
    """
    pattern = r'\w+'
    print(len(set(re.findall(pattern, example))))


def problem_2():
    example = 'The quick brown fox jumps over the lazy dog.'.lower()
    tokenize_1(example)
    vocabulary_1(example)
    types_1(example)


def distance_matrix(s1: str, s2: str):
    """
        Create the min edit distance matrix between two strings.
    """
    m = np.zeros((len(s1) + 1, len(s2) + 1), dtype=int)

    for i in range(1, len(s1) + 1):
        m[i, 0] = i

    for j in range(1, len(s2) + 1):
        m[0, j] = j

    m_str = np.array(m, dtype=object)

    for i in range(1, len(s1) + 1):
        for j in range(1, len(s2) + 1):
            if s1[i - 1] == s2[j - 1]:
                m[i, j] = f"{m[i - 1, j - 1]}"
            else:
                cost = 0
                if s1[i-1] != s2[j-1]:
                    cost = 2
                m[i, j] = min(
                    m[i - 1, j - 1] + cost,
                    m[i - 1, j] + 1,
                    m[i, j - 1] + 1)

    for i in range(1, len(s1) + 1):
        for j in range(1, len(s2) + 1):
            # add arrows
            prepend = "$"
            if m[i - 1, j - 1] <= m[i, j]:
                prepend += "\\nwarrow"
            if m[i - 1, j] <= m[i, j]:
                prepend += "\\uparrow"
            if m[i, j - 1] <= m[i, j]:
                prepend += "\\leftarrow"

            m_str[i, j] = f"{prepend}${m[i, j]}"

    return m, m_str


def distance_1(s1: str, s2: str):
    """
        Create the min edit distance matrix between two strings.
    """
    m, _ = distance_matrix(s1, s2)

    # turn matrix into a dataframe with s1 as the index and s2 as the columns
    df = pd.DataFrame(m, index=list("#"+s1), columns=list("#"+s2), dtype=str)
    print(df)

    # save dataframe to latex table
    df.to_latex('./Homework_1/edit_dist.tex')


def distance_2(s1: str, s2: str):
    """
        Create the min edit distance matrix between two strings using
        backtracing.
    """
    _, m_str = distance_matrix(s1, s2)

    # turn matrix into a dataframe with s1 as the index and s2 as the columns
    _default = ["*"]
    df = pd.DataFrame(m_str,
                      index=_default + list(s1),
                      columns=_default + list(s2),
                      dtype=str)
    print(df)

    # split dataframe in half by column
    df_left = df.iloc[0:, :len(s2)//2+2]
    df_right = df.iloc[0:, len(s2)//2+2:]

    # save dataframe to latex table
    df_left.to_latex('./Homework_1/edit_dist_bt_left.tex', escape=False)
    df_right.to_latex('./Homework_1/edit_dist_bt_right.tex', escape=False)


def problem_4():
    s1 = 'Spokesman confirms'
    s2 = 'Spokeswoman said'

    # add padding
    while len(s2) < len(s1):
        s2 += ' '

    print(f"{s1}: {len(s1)}")
    print(f"{s2}: {len(s2)}")
    distance_1(s1, s2)
    distance_2(s1, s2)


def unigram_1(corpus: str):
    """
        Build unigram model from the text.
    """
    # tokenize
    pattern = r'\w+'
    tokens = re.findall(pattern, corpus)

    # create a dictionary of all possible words
    words = {token: 0 for token in tokens}
    total = 0
    for token in tokens:
        words[token] += 1
        total += 1

    # create a dictionary of probabilities sorted alphabetically
    probabilities = {token: f"{words[token]}/{total}" for token in words}
    probabilities = sorted(probabilities.items())

    # output the probabilities as latex entries to a latex file
    res = []
    for token, probability in probabilities:
        res.append(f"\item[p({token}) =] ${probability}$")

    with open('./Homework_1/unigram.tex', 'w') as f:
        f.write("\\begin{enumerate}\n")
        f.write("\n".join(res))
        f.write("\n\\end{enumerate}")


def bigram_1(corpus: str):
    """
        Build a bigram model from the text.
    """
    def probability(token_1: str, token_2: str, tokens: list):
        """
            Calculate the probability of token 2 given token 1
        """
        # get the number of times the bigram occurs
        count = 0
        for i in range(1, len(tokens)):
            if tokens[i] == token_1 and tokens[i - 1] == token_2:
                count += 1

        # get the number of times token 1 occurs
        total = 0
        for i in range(len(tokens)):
            if tokens[i] == token_2:
                total += 1

        return count, total

    # tokenize
    pattern = r'\w+'
    tokens = re.findall(pattern, corpus)

    # create a dictionary of all possible words
    temp = {}
    for token_1 in tokens:
        for token_2 in tokens:
            count, total = probability(token_1, token_2, tokens)
            if count > 0 and total > 1:
                temp[f"{token_1}$|${token_2}"] = f"{count}/{total}"

    # sort the dictionary alphabetically
    probabilities = sorted(temp.items())

    # output the probabilities as latex entries to a latex file
    res = []
    for token, probability in probabilities:
        res.append(f"\item[p({token}) =] ${probability}$")

    with open('./Homework_1/bigram.tex', 'w') as f:
        f.write("\\begin{enumerate}\n")
        f.write("\n".join(res))
        f.write("\n\\end{enumerate}")


def problem_5():
    corpus = """The day was grey and bitter cold, and the dogs would
                  not take the scent. The big black bitch had taken one sniff at
                  the bear tracks, backed off, and skulked back to the pack with
                  her tail between her legs.""".lower()
    unigram_1(corpus)
    bigram_1(corpus)


def perplexity_1():
    """
        You are given a training set of 30 numbers that consists of 21 zeros and
        1 each of theother digits 1-9.  Now we see the following test set:  0 0
        0 0 0 3 0 0 0 0.  What is the unigram perplexity?
    """
    training_set = [0 for i in range(21)] + [1 for i in range(9)]
    test_set = [0 for i in range(5)] + [3] + [0 for i in range(4)]

    # create a dictionary of all possible words
    words = {}
    for i in range(10):
        words[str(i)] = i


def problem_6():
    perplexity_1()


if __name__ == '__main__':
    problem_1()
    problem_2()
    problem_4()
    problem_5()
