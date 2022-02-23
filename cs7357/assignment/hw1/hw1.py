"""Script for training a model and evaluating it with cross-validation."""

import random
from pathlib import Path

import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
from sklearn.model_selection import train_test_split

INPUT_FILE = Path.cwd() / 'weather_data.csv'
BATCH_SIZE = 64
LEARNING_RATE = 0.01
NUM_EPOCHS = 30


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
    biases = np.zeros(1)
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
    return np.dot(input_data, weights) + biases.T


def squared_loss(y_pred: np.ndarray, y_true: np.ndarray) -> float:
    """Calculate squared loss.

    Args:
        y_pred: Predicted output.
        y_true: True output.

    Returns:
        float: Squared loss.
    """
    return np.mean((y_pred - y_true) ** 2) / 2


def gradient(
    y_pred: np.ndarray,
    y_actual: np.ndarray,
    input_data: np.ndarray,
) -> tuple[np.ndarray, np.ndarray]:
    """
    Calculate the gradient of the loss function.

    Args:
        y_pred: Predicted output.
        y_actual: True output.
        input_data: Input data.

    Returns:
        tuple: Gradients.
    """
    weights_grad = np.sum((y_pred - y_actual) * input_data)
    biases_grad = np.sum((y_pred - y_actual))
    return weights_grad, biases_grad


def sgd(
    model_params: tuple[np.ndarray, np.ndarray],
    grads: tuple[np.ndarray, np.ndarray],
    learning_rate: float = LEARNING_RATE,
    batch_size: int = BATCH_SIZE,
) -> tuple[np.ndarray, np.ndarray]:
    """
    Perform stochastic gradient descent.

    Args:
        model_params: Model parameters.
        grads: Gradients.
        learning_rate: Learning_rate.
        batch_size: Batch size.

    Returns:
        tuple: Updated model parameters.
    """
    weights, biases = model_params
    weights_grad, biases_grad = grads

    weights_update = learning_rate * (weights_grad / batch_size)
    biases_update = learning_rate * (biases_grad / batch_size)

    weights -= weights_update
    biases -= biases_update
    return weights, biases


def train(
    x_train: np.ndarray,
    y_train: np.ndarray,
    num_epochs: int = NUM_EPOCHS,
    learning_rate: float = LEARNING_RATE,
    batch_size: int = BATCH_SIZE,
) -> tuple[np.ndarray, np.ndarray, list]:
    """
    Train the model.

    Args:
        x_train: Training data.
        y_train: Training labels.
        num_epochs: Number of epochs.
        learning_rate: Learning rate.
        batch_size: Batch size.

    Returns:
        tuple: Model parameters.
    """
    weights, biases = create_model_parameter(
        mu=0,
        sigma=0.1,
        rows=x_train.shape[1],
        columns=1,
    )

    losses = []
    for epoch in range(num_epochs):
        for batch_x, batch_y in data_iter(x_train, y_train, batch_size):
            # calculate loss and gradients
            y_pred = model(batch_x, weights, biases)
            grads = gradient(y_pred, batch_y, batch_x)

            # update model parameters
            weights, biases = sgd(
                model_params=(weights, biases),
                grads=grads,
                learning_rate=learning_rate,
                batch_size=batch_size,
            )
        train_l = squared_loss(model(x_train, weights, biases), y_train)
        losses.append(train_l)
        print('Epoch {0}: Loss = {1}'.format(epoch + 1, train_l))

    return weights, biases, losses


def test(
    x_test: np.ndarray,
    y_test: np.ndarray,
    model_params: tuple[np.ndarray, np.ndarray],
) -> float:
    """
    Test the model.

    Args:
        x_test: Test data.
        y_test: Test labels.
        model_params: Model parameters.

    Returns:
        float: Test loss.
    """
    weights, biases = model_params
    return squared_loss(model(x_test, weights, biases), y_test)


if __name__ == '__main__':
    X_train, X_test, y_train, y_test = get_data()
    print(X_train.shape, X_test.shape, y_train.shape, y_test.shape)

    weights, biases, losses = train(
        x_train=X_train,
        y_train=y_train,
    )

    test_loss = test(
        x_test=X_test,
        y_test=y_test,
        model_params=(weights, biases),
    )
    print('Test loss: {0}'.format(test_loss))

    plt.plot(losses)
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.show()
    plt.savefig('loss.png')

    # question 2
    plt.clf()
    plt.xlabel('Epoch')
    plt.ylabel('Losses')
    batches = [16, 64, 128]
    for batch_size in batches:
        weights, biases, losses = train(
            x_train=X_train,
            y_train=y_train,
            batch_size=batch_size,
        )

        test_loss = test(
            x_test=X_test,
            y_test=y_test,
            model_params=(weights, biases),
        )
        print('Test loss: {0}'.format(test_loss))

        plt.plot(losses)
    plt.legend(batches)
    plt.savefig('loss_batches.png')
