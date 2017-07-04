'''
graph IAT data by ethnicity

assumes you have run
Transformations.R
white_v_black.R
to process the raw data and generate the necessary consolidated data files
'''

'''
libraries
'''

import pandas as pd #data munging
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
plt.plot([-1,45],[0,0],'-',color='k',linewidth=0.3)
plt.xlim([-1, 45])
plt.ylim([-0.3, 0.9])
plt.legend(loc=0)
plt.xlabel('European countries ordered by mean IAT score of White participants')
plt.ylabel('mean IAT')
plt.savefig("IAT_by_ethnicity_whiteonly.png",bbox_inches="tight")
plt.plot(dfb.reindex(dfw.index)['D_biep.White_Good_all.mean'].values,'x',color='black',label='black')
plt.plot(dfo.reindex(dfw.index)['D_biep.White_Good_all.mean'].values,'v',color='red',label='all non-white')
plt.savefig("IAT_by_ethnicity.png",bbox_inches="tight")

sum(dfw.n)
#110641
sum(dfb.n)
#632
sum(dfo.n)
#20847



dfw=pd.read_csv('Data/full-white-europe.csv')
dfb=pd.read_csv('Data/full-black-europe.csv')
dfo=pd.read_csv('Data/full-other-europe.csv')

alphalevel=1
plt.clf()
plt.subplot(311)
dfw['D_biep.White_Good_all'].hist(normed=1,bins=50,alpha=alphalevel,color='blue',label='white, n = 110,641')
plt.legend(loc=2)
plt.xlim([-1.5,1.5])
plt.ylim([0,1])
plt.tick_params(
    axis='x',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='off',      # ticks along the bottom edge are off
    top='off',         # ticks along the top edge are off
    labelbottom='off') # labels along the bottom edge are off
    
plt.subplot(312)
dfo['D_biep.White_Good_all'].hist(normed=1,bins=50,alpha=alphalevel,color='red',label='all non-white, n = 20,847')
plt.legend(loc=2)
plt.xlim([-1.5,1.5])
plt.ylim([0,1])
plt.ylabel('normalised frequency')
plt.tick_params(
    axis='x',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='off',      # ticks along the bottom edge are off
    top='off',         # ticks along the top edge are off
    labelbottom='off') # labels along the bottom edge are off


plt.subplot(313)
dfb['D_biep.White_Good_all'].hist(normed=1,bins=50,alpha=alphalevel,color='black',label='black, n = 632')
plt.legend(loc=2)
plt.xlim([-1.5,1.5])
plt.ylim([0,1])
plt.xlabel('IAT score')

plt.savefig('hist_by_ethnicity.png',bbox_inches='tight')