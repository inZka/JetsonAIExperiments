import cv2
import traitlets
import threading
import jetson.utils
import numpy as np
import time

# these are for cameras mounted on waveshare case 
# https://www.waveshare.com/wiki/Jetson_Nano_Case_(C)
IDX_LEFT_CAMERA = 0
IDX_RIGHT_CAMERA = 1

OUT_AS_RAW_CUDAIMG = 0
OUT_AS_OPENCV = 1

# image size defaults
CAPTURE_WIDTH = 640
CAPTURE_HEIGHT = 480

# ipywidgets image needs jpeg,png and so on as value
def bgr8_to_jpeg(frame):
    return bytes(cv2.imencode('.jpg', frame)[1])

def cuda_to_opencv(frame, w, h, dtype=np.float32):
    aimg = jetson.utils.cudaToNumpy(frame, w, h, 4)
    aimg = cv2.flip(aimg, -1)
    # openCV color space is BGR
    aimg = cv2.cvtColor(aimg.astype(dtype), cv2.COLOR_RGBA2BGR)
    return aimg

def cudaimg_to_jpeg(frame, w=CAPTURE_WIDTH, h=CAPTURE_HEIGHT):
    return bgr8_to_jpeg(cuda_to_opencv(frame, w, h, np.uint8))


class GstCamera(traitlets.HasTraits):
    """ GstCamera abstracts jetson.utils.gstCamera info traitlets format,
    which is more convenient to use in Jupyter notebooks.
    """

    value = traitlets.Any()
    width = traitlets.Integer(default_value=CAPTURE_WIDTH)
    height = traitlets.Integer(default_value=CAPTURE_HEIGHT)
    running = traitlets.Bool(default_value=False)
    capture_device = traitlets.Integer(default_value=IDX_RIGHT_CAMERA)
    output_mode = traitlets.Integer(default_value=OUT_AS_OPENCV)

    def __init__(self, *args, **kwargs):
        super(GstCamera, self).__init__(*args, **kwargs)
        if self.output_mode == OUT_AS_OPENCV:
            self.value = np.empty((self.height, self.width, 3), dtype=np.uint8)
        self._running = False
        self._cam = jetson.utils.gstCamera(self.width, self.height,
                                          '{}'.format(self.capture_device))
    
    def __del__(self):
        self._cam.Close()
        del self._cam
    
    def _read(self):
        frame, width, height = self._cam.CaptureRGBA(zeroCopy=1)
        if self.output_mode == OUT_AS_RAW_CUDAIMG:
            return frame
        jetson.utils.cudaDeviceSynchronize()
        return cuda_to_opencv(frame, self.width, self.height)

    def read(self):
        if self._running:
            raise RuntimeError('Cannot read directly while camera is running')
        self.value = self._read()
        return self.value

    def _capture_frames(self):
        while True:
            if not self._running:
                break
            self.value = self._read()

    @traitlets.observe('running')
    def _on_running(self, change):
        if change['new'] and not change['old']:
            # transition from not running -> running
            self._running = True
            self.thread = threading.Thread(target=self._capture_frames)
            self.thread.start()
        elif change['old'] and not change['new']:
            # transition from running -> not running
            self._running = False
            self.thread.join()

class SimpleTimer:
    """ Simple timer as context manager """
    def __init__(self):
        self.time = 0
        self.fps = 0
        
    def __enter__(self):
        self.tic = time.monotonic()
    
    def __exit__(self, *info):
        self.time = time.monotonic() - self.tic
        self.fps = 1.0 / self.time