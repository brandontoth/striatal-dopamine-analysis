import cv2 as cv
import threading
import os
import time

# constant declaration
RES_WIDTH = 640 # define the resolution width
RES_HEIGHT = 480 # define the resolution height
FRAME_RATE = 30 # define the desired frame rate
FOUR_CC = cv.VideoWriter_fourcc(*'mp4v') # define the four character code
ONE_HOUR = 3600 # conversion from seconds to hours
NULL_CAMERA = 0 # define the first camera to turn on

SCALING_FACTOR = 12 # use to alter the length of the recording
# save location for videos
FILE_LOCATION = 'E:\Videos'

# name boxes
boxID = ["null1", "230128_BT72_12hr_choc", "230128_BT71_12hr_choc", "230128_BT73_12hr_choc"]

# class definition for individual threads that will be used to write videos
class camThread(threading.Thread):
    def __init__(self, mouseID, camID):
        threading.Thread.__init__(self)
        self.mouseID = mouseID
        self.camID = camID

    # call whenever object is intantiated 
    def run(self):
        print("Starting " + self.mouseID)
        camPreview(self.mouseID, self.camID) # function to acquire videos 

def camPreview(mouseID, camID):
    # create full file name
    fullName = os.path.join(FILE_LOCATION, mouseID + ".mp4")
    # create a preview window for the current camera
    cv.namedWindow(mouseID)

    cam = cv.VideoCapture(camID) # start video object

    # set width and height to the desired resolution
    cam.set(3, RES_WIDTH) 
    cam.set(4, RES_HEIGHT)

    # get the new resolution and assign it to new variables
    width = cam.get(cv.CAP_PROP_FRAME_WIDTH)
    height = cam.get(cv.CAP_PROP_FRAME_HEIGHT)

    # when cropping, this variable must be changed in the same way as 
    # "cropFrame" will be changed, other the video file will be corrupted
    size = (int(height), int(width / 2))

    # create variable to write video to
    out = cv.VideoWriter(fullName, FOUR_CC, FRAME_RATE, size)

    startTime = time.time() # get the time that the camera turns on

    # if the camera is functioning properly, begin reading frames,
    # otherwise, stop recording
    if cam.isOpened():
        rval, frame = cam.read()
    else:
        rval = False

    frame_rate = 10
    prev = 0

    # record video for the desired duration
    while (int(time.time() - startTime) < (ONE_HOUR * SCALING_FACTOR)):
        if rval:
            time_elapsed = time.time() - prev

            if time_elapsed > 1./frame_rate:
                prev = time.time()

                # crop frame to limit FOV and reduce file size
                cropFrame = frame[0:int(width / 2), 0:int(height)]

                cv.imshow(mouseID, cropFrame) # display video
                out.write(cropFrame) # save cropped video

                rval, frame = cam.read() # continue reading frames

        # to manually stop recordings, hit the ESC key
        key = cv.waitKey(100)
        if key == 27:
            # stop recording
            cam.release()
            out.release()
            break # exit the loop

    cv.destroyWindow(mouseID) # close preview window
    print()
    print(mouseID + " recording stopped")

# create threads
thread = {}

for ID in boxID:
    thread[str(ID)] = camThread(ID, NULL_CAMERA)
    thread[str(ID)].start()
    NULL_CAMERA += 1

print()
print("Recording in progress")
