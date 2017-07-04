'''
libraries
'''

import pandas as pd #data munging
import numpy as np #number functions
import pylab as plt #plotting
import os #directory and file management
import socket #to get host machine identity

'''
script
'''
tomsmachines=['tom-citadel','tom-orthanc','tom-xps'] #names of Tom's computers

if socket.gethostname() in tomsmachines:
    #if we are on Tom's machine set directory as this
    os.chdir('/home/tom/Dropbox/WorldBias') #set directory
else:
    print "I don't know where I am"

#set working directory    
print ("Working directory = " + os.getcwd()) #confirm

#load data

dfw=pd.read_csv('Data/stats-white-europe.csv',index_col='countrycit')
dfb=pd.read_csv('Data/stats-black-europe.csv',index_col='countrycit')
dfo=pd.read_csv('Data/stats-other-europe.csv',index_col='countrycit')


dfw.sort_values('D_biep.White_Good_all.mean',inplace=True)


plt.clf()
plt.plot(dfw['D_biep.White_Good_all.mean'].values,'.',color="blue",label='white')
plt.plot(dfb.reindex(dfw.index)['D_biep.White_Good_all.mean'].values,'x',color='black',label='black')
plt.plot(dfo.reindex(dfw.index)['D_biep.White_Good_all.mean'].values,'v',color='red',label='all non-white')
plt.legend(loc=0)
plt.xlabel('European countries ordered by mean IAT score of White participants')
plt.yalebl('mean IAT')