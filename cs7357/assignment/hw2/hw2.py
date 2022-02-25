"""Script for comparing two neural networks."""

from pathlib import Path

import numpy as np
import pandas as pd
import tensorflow as tf
import matplotlib.pyplot as plt
from sklearn.preprocessing import OneHotEncoder
from sklearn.model_selection import train_test_split


# parameters
DATAPATH = './MINST.csv'
TEST_SIZE = 0.2
EPOCHS = 100
BATCH_SIZE = 100

# data
df = pd.read_csv(DATAPATH)
enc = OneHotEncoder()
labels = df.pop('label').values
labels = enc.fit_transform(labels.reshape(-1, 1)).toarray()
samples = df.to_numpy()

# models
model3 = tf.keras.models.Sequential([
    tf.keras.Input(shape=(784,)),
    tf.keras.layers.Dense(32, activation='relu'),
    tf.keras.layers.Dense(10, activation='softmax'),
])
model4 = tf.keras.models.Sequential([
    tf.keras.Input(shape=(784,)),
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dense(32, activation='relu'),
    tf.keras.layers.Dense(10, activation='softmax'),
])

# training
model3.compile(
    optimizer=tf.optimizers.Adam(),
    loss='categorical_crossentropy',
    metrics=['accuracy'],
)
model4.compile(
    optimizer=tf.optimizers.Adam(),
    loss='categorical_crossentropy',
    metrics=['accuracy'],
)
history3 = model3.fit(
    samples,
    labels,
    batch_size=BATCH_SIZE,
    epochs=EPOCHS,
    validation_split=TEST_SIZE,
)
history4 = model4.fit(
    samples,
    labels,
    batch_size=BATCH_SIZE,
    epochs=EPOCHS,
    validation_split=TEST_SIZE,
)

# plotting
plt.plot(history3.history['accuracy'], label='3-layer')
plt.plot(history4.history['accuracy'], label='4-layer')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.title('Training Accuracy')
plt.legend()
plt.savefig('train_accuracy.png')
plt.clf()

plt.plot(history3.history['val_accuracy'], label='3-layer')
plt.plot(history4.history['val_accuracy'], label='4-layer')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.title('Test Accuracy')
plt.legend()
plt.savefig('test_accuracy.png')
plt.clf()
