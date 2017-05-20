#######################################################################
#
#  basic_peak_detection.py
#
#  Code: Robin van Emden - robin at pavlov.tech - 2017
#
#  Totem Bobbi: http://www.totemopenhealth.com/
#
#######################################################################

import heart_beat as hb 

fs = 500 # sampling frequency 500hz

#import data sample
dataset = hb.get_data("data/8-sdataHR_sample.df")
hb.process_basic_peak(dataset, 0.75, fs)

#We have imported our Python module as an object called 'hb'
#This object contains the dictionary 'measures' with all values in it
#Now we can also retrieve the BPM value (and later other values) like this:
bpm = hb.measures['bpm']
print(bpm)