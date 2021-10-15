import re


def unigram(corpus: str):
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
        res.append(f"p({token}) & ${probability}$ \\\\")
        res.append("\\hline")

    with open('./tex/assets/test1/unigram.tex', 'w') as f:
        f.write("\\begin{tabular}{|l|l|}\n")
        f.write("\\hline\n")
        f.write("\n".join(res))
        f.write("\n\\end{tabular}")


def bigram(corpus: str):
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
        # only use tokens that don't start with 'begin'
        if not re.match(r'^begin', token):
            res.append(f"p({token}) & ${probability}$ \\\\")
            res.append("\\hline")

    with open('./tex/assets/test1/bigram.tex', 'w') as f:
        f.write("\\begin{tabular}{|l|l|}\n")
        f.write("\\hline\n")
        f.write("\n".join(res))
        f.write("\n\\end{tabular}")


if __name__ == "__main__":
    p1 = """a a b c d b f
        b c h a d f f a h
        b b a a h c c h d d f
        a b f f c c d f h
        h h f f c a c d d d"""

    p2 = """begin a a b c d b f end
        begin b c h a d f f a h end
        begin b b a a h c c h d d f end
        begin a b f f c c d f h end
        begin h h f f c a c d d d end"""
    unigram(p1)
    bigram(p2)
