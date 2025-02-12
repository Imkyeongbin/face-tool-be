from PIL import Image
import numpy as np

def process_image(image):
    pil_image = Image.open(image)
    np_image = np.array(pil_image.convert("RGB"))[:, :, ::-1]
    return np_image
