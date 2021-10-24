# File: distance.py
# Noah Gardner
# 9/17/2020

# package
import numpy as np


def euclidean_distance(p: np.array, c: np.array):
    '''
        Calculate the euclidean distance from a data point to a cluster center.

        Inputs:
            p: the data point to assess distance to cluster center
            c: the cluster center to assess distance to data point

        Returns:
            distance: float of calculated distance
    '''
    distance = np.sqrt(np.sum((p - c) ** 2, axis=0))
    return distance
