import cv2
import serial           # import the module
import time
from PIL import Image
from numpy import array
import numpy as np
import csv

# with open('Input_image.csv', newline='') as csvfile:
#     data = list(csv.reader(csvfile))


im = cv2.imread("unnamed.jpg",cv2.IMREAD_GRAYSCALE)
arr = array(im)
# arr
arr_r = [[0 for x in range(len(arr[0]))] for y in range(len(arr))] 

ComPort = serial.Serial('COM8') # open COM24
ComPort.baudrate = 115200 # set Baud rate to 9600
ComPort.bytesize = 8    # Number of data bits = 8
ComPort.parity   = 'N'  # No parity
ComPort.stopbits = 1    # Number of Stop bits = 1
row = len(arr)
col = len(arr[0])
# print(row)
# print(col)

print ("sending array")
# print(type(arr[0][0]))
# data = np.array(data)
# data = data.astype(np.float64)
# np.savetxt('myfile1.csv', data, delimiter=',')

# for i in range(0,row):
#     for j in range(0,col):
#         print(arr[i][j])

for i in range(0,row):
    for j in range(0,col):
        ot= ComPort.write(bytes(chr(int(arr[i][j])),encoding = 'utf8')) 
# ot= ComPort.write(bytes(chr(int(x))))    #for sending data to FPGA

print("data sent!")

# print ("enter a number for data2 in range(0-255):"),
# x=input()

# ot= ComPort.write(bytes(chr(x)))    #for sending data to FPGA

# for i in range(0,row):
#     for j in range(0,col):
#         it=(ComPort.read(1))                #for receiving data from FPGA
#         arr_r[i][j] = int(it.hex(),16) 
#         # print (it.hex())
print("Xcom: ")
it=(ComPort.read(1))                #for receiving data from FPGA 
print (it.hex())
it=(ComPort.read(1))
print("Ycom: ")  
print (it.hex())
print("Got data")
# arr_r = np.array(arr_r)
# arr_r = arr_r.astype(np.int16)  
# # print(type(arr_r))
# for i in range(0,row):
#     for j in range(0,col):
#         if(arr_r[i][j] > 200):
#             arr_r[i][j] = 0
#         if(arr_r[i][j] > data[i][j]):
#             arr_r[i][j] = 0


   
# for i in range(0,row):
#     for j in range(0,col):
#         print(arr_r[i][j])
#         print(" ")
#     print("\n")
# print(np.matrix(arr_r))    
# np.savetxt('myfile.csv', arr_r, delimiter=',')
# cv2.imwrite('color_img.jpg', arr_r)   

ComPort.close()         # Close the Com port

