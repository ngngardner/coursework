# File: ngardn10ClusterBasic.py
# Noah Gardner
# 9/17/2020

# standard
import argparse
import random

# package
import numpy as np

# local
from distance import euclidean_distance
from normalization import z_score_normalization, inverse_z_score
from normalization import min_max_normalization, inverse_min_max

# static variables
MAX_ITER = 4

# command line arguments
parser = argparse.ArgumentParser(description='Run basic k-means clustering.')
parser.add_argument('-i',
                    '--input_file',
                    help='Input file',
                    required=True)
parser.add_argument('-K',
                    '--num_k',
                    help='Number of k',
                    required=True)
parser.add_argument('-c',
                    '--class_attribute',
                    help='Whether to consider the class attribute.')
parser.add_argument('-n',
                    '--normalize',
                    help='Whether to normalize the input data')

args = parser.parse_args()

# load input file from args
input_file = args.input_file

print('loading input file...')
data = np.array((0, 0))
try:
    data = np.genfromtxt(f'data/{input_file}', delimiter=',')
    if not args.class_attribute and data.shape[1] > 2:
        print('not including class attribute...')
        data = data[:, :-1]
except Exception as e:
    print(f'error loading {input_file}: {e}')
    raise e


# load k value from args
try:
    num_k = int(args.num_k)
except Exception as e:
    print(f'error setting k value: {e}')
    raise e


class Cluster:
    def __init__(self, idx: int):
        self.idx = idx
        self.prev_center = None
        self.center = np.empty(data.shape[1])

    def assign_values(self, data: np.array, closest_idx: list):
        '''
            Assigns data from the input data to the cluster if the
                cluster index matches the closest cluster center index

            Inputs:
                data: numpy array of the data
                closest_idx: list of with indexes of the closest cluster
                    centers for each data point
        '''
        self.vector = []
        for i in range(len(closest_idx)):
            if closest_idx[i] == self.idx:
                self.vector.append(data[i])
        self.vector = np.asarray(self.vector)

    def update_center(self):
        self.prev_center = self.center
        if self.vector.size != 0:
            self.center = np.mean(self.vector, axis=0)

    def random_center(self, min: np.array, max: np.array):
        '''
            Inputs:
                min: numpy array with the min values of each column
                max: numpy array with the max values of each column
        '''
        # for each column, select a random value between the min
        # and max value
        for i in range(len(min)):
            self.center[i] = random.uniform(min[i], max[i])


def closest_centroids(data: np.array, clusters: list) -> list:
    '''
        Returns: list of with indexes of the closest cluster centers
            for each data point
    '''
    def closest_centroid_idx(p: np.array, clusters: list):
        '''
            Inputs:
                p: the data point to assess
                clusters: list of Clusters
            Returns:
                idx: index of the closest cluster center as Int

            Calculate the closest cluster center
                and return the index of that centroid.
        '''
        min_distance = euclidean_distance(p, clusters[0].center)
        min_idx = 0
        for i in range(1, len(clusters)):
            distance = euclidean_distance(p, clusters[i].center)
            if distance < min_distance:
                min_distance = distance
                min_idx = i
        return min_idx
    return [closest_centroid_idx(p, clusters) for p in data]


def k_means_basic(data: np.array) -> (np.array, np.array):
    # get data range
    amin = np.amin(data, axis=0)
    amax = np.amax(data, axis=0)

    # set cluster initial positions
    clusters = [Cluster(i) for i in range(0, num_k)]
    for cluster in clusters:
        cluster.random_center(amin, amax)

    for i in range(MAX_ITER):
        # determine the closest centroid for each data point
        centroids = closest_centroids(data, clusters)

        for cluster in clusters:
            # assign each data point to the closest cluster
            cluster.assign_values(data, centroids)

            cluster.update_center()

    centers = np.asarray([cluster.center for cluster in clusters])
    labels = np.asarray([cluster.idx for cluster in clusters])

    # array with cluster centers and the cluster index (label)
    centers_labels = np.column_stack((centers, labels))

    # array with data and cluster index (label)
    data_labels = np.column_stack((data, centroids))
    return centers_labels, data_labels


def save_file(data: np.array, name: str):
    '''
        Inputs:
            data: numpy array with data to save
            name: name of the file to save to.
        Save data to file.
    '''
    np.savetxt(f'{name}', data, delimiter=',')


if __name__ == "__main__":
    if not args.normalize:
        print('running without normalization...')
        centers, data_labels = k_means_basic(data)
        save_file(
            centers,
            f'ngardn10ClusterCenterBasic{num_k}{input_file}')
        save_file(
            data_labels,
            f'ngardn10ClusterBasic{num_k}{input_file}')
    else:
        if args.normalize == 'min_max':
            print('running with min_max normalization...')
            data_norm, data_min, data_max = min_max_normalization(data)
            centers, data_labels = k_means_basic(data_norm)
            save_file(
                centers,
                f'ngardn10ClusterCenterMMNormalizedBasic{num_k}{input_file}')
            save_file(
                data_labels,
                f'ngardn10ClusteringMMNormalizedBasic{num_k}{input_file}')

            print('running with inverse normalization...')
            data_norm = inverse_min_max(data, data_min, data_max)
            centers, data_labels = k_means_basic(data_norm)
            save_file(
                centers,
                f'ngardn10ClusterCenterMMNormalizedBasic{num_k}{input_file}')
            save_file(
                data_labels,
                f'ngardn10ClusteringMMNormalizedBasic{num_k}{input_file}')
        else:
            print('running with z score normalization...')
            data_norm, mean, std = z_score_normalization(data)
            centers, data_labels = k_means_basic(data_norm)
            save_file(
                centers,
                f'ngardn10ClusterCenterNormalizedBasic{num_k}{input_file}')
            save_file(
                data_labels,
                f'ngardn10ClusteringNormalizedBasic{num_k}{input_file}')

            print('running with inverse normalization...')
            data_inverse = inverse_z_score(data_norm, mean, std)
            centers, data_labels = k_means_basic(data_inverse)
            save_file(
                centers,
                f'ngardn10ClusterCenterUnormalizedBasic{num_k}{input_file}')
            save_file(
                data_labels,
                f'ngardn10ClusteringUnormalizedBasic{num_k}{input_file}')
