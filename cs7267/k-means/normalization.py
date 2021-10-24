# File: normalization.py
# Noah Gardner
# 9/17/2020

# package
import numpy as np


def min_max_normalization(data: np.array, new_min: float, new_max: float):
    '''
        Input:
            data: numpy array to normalize

        Returns:
            data: min-max normalized input
            col_min: array with the original min for each column
            col_max: array with the original max for each column
    '''
    try:
        rows = data.shape[0]
        cols = data.shape[1]
    except Exception as e:
        print(f'error normalizing data: {e}')
        raise e

    col_min = np.min(data, axis=0)
    col_max = np.max(data, axis=0)

    for col in cols:
        amin = col_min[col]
        amax = col_max[col]
        for i in range(len(data[col])):
            d = (data[col][i]-amin)/(amax-amin)
            d = d*(new_max-new_min)+new_min
            data[col][i] = d
    return data, col_min, col_max


def inverse_min_max(data: np.array, col_min: list, col_max: list):
    '''
        Input:
            data: numpy array to normalize

        Returns:
            data: min-max normalized input
            col_min: array with the original min for each column
            col_max: array with the original max for each column
    '''
    try:
        rows = data.shape[0]
        cols = data.shape[1]
    except Exception as e:
        print(f'error normalizing data: {e}')
        return data

    for col in cols:
        new_min = col_min[col]
        new_max = col_max[col]
        for i in range(len(data[col])):
            d = (data[col][i]-col_min)/(col_max-col_min)
            d = d*(new_max-new_min)+new_min
            data[col][i] = d

    return data


def z_score_normalization(data: np.array):
    '''
        Input:
            data: numpy array to normalize
        Returns:
            data: z-score normalized input
            col_mean: array with the original mean for each column
            col_std: array with the original std deviation for each column
    '''
    try:
        rows = data.shape[0]
        cols = data.shape[1]
    except Exception as e:
        print(f'error normalizing data: {e}')
        raise e

    col_mean = np.mean(data, axis=0)
    col_std = np.std(data, axis=0)
    for col in range(cols):
        mean = col_mean[col]
        std = col_std[col]
        for row in range(rows):
            d = (data[row][col]-mean)/(std)
            data[row][col] = d

    return data, col_mean, col_std


def inverse_z_score(data: np.array, col_mean: np.array, col_std: np.array):
    '''
        Input:
            data: z-score normalized input
            col_mean: array with the original mean for each column
            col_std: array with the original std deviation for each column
        Returns:
            data: inversed normalized data
    '''
    try:
        rows = data.shape[0]
        cols = data.shape[1]
    except Exception as e:
        print(f'error normalizing data: {e}')
        raise e

    for col in range(cols):
        mean = col_mean[col]
        std = col_std[col]
        for row in range(rows):
            d = (data[row][col]*std)+mean
            data[row][col] = d

    return data
