May 26, 1999

DSISoft Customized VSP Processing Software

Copyright (C) 1999 Seismology and Electromagnetic Section/
Continental Geosciences Division/Geological Survey of Canada

Thank you for downloading DSI customized VSP processing software.  DSISoft is free software WITHOUT ANY WARRANTY that can be redistributed and/or modified under the terms of the GNU Library General Public License (see COPYING.lib for details).  This software is designed to run on MATLAB 5.0 or higher. See the DSI homepage section on processing software/software development for information on how data should be organized into structured/cell variables to work with this software.  What follows is a list of modules currently available.  More detailed descriptions can be found by typing 'help' followed by the module name within MATLAB.  Please contact us at dsi@cg.NRCan.gc.ca if you experience any dificulties or would like to provide feedback, request changes or contribute new modules to the package.  As more modules are written, they will be posted on the web site.
  

PROCESSING MODULES


agc - automatic gain control 

agcmem - automatic gain control (conserves memory at cost of speed)

asc2mat - converts ASCII files of seismic traces to DSI format 

autocor - autocorrelation of each trace 

azimuth - computes the receiver-to-shot azimuth

bandpass - linear bandpass filter 

bison2mat - reads BISON data and converts to DSI format 

b_rise - calculates rise time of first breaks 

butw - butterworth bandpass filter (uses signal processing toolbox

dsi_start - prints software info and the data, starts timer  

dsi_end - prints out time elapsed since 'dsi_start' was called 

ener - energy balancing 

equa - spectral equalization 

findref3d - calculates points in 3 dimensions

fkfilt - apply f-k filter 

flat - flattens the data according to pick times 

flat2 - flattens the data according to times stored in a header word 

handrot - rotates 2 components by a specified angle stored in a header word

hannband - Bandpass Finite Impulse Response filtering using a Hanning window

hannhigh - Highpass Finite Impulse Response filtering using a Hanning window

hannlow - Lowpass Finite Impulse Response filtering using a Hanning window

harmon - adaptive filter useful for removing electrical noise

harmon_new - adaptive filter useful for removing electrical noise with modified search algorithm

ibm2ieee - convert a matrix of IBM/360 32-bit floats to IEEE doubles

ita2mat - converts seismic data from ITA to DSI format 

kill - flag bad traces 

mat2asc - saves a DSI variable as ASCII files 

mat2segy - saves a DSI variable in segy format 

meanfilt - one dimensional mean filter

medi_filt - median filter 

medirm - removes a downgoing wave using a median filter based on either first break pick times or velocity and shot static 

merge_files - merges two DSI variables into one 

mix - lateral trace mixing 

mute - mutes data either before, after, or between specified time(s) 

mute2 - mutes data according to a constant time value

noch - linear notch filter 

pack_good - removes traces flagged by 'kill' from the dataset 

pad - pads end of data with zeros

padbefore - pads beginning of data with zeros

preddecon - performs a predictive deconvolution on the data

profil - gives profile of a DSI variable 

readascii - reads in an ascii file

resamp - resamples the data

rot3c - rotates 2 components to maximize energy on one by performing rotations in 1 degree increments

rot3c_eig - rotates 2 components to maximize energy on one using Eigenvalue method

rot_bal - balances amplitudes based on angle betweeen receiver-to-shot azimuth and horizontal component

rot_deg - rotates 2 components to examine energy reflected from a specific direction 

rotcoord - rotate coordinate system by a given angle

s2r_geom - computes shot-to-receiver azimuth and shot-to-receiver offset

seg2mat - reads seg2 data and puts it into DSI format 

segy2mat - reads segy data and puts it into DSI format

seisplot - plots seismic traces, called by most of the graphic interface modules 
sft - shifts all traces by a specified time 

sft - shifts data by a constant time

shft - shifts data according to a time stored in a trace header word

slicefmap - slice up a fold map

sortrec - sorts records and traces within records by any trace header word 

sortrec_many - sorts records and traces within records by up to 7 trace header words

sortrec_new - sorts records and traces within records by any trace header word 

stack - stack dataset

subr - subtracts one set of traces from another 

subset - used for making a subset of data 

thread - reads specified trace headers and saves contents in an ASCII file 

thwrite - writes values stored in an ASCII file to specified trace headers 

tred - performs time shifts according to wave velocity and shot-receiver offset to flatten first breaks (linear moveout correction)

trim - trim statics 

tune_xcorr - cross-correlation based algorithm for tuning first break pick times

unflat - restores flattened data according to first break pick times

unflat2 - restores flattened data according to first break pick times


INTERACTIVE MODULES

aspec - shows plots of amplitude and phase vs. frequency 

dispseis - display module for looking at seismic traces 

fkpoly - plots the f-k spectrum of seismic traces and allows interactive picking of a polygon to be used for f-k filtering with options to look at filtered results of passing or rejecting contents of polygon

pick1comp - interactive first break picking on one component with options to tune, kill traces, and flatten according to pick times 

pickfb - interactive first break picking simultaneously on 3 components with options to tune according to component with most energy, kill traces, flatten according to pick times, and rotate components on the fly 

plothd - plots contents of trace headers in 2 or 3 dimensions as selected from a menu that identifies the significance of each trace header word 
