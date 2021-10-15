
from typing import List
from copy import deepcopy

import numpy as np
import pandas as pd


class NaiveBayes():
    def __init__(self):
        self.labels = []
        self.label_count = {}
        self.vocab = []
        self.vocab_count = {}
        self.data = []

    def add_observations(self, observation: list, label):
        for obs in observation:
            if obs not in self.vocab_count:
                self.vocab_count[obs] = 0
            if label not in self.label_count:
                self.label_count[label] = 0

            self.vocab_count[obs] += 1
            self.label_count[label] += 1

            self.vocab.append(obs)
            self.labels.append(label)

            self.data.append((obs, label))

    def load_data(self, data):
        for observation, label in data:
            self.add_observations(observation, label)

    def class_prior(self, label):
        return self.label_count[label] / sum(self.label_count.values())

    def pred_prior(self, observation):
        """
            Calculate prior of the predictor.
        """
        res = 0
        for word in self.vocab:
            if word == observation:
                res += 1
        return res/len(self.vocab)

    def likelihood(self, observation, label):
        """
            Calculate likelihood (probability of the predictor given a label).
        """
        res = 0
        for pair in self.data:
            if pair == (observation, label):
                res += 1
        return res/self.label_count[label]

    def print_class_prior(self, label):
        res = self.class_prior(label)
        num_label = self.label_count[label]
        num_labels = sum(self.label_count.values())
        print(f"{label} : {num_label} / {num_labels} = {res}")

    def print_pred_prior(self, observation):
        res = 0
        for word in self.vocab:
            if word == observation:
                res += 1
        print(f"{observation} : {res} / {len(self.vocab)} = {res/len(self.vocab)}")

    def print_likelihood(self, observation, label):
        res = 0
        for pair in self.data:
            if pair == (observation, label):
                res += 1
        print(
            f"{observation}|{label} = {res} / {self.label_count[label]} = {res/self.label_count[label]}")

    def prediction_prob(self, observation, label):
        res = 1
        for word in observation:
            res *= self.likelihood(word, label) * \
                self.pred_prior(word)/self.class_prior(label)
        return res


def p1():
    nb = NaiveBayes()
    nb.load_data([
        [["chinese", "beijing", "chinese"], "B"],
        [["chinese", "chinese", "shanghai"], "B"],
        [["tokyo", "japan", "chinese"], "A"],
        [["chinese", "macao"], "B"]])

    test = ["chinese", "chinese", "chinese", "tokyo", "japan"]

    # print prior of each label
    for label in set(nb.labels):
        nb.print_class_prior(label)

    # print prior of each word
    for word in set(test):
        nb.print_pred_prior(word)

    # print likelihood of each word for each label
    for label in set(nb.labels):
        for word in set(test):
            nb.print_likelihood(word, label)

    print("P(A|['test'] = P(A|chinese)^3*P(A|tokyo)*P(A|japan)")
    print(nb.prediction_prob(test, "A"))

    print("P(B|['test'] = P(B|chinese)^3*P(B|tokyo)*P(B|japan)")
    print(nb.prediction_prob(test, "B"))


def preprocess(data: List[str]):
    # take each sentence and split it into words
    corpus = [sentence.split() for sentence in data]

    # remove punctuation
    corpus = [[word.strip(".,") for word in sentence] for sentence in corpus]

    # put each word in lowercase
    corpus = [[word.lower() for word in sentence] for sentence in corpus]

    return corpus


def create_vocab(corpus: List[List[str]]):
    vocab = []
    for sentence in corpus:
        for word in sentence:
            if word not in vocab:
                vocab.append(word)
    return sorted(vocab)


def calc_tf_vector(corpus: List[List[str]], vocab: List[str]):
    """
        Calculate term frequency vector for each sentence.
    """
    tf_vector = []
    for sentence in corpus:
        tf_vector.append([])
        for word in vocab:
            tf_vector[-1].append(sentence.count(word))
    return tf_vector


def calc_idf_vector(corpus: List[List[str]], vocab: List[str]):
    """
        Calculate inverse document frequency vector for each sentence.
    """
    total_sentences = len(corpus)
    idf_vector = []
    for term in vocab:
        count = 0
        for sentence in corpus:
            if term in sentence:
                count += 1
        idf_vector.append(np.round(np.log10(total_sentences/count), 3))
    return idf_vector


def calc_tf_idf_vector(tf_vector: List[List[float]], idf_vector: List[float]):
    """
        Calculate tf-idf vector for each sentence.
    """
    tf_idf_vector = deepcopy(tf_vector)
    for i in range(len(tf_idf_vector)):
        for j in range(len(tf_idf_vector[i])):
            tf_idf_vector[i][j] = tf_idf_vector[i][j] * idf_vector[j]
    return tf_idf_vector


def p2():
    corpus = [
        "It is going to rain today.",
        "Today I am not going outside.",
        "NLP is an interesting topic.",
        "NLP includes ML, DL topics too.",
        "I am not going to play football today.",
    ]

    # preprocess
    corpus = preprocess(corpus)

    # create vocabulary
    vocab = create_vocab(corpus)

    # create term frequency vector
    tf_vector = calc_tf_vector(corpus, vocab)

    # create inverse document frequency vector
    idf_vector = calc_idf_vector(corpus, vocab)

    # create tf-idf vector
    tf_idf_vector = calc_tf_idf_vector(tf_vector, idf_vector)

    # create dataframe to show each vector
    cols = [f"tf_d{i}" for i in range(
        len(tf_vector))] + ["idf"] + [f"tf_idf_d{i}" for i in range(len(tf_idf_vector))]

    # show tf-idf vector
    df = pd.DataFrame([], index=vocab, columns=cols)

    for i in range(len(vocab)):
        word = vocab[i]
        for j in range(len(tf_vector)):
            df.loc[word, f"tf_d{j}"] = tf_vector[j][i]

    df.loc[:, "idf"] = idf_vector

    for i in range(len(vocab)):
        word = vocab[i]
        for j in range(len(tf_idf_vector)):
            df.loc[word, f"tf_idf_d{j}"] = tf_idf_vector[j][i]

    print(df)
    print(tf_vector[1])

    df.to_latex("tf_idf.tex")


if __name__ == '__main__':
    # p1()
    p2()
