import os
from PIL import Image

def is_valid_image(file_path):
    try:
        img = Image.open(file_path)
        img.verify()  # Verify that it is, in fact, an image
        img.close()  # Close the image file
        return True
    except (IOError, SyntaxError) as e:
        print(f"Invalid image file: {file_path} - {e}")
        return False

def clean_data(directory):
    for filename in os.listdir(directory):
        if filename.endswith(".jpg"):
            file_path = os.path.join(directory, filename)
            if not is_valid_image(file_path):
                print(f"Removing invalid image file: {file_path}")
                os.remove(file_path)
    print("Data cleaning completed successfully.")

# Specify the directory containing the .jpg files
directory = "C:\\Users\\akeen\\Downloads\\kagglecatsanddogs_5340\\ReorganizedData"
clean_data(directory)