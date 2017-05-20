#######################################################################
#
#  heart_measures.py
#
#  Based upon code by Paul van Gent:
#
#  https://github.com/paulvangentcom/heartrate_analysis_python
#
#  Adapted for Bobbi by: Robin van Emden - robin@pavlov.tech - 2017
#
#  Totem Bobbi: http://www.totemopenhealth.com/
#
#######################################################################

import heart_beat as hb 

fs = 500 # sampling frequency 120

dataset = hb.get_data("data/8-sdataHR_sample.df")
hb.process_advanced(dataset, 0.75, fs)

#The module dict now contains all the variables computed over our signal:
print ("BPM: "+str(hb.measures['bpm']))
print ("ibi: "+str(hb.measures['ibi']))
print ("sdnn: "+str(hb.measures['sdnn']))
print ("RR_list: "+str(hb.measures['RR_list']))
print ("RR_diff: "+str(hb.measures['RR_diff']))
print ("RR_sqdiff: "+str(hb.measures['RR_sqdiff']))
print ("RR_sqdiff: "+str(hb.measures['RR_sqdiff']))
print ("sdnn: "+str(hb.measures['sdnn']))
print ("sdsd: "+str(hb.measures['sdsd']))
print ("rmssd: "+str(hb.measures['rmssd']))
print ("nn20: "+str(hb.measures['nn20']))
print ("nn50: "+str(hb.measures['nn50']))
print ("pnn20: "+str(hb.measures['pnn20']))
print ("pnn50: "+str(hb.measures['pnn50']))