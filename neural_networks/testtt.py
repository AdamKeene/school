from tensorflow import keras

# Load the existing .keras model
model = keras.models.load_model("convnet_from_scratch_with_augmentation.keras")

# Save the model as a .h5 file
model.save("convnet_from_scratch_with_augmentation.h5")