#######################################################################
#
#  import_bobbi.py
#
#  Code: Robin van Emden - robin at pavlov.tech - 2017
#
#  Totem Bobbi: http://www.totemopenhealth.com/
#
#######################################################################

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os 
from pathlib import Path

###################### Set csv filename ###############################

csv_file = "data/8-sdataHR.csv"

#######################################################################

# Retrieve some file info
f = Path(csv_file)                                      # path object
f_no_ext = os.path.join(str(f.parent), f.stem)          # remove extension

# Save Pickled DF - faster to save and load later
is_cached = Path(f_no_ext +".df")                       # check for cache file
if is_cached.is_file():                                 # cache exists?
    dataset = pd.read_pickle(f_no_ext +".df")           # yes - load cache
    
else:
    dataset = pd.read_csv( f_no_ext +".csv",            # no  - load csv
                index_col=False,
                sep=';',
                dtype={'ms': np.int32,
                       'heartrate': np.int16, 
                       'BPM': np.int16 } ) 

    dataset['hart'] = dataset['heartrate']              # set hart
    # dataset['hart'] = -dataset['hart']+1000           # if needed, flip
    dataset.to_pickle(f_no_ext +".df")                  # save to cache
    
# Save small subset of data as a sample
dataset = dataset[(dataset['ms'] >= 104000) 
                    & (dataset['ms'] <= 115000)]

dataset = dataset.reset_index(drop=True)                # Start index at 0
dataset.to_csv(f_no_ext + "_sample.csv"
               ,sep=';',index=False)                    # Save CSV sample
dataset.to_pickle(f_no_ext +"_sample.df")               # Save DF sample

# Lets plot our sample, see if its ok
plt.title("Heart Rate Signal")                          #The title of our plot
plt.plot(dataset.ms,dataset.hart)                       #Draw the plot object
plt.show()                                              #Display the plot 
