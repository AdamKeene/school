#Loading the IMDB dataset

from tensorflow.keras.datasets import imdb
(train_data, train_labels), (test_data, test_labels) = imdb.load_data(
    num_words=10000)
train_data[0]
train_labels[0]
max([max(sequence) for sequence in train_data])
#Decoding reviews back to text

word_index = imdb.get_word_index()
reverse_word_index = dict(
    [(value, key) for (key, value) in word_index.items()])
decoded_review = " ".join(
    [reverse_word_index.get(i - 3, "?") for i in train_data[0]])
#Preparing the data
#Encoding the integer sequences via multi-hot encoding

import numpy as np
def vectorize_sequences(sequences, dimension=10000):
    results = np.zeros((len(sequences), dimension))
    for i, sequence in enumerate(sequences):
        for j in sequence:
            results[i, j] = 1.
    return results
x_train = vectorize_sequences(train_data)
x_test = vectorize_sequences(test_data)
x_train[0]
y_train = np.asarray(train_labels).astype("float32")
y_test = np.asarray(test_labels).astype("float32")
# Building your model
# Model definition

from tensorflow import keras
from tensorflow.keras import layers

# model = keras.Sequential([
#     layers.Dense(16, activation="relu"),
#     layers.Dense(16, activation="relu"),
#     layers.Dense(1, activation="sigmoid")
# ])
# # Compiling the model

# model.compile(optimizer="rmsprop",
#               loss="binary_crossentropy",
#               metrics=["accuracy"])
# # Validating your approach
# # Setting aside a validation set

# x_val = x_train[:10000]
# partial_x_train = x_train[10000:]
# y_val = y_train[:10000]
# partial_y_train = y_train[10000:]
# # Training your model

# history = model.fit(partial_x_train,
#                     partial_y_train,
#                     epochs=20,
#                     batch_size=512,
#                     validation_data=(x_val, y_val))
# history_dict = history.history
# history_dict.keys()
# Plotting the training and validation loss

# import matplotlib.pyplot as plt
# history_dict = history.history
# loss_values = history_dict["loss"]
# val_loss_values = history_dict["val_loss"]
# epochs = range(1, len(loss_values) + 1)
# plt.plot(epochs, loss_values, "bo", label="Training loss")
# plt.plot(epochs, val_loss_values, "b", label="Validation loss")
# plt.title("Training and validation loss")
# plt.xlabel("Epochs")
# plt.ylabel("Loss")
# plt.legend()
# plt.show()
# Plotting the training and validation accuracy

# plt.clf()
# acc = history_dict["accuracy"]
# val_acc = history_dict["val_accuracy"]
# plt.plot(epochs, acc, "bo", label="Training acc")
# plt.plot(epochs, val_acc, "b", label="Validation acc")
# plt.title("Training and validation accuracy")
# plt.xlabel("Epochs")
# plt.ylabel("Accuracy")
# plt.legend()
# plt.show()
# Retraining a model from scratch

model = keras.Sequential([
    layers.Dense(16, activation="relu"),
    layers.Dense(8, activation="relu"),
    layers.Dense(1, activation="sigmoid")
])
model.compile(optimizer="rmsprop",
              loss="binary_crossentropy",
              metrics=["accuracy"])
model.fit(x_train, y_train, epochs=4, batch_size=512)
results = model.evaluate(x_test, y_test)
print(results)
# 3 layers 4 epochs: [0.29083046317100525, 0.8831999897956848]
# 4 layers 4 epochs: [0.3354390561580658, 0.8731200098991394]
# 4 layers 4 epochs 384 batch: [0.3119260370731354, 0.8803200125694275]
# 5 layers 4 epochs 384 batch: [0.37340766191482544, 0.8606799840927124]
# 4 layers 5 epochs 384 batch: [0.3306049108505249, 0.8765599727630615]
# 4 layers 3 epochs 384 batch: [0.36121389269828796, 0.8553199768066406]
# 3 layers 4 epochs 32 neuron first layer: [0.3295869827270508, 0.8700399994850159]
# 8 neurons each layer: [0.3067574203014374, 0.8771200180053711]
# 16 8: [0.28054141998291016, 0.8874800205230713]