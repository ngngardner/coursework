"""Scripts for solving problems on Test 2."""

import nltk
from nltk.translate.bleu_score import sentence_bleu
from nltk.tokenize import word_tokenize
from rich.console import Console

console = Console()


def problem3():
    """Solve bleu score for candidates up to order N=2."""
    r1 = 'It is a guide to action that ensures that the military will forever heed Party commands.'
    r2 = 'It is the guiding principle which guarantees the military forces always being under the command of the Party.'
    r3 = 'It is the practical guide for the army always to heed the directions of the party.'

    c1 = 'It is a guide to action which ensures that the military always obeys the commands of the party.'
    c2 = 'It is to ensure the troops forever hearing the activity guidebook that party direct.'

    refs = [r1, r2, r3]
    cands = [c1, c2]
    refs = [word_tokenize(ref) for ref in refs]
    cands = [word_tokenize(cand) for cand in cands]

    for ref in refs:
        console.log('Reference: {0}'.format(ref))
        for cand in cands:
            uscore = sentence_bleu([ref], cand, weights=(1, 0, 0, 0))
            bscore = sentence_bleu([ref], cand, weights=(0, 1, 0, 0))
            console.log(
                'U {0:.2f} - B {1:.2f} - C {2}'.format(uscore, bscore, cand))
            geomean = (uscore * bscore) ** 0.5
            console.log('Mean {0:.2f}'.format(geomean))

    # all refs
    console.log('----------------------------------------')
    console.log('All references:')
    console.log('----------------------------------------')
    for cand in cands:
        uscore = sentence_bleu(refs, cand, weights=(1, 0, 0, 0))
        bscore = sentence_bleu(refs, cand, weights=(0, 1, 0, 0))
        console.log(
            'U {0:.2f} - B {1:.2f} - C {2}'.format(uscore, bscore, cand))
        geomean = (uscore * bscore) ** 0.5
        console.log('Mean {0:.2f}'.format(geomean))


def problem5():
    """Calculate ROUGE-1 and ROUGE-2 for both summaries."""
    s1 = """
        neymar scored his side’s second goal with a curling free kick, and 15
        minutes to play in the 2-2 draw at sevilla on saturday night, according
        to reports in spain.
    """
    s2 = """
        barcelona’s neymar substituted in 2-2 draw at sevilla on saturday night,
        spain’s kamui kobayashi claims a late free kick in the champions league
        after his second goal with the score
    """
    ref = """
        neymar was taken off with barcelona 2-1 up against sevilla. the brazil
        captain was visibly angry, and barca went on to draw 2-2. neymar has
        been replaced 15 times in 34 games this season. click here for all the
        latest barcelona news.
    """
    # tokenize
    tokenizer = nltk.RegexpTokenizer(r'\w+')
    s1_unigrams = tokenizer.tokenize(s1)
    s2_unigrams = tokenizer.tokenize(s2)
    ref_unigrams = tokenizer.tokenize(ref)

    s1_bigram = list(nltk.bigrams(s1_unigrams))
    s2_bigram = list(nltk.bigrams(s2_unigrams))
    ref_bigram = list(nltk.bigrams(ref_unigrams))

    # rouge-1
    console.log('----------------------------------------')
    console.log('ROUGE-1')
    console.log('----------------------------------------')
    console.log('{0}'.format(ref_unigrams))
    console.log('----------------------------------------')
    # s1
    console.log('S1:')
    console.log('{0}'.format(s1_unigrams))
    # precision
    s1_overlap = set(s1_unigrams).intersection(ref_unigrams)
    console.log('Overlap: {0}'.format(len(s1_overlap)))
    s1_precision = len(s1_overlap) / len(s1_unigrams)
    console.log('Precision: {0:.2f}'.format(s1_precision))
    s1_recall = len(s1_overlap) / len(ref_unigrams)
    console.log('Recall: {0:.2f}'.format(s1_recall))
    s1_f1 = 2 * (s1_precision * s1_recall) / (s1_precision + s1_recall)
    console.log('F1: {0:.2f}'.format(s1_f1))

    # s2
    console.log('S2:')
    console.log('{0}'.format(s2_unigrams))
    # precision
    s2_overlap = set(s2_unigrams).intersection(ref_unigrams)
    console.log('Overlap: {0}'.format(len(s2_overlap)))
    s2_precision = len(s2_overlap) / len(s2_unigrams)
    console.log('Precision: {0:.2f}'.format(s2_precision))
    s2_recall = len(s2_overlap) / len(ref_unigrams)
    console.log('Recall: {0:.2f}'.format(s2_recall))
    s2_f1 = 2 * (s2_precision * s2_recall) / (s2_precision + s2_recall)
    console.log('F1: {0:.2f}'.format(s2_f1))

    # rouge-2
    console.log('----------------------------------------')
    console.log('ROUGE-2')
    console.log('----------------------------------------')
    console.log('{0}'.format(ref_bigram))
    console.log('----------------------------------------')

    # s1
    console.log('S1:')
    console.log('{0}'.format(s1_bigram))
    # precision
    s1_overlap = set(s1_bigram).intersection(ref_bigram)
    console.log('Overlap: {0}'.format(len(s1_overlap)))
    s1_precision = len(s1_overlap) / len(s1_bigram)
    console.log('Precision: {0:.2f}'.format(s1_precision))
    s1_recall = len(s1_overlap) / len(ref_bigram)
    console.log('Recall: {0:.2f}'.format(s1_recall))
    s1_f1 = 2 * (s1_precision * s1_recall) / (s1_precision + s1_recall)
    console.log('F1: {0:.2f}'.format(s1_f1))

    # s2
    console.log('S2:')
    console.log('{0}'.format(s2_bigram))
    # precision
    s2_overlap = set(s2_bigram).intersection(ref_bigram)
    console.log('Overlap: {0}'.format(len(s2_overlap)))
    s2_precision = len(s2_overlap) / len(s2_bigram)
    console.log('Precision: {0:.2f}'.format(s2_precision))
    s2_recall = len(s2_overlap) / len(ref_bigram)
    console.log('Recall: {0:.2f}'.format(s2_recall))
    s2_f1 = 2 * (s2_precision * s2_recall) / (s2_precision + s2_recall)
    console.log('F1: {0:.2f}'.format(s2_f1))


if __name__ == '__main__':
    problem5()
