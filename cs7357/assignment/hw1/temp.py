"""Script for training a model and evaluating it with cross-validation."""

import random
from pathlib import Path

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split

INPUT_FILE = Path.cwd() / 'weather_data.csv'
BATCH_SIZE = 8
LEARNING_RATE = 0.01


def get_data(
    filename: str = INPUT_FILE,
    test_size: float = 0.25,
    random_state: int = 42,
) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    """
    Get data from the input file, split it into train and test sets.

    Args:
        filename: Path to the input file.
        test_size: Fraction of the data to use for testing.
        random_state: Random seed for shuffling the data.

    Returns:
        tuple: (x_train, x_test, y_train, y_test)
    """
    df = pd.read_csv(filename)

    # split data
    x_train, x_test, y_train, y_test = train_test_split(
        df[['Humidity', 'Visibility (km)']],
        df[['Temperature (C)']],
        test_size=test_size,
        random_state=random_state,
    )

    return (
        np.array(x_train),
        np.array(x_test),
        np.array(y_train),
        np.array(y_test),
    )


def data_iter(
    x_samples: np.ndarray,
    y_samples: np.ndarray,
    batch_size: int = BATCH_SIZE,
):
    """
    Iterate over the data and corresponding output in batches.

    Args:
        x_samples: Data to iterate over.
        y_samples: Labels to iterate over.
        batch_size: Size of the batches.

    Yields:
        tuple: (batch_data, batch_labels)
    """
    num_examples = len(x_samples)
    indices = list(range(num_examples))

    # examples are read at random, in no particular order
    random.shuffle(indices)
    for idx in range(0, num_examples, batch_size):
        batch_x = x_samples[indices[idx:idx + batch_size]]
        batch_y = y_samples[indices[idx:idx + batch_size]]
        yield batch_x, batch_y


def create_model_parameter(
    mu: float,
    sigma: float,
    rows: int,
    columns: int,
) -> tuple[np.ndarray, np.ndarray]:
    """
    Create model parameters from the input data.

    Args:
        mu: Mean of the data.
        sigma: Standard deviation of the data.
        rows: Number of rows in the data.
        columns: Number of columns in the data.

    Returns:
        tuple: Normal weights and biases.
    """
    weights = np.random.normal(mu, sigma, size=(rows, columns))
    biases = np.random.normal(mu, sigma, size=(rows, 1))
    return weights, biases


def model(
    input_data: np.ndarray,
    weights: np.ndarray,
    biases: np.ndarray,
) -> np.ndarray:
    """
    Model function.

    Args:
        input_data: Input data.
        weights: Weights.
        biases: Biases.

    Returns:
        np.ndarray: Output of the model.
    """
    return np.matmul(weights, input_data) + biases


def squared_loss(y_pred: np.ndarray, y_true: np.ndarray) -> np.ndarray:
    """Calculate squared loss.

    Args:
        y_pred: Predicted output.
        y_true: True output.

    Returns:
        np.ndarray: Squared loss.
    """
    return np.square(y_pred - y_true)


def gradient(
    loss: np.ndarray,
    model_params: tuple[np.ndarray, np.ndarray],
) -> tuple[np.ndarray, np.ndarray]:
    """
    Calculate the gradient of the loss function.

    Args:
        loss: Loss.
        model_params: Model parameters.

    Returns:
        tuple: Gradients.
    """
    weights, _ = model_params
    weights_grad = np.matmul(loss, weights.T)
    biases_grad = loss
    return weights_grad, biases_grad


if __name__ == '__main__':
    X_train, X_test, y_train, y_test = get_data()
    print(X_train.shape, X_test.shape, y_train.shape, y_test.shape)

    for X_data, y_data in data_iter(X_train, y_train):
        print(X_data, '\n', y_data)
        break
