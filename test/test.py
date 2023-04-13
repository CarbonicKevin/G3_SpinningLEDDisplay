from array import *
from math import sqrt, atan, pi, cos, sin
from PIL import Image
import numpy as np
import cv2

NO_ROD_CALC   = 180  # number of rod positions i want to consider in image map
NO_ARM_LED    = 32   # no. led's per arm
NO_STRIP_LED  = 144  # number of leds on the full strip
LED_STRIP_LEN = 100  # cm
ARM_LEN       = (LED_STRIP_LEN * NO_ARM_LED / NO_STRIP_LED)    # length of LED arm
DELTA_X       = NO_STRIP_LED / LED_STRIP_LEN                   # space between LEDs
R_MAX         = DELTA_X * (NO_ARM_LED - 1)                     # idk fill in later

# get polar coordinate map
def get_polar_map_64bit():

    # generate polar map with 32 r values per arm
    radius = [i for i in range(NO_ARM_LED)]
    theta  = [i for i in range(NO_ROD_CALC)]

    # print("radius:", radius)
    # print("theta:", theta)

    polar = []
    for r in radius:
        for t in theta:
            polar.append([r, t])

    return polar

def get_c_map_from_polar_64bit():
    polar = get_polar_map_64bit()

    sorted_by_theta = [[] for i in range(NO_ROD_CALC)]
    for pair in polar:
        r = pair[0]
        t = pair[1]
        entry = [round(r*cos(t)) + 31, round(r*sin(t)) + 31]
        sorted_by_theta[t].append(entry)
    
    print(sorted_by_theta)
    return sorted_by_theta

def image_cartesian_to_polar(image, dim):
    conv = get_c_map_from_polar_64bit()
    
    out_image = np.full((64, 64, 4), 255, dtype=np.uint8)

    o_im = conv.copy()

    for i in range(len(o_im)):
        for j in range(len(o_im[i])):
            x = o_im[i][j][0]
            y = o_im[i][j][1]
            # o_im[i][j] = image[x][y].tolist()
            out_image[x][y][0] = image[x][y][0]
            out_image[x][y][1] = image[x][y][1]
            out_image[x][y][2] = image[x][y][2]
            try:
                out_image[x][y][3] = image[x][y][3]
            except:
                continue

    return out_image

def main():
    # map_c_to_p(4)

    # image = cv2.imread('test_image.png')
    # h, w, _ = image.shape
    # image2 = cv2.linearPolar(image, (w / 2, h / 2), min(w, h) / 2,
    #                         cv2.WARP_INVERSE_MAP + cv2.WARP_FILL_OUTLIERS)
    # cv2.imwrite("test_image_o.png", image2)

    filename  = "test_image2.png"
    ofilename = "test_image2_o.png"
    with Image.open(filename) as image:
        im_matrix = np.array(image)
        # print(len(im_matrix))
        # print(im_matrix[1])
        # print(len(im_matrix[1]))
        # print(im_matrix[1][1])
        # print(image.size[0])

        out_image = image_cartesian_to_polar(im_matrix, image.size[0])
        # print(len(out_image))
        # print(out_image[5])
        # print(len(out_image[1]))
        # print(out_image[1][1])
        # print(out_image)

        out_image = Image.fromarray(out_image)
        out_image.save(ofilename)

main()