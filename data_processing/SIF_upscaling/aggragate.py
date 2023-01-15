#!/usr/bin/env python

import os
import sys
from optparse import OptionParser
import numpy as np
import h5py
import time
from netCDF4 import Dataset
from dateutil import rrule
from datetime import *
import time
import glob
from numba import jit
                  
def grid(options, args):
    
    # Define spatial grid:
    dlat = np.arange(options.latMin, options.latMax+1e-8, options.dLat)
    dlon = np.arange(options.lonMin, options.lonMax+1e-8, options.dLon)
    lat = np.arange(options.latMin+options.dLat/2., options.latMax+1e-8-options.dLat/2., options.dLat)
    lon = np.arange(options.lonMin+options.dLon/2., options.lonMax+1e-8-options.dLat/2., options.dLon)
    #print lat,lon
    # how many time-slices for now
    start = datetime.strptime(options.start, "%Y-%m-%d").date()
    stop = datetime.strptime(options.stop, "%Y-%m-%d").date()
    print(start,stop)
    nT = 0
    # Check out times to be interated
    for dt in rrule.rrule(rrule.DAILY, interval=options.dTime, dtstart=start, until=stop):
      #print dt
      nT+=1

    print('Time dimension ' , nT)
    # Generate simple numpy arrays for averaging
    
    vec_cloud_fraction=np.zeros((len(lat),len(lon)))
    vec_daily_correction_factor=np.zeros((len(lat),len(lon)))
    vec_dcSIF=np.zeros((len(lat),len(lon)))
    vec_sif=np.zeros((len(lat),len(lon)))
    vec_phase_angle=np.zeros((len(lat),len(lon)))
    vec_sif_err=np.zeros((len(lat),len(lon)))
    vec_sif_relative=np.zeros((len(lat),len(lon)))
    vec_sza=np.zeros((len(lat),len(lon)))
    vec_vza=np.zeros((len(lat),len(lon)))
    vec_n = np.zeros((len(lat),len(lon)))  
    vec_SIF_avg = np.zeros((len(lat),len(lon)))  
    vec_SIF_avg_norm = np.zeros((len(lat),len(lon)))   
    vec_NIR = np.zeros((len(lat),len(lon)))   
    
    # create netCDF4 file:
    f = Dataset(options.outFile, 'w', format='NETCDF4')
    time = f.createDimension('time', None)
    lati = f.createDimension('lat', len(lat))
    loni = f.createDimension('lon', len(lon))
    times = f.createVariable('time','f8',('time',))
    latitudes = f.createVariable('lat','f8',('lat'))
    longitudes = f.createVariable('lon','f8',('lon'))
    latitudes[:] =  lat
    longitudes[:] = lon
    # Add units, long names, etc.
    times.units = 'days since 2018-1-1 0:0:0'
    latitudes.units="degrees_north"
    longitudes.units="degrees_east"
    latitudes.standard_name = "latitude"
    longitudes.standard_name="longitude"
    latitudes.axis = "Y"
    longitudes.axis="X"
    times.long_name = "time"
    latitudes.long_name="latitude"
    longitudes.long_name="longitude"

    cloud_fraction=f.createVariable("cloud_fraction","f4",("time","lat","lon",), zlib=True,least_significant_digit=4,fill_value=-999.9)
    daily_correction_factor=f.createVariable("daily_correction_factor","f4",("time","lat","lon",), zlib=True,least_significant_digit=4,fill_value=-999.9)
    dcSIF=f.createVariable("dcSIF","f4",("time","lat","lon",), zlib=True,least_significant_digit=4,fill_value=-999.9)
    sif=f.createVariable("sif","f4",("time","lat","lon",), zlib=True,least_significant_digit=4,fill_value=-999.9)
    phase_angle=f.createVariable("phase_angle","f4",("time","lat","lon",), zlib=True,least_significant_digit=4,fill_value=-999.9)
    sif_err=f.createVariable("sif_err","f4",("time","lat","lon",), zlib=True,least_significant_digit=4,fill_value=-999.9)
    sif_relative=f.createVariable("sif_relative","f4",("time","lat","lon",), zlib=True,least_significant_digit=4,fill_value=-999.9)
    sza=f.createVariable("sza","f4",("time","lat","lon",), zlib=True,least_significant_digit=4,fill_value=-999.9)
    vza=f.createVariable("vza","f4",("time","lat","lon",), zlib=True,least_significant_digit=4,fill_value=-999.9)
    nir=f.createVariable("nir","f4",("time","lat","lon",), zlib=True,least_significant_digit=4,fill_value=-999.9)
    #for i in dict_names:
    #    cmd = 'f.'+ i + '="' +dict_names[i]+'"'
    #    try:
    #        exec(cmd)
    ##    except:
     #       print('Error executing ' + cmd)
     
    # Some basic stuff
    
    
    
    # Basic variables to be generated:
    #for i in dict_l2:
    #    cmd = i + '=f.createVariable("'+i+'","f4",("time","lat","lon",), zlib=True,least_significant_digit=4,fill_value=-999.9)'
    #    try:
    #        print(cmd)
    #    except:
    #        print('Error executing ' + cmd)
    n = f.createVariable('N','f4',('time','lat','lon',), zlib=True,least_significant_digit=4,fill_value=-999.9)
   
    
    # loop over files:
    counter = 0
    counter_time = 0

    # Start looping over files:
    counter = -1
    for dt in (rrule.rrule(rrule.DAILY, interval=options.dTime,  dtstart=start, until=stop)):
        # Set to 0 again
        vec_n[:]=0
        vec_cloud_fraction[:]=0
        vec_daily_correction_factor[:]=0
        vec_dcSIF[:]=0
        vec_sif[:]=0
        vec_phase_angle[:]=0
        vec_sif_err[:]=0
        vec_sif_relative[:]=0
        vec_sza[:]=0
        vec_vza[:]=0
        vec_NIR[:]=0
       
        files = glob.glob(options.folder + 'TROPO_SIF_'+dt.strftime('%Y-%m-%d')+'_ungridded.nc')
        #print(options.folder + dt.strftime('%Y/%m/')+ 'oco2_*_??'+dt.strftime('%m%d')+'_*.nc4') TROPO_SIF_2018-05-20_ungridded
        counter +=1
        #date_center = dt + timedelta(days=np.floor(options.dTime/2.))
        date_start = datetime(2018,1,1)
        delta = dt - date_start
        times[counter] = delta.days
        for file in files:
            #print(file)
            fin = h5py.File(file,'r')

            lat_in = fin['lat'][:]
            lon_in = fin['lon'][:]
            #biome = fin['IGBP_index'][:]
            #mode = fin['measurement_mode'][:]
            eps =0.01
            ind2 = (lat_in>options.latMin+eps)&(lat_in<options.latMax-eps)&(lon_in<options.lonMax-0.01)&(lon_in>options.lonMin+0.01)
            #& ((mode== options.mode) | (options.mode == -1))& ((biome== options.biome) | (options.biome == -1))
            ind = np.array(np.where(ind2)[0])
            print(file, counter , len(ind),)
            if len(ind)>0:
               # print len(ind)
                iLat = np.asarray(np.floor(((np.asarray(lat_in[ind])-options.latMin)/(options.latMax-options.latMin)*len(lat))),dtype=int)
                iLon = np.asarray(np.floor(((np.asarray(lon_in[ind])-options.lonMin)/(options.lonMax-options.lonMin)*len(lon))),dtype=int)
                #wo = np.where((iLon>119))[0]
               # print iLat
                #print iLat[wo], iLon[wo], lat_in[ind[wo]], lon_in[ind[wo]]
                #print np.max(iLon), np.max(iLat), len(lon), len(lat), np.max(lon_in)
                iT = counter
                #index_vector = np.asarray((iLon*len(lat)+iLat), dtype=int);
                
                cloud_fraction_in=fin["cloud_fraction"][:]
                daily_correction_factor_in=fin["daily_correction_factor"][:]
                dcSIF_in=fin["dcSIF"][:]
                sif_in=fin["sif"][:]
                phase_angle_in=fin["phase_angle"][:]
                sif_err_in=fin["sif_err"][:]
                sif_relative_in=fin["sif_relative"][:]
                sza_in=fin["sza"][:]
                vza_in=fin["vza"][:]
                longitude_in=fin["lon"][:]
                latitude_in=fin["lat"][:]
                NIR_in=fin["NIR"][:]
                
                
                favg(vec_n,iLat,iLon,ind,np.ones(len(ind),),len(ind))         
                favg(vec_cloud_fraction,iLat,iLon,ind,cloud_fraction_in,len(ind))
                favg(vec_daily_correction_factor,iLat,iLon,ind,daily_correction_factor_in,len(ind))
                favg(vec_dcSIF,iLat,iLon,ind,dcSIF_in,len(ind))
                favg(vec_sif,iLat,iLon,ind,sif_in,len(ind))
                favg(vec_phase_angle,iLat,iLon,ind,phase_angle_in,len(ind))
                favg(vec_sif_err,iLat,iLon,ind,sif_err_in,len(ind))
                favg(vec_sif_relative,iLat,iLon,ind,sif_relative_in,len(ind))
                favg(vec_sza,iLat,iLon,ind,sza_in,len(ind))
                favg(vec_vza,iLat,iLon,ind,vza_in,len(ind))
                favg(vec_NIR,iLat,iLon,ind,NIR_in,len(ind))
                
                print('.. averaged')
                #print(np.max(vec_n))
                #for j in range(len(ind)):

                    
                    
                    #print iT
                    
                
                

            fin.close()
        # Demand a minimum of 5 points per grid cell
        if len(ind)>0:
            vec_n[vec_n<3]=1
            wo = np.where(vec_n>1)
            #print(wo)
            vec_cloud_fraction[vec_n==1]=-999.9
            vec_cloud_fraction/=vec_n
            vec_daily_correction_factor[vec_n==1]=-999.9
            vec_daily_correction_factor/=vec_n
            vec_dcSIF[vec_n==1]=-999.9
            vec_dcSIF/=vec_n
            vec_sif[vec_n==1]=-999.9
            vec_sif/=vec_n
            vec_phase_angle[vec_n==1]=-999.9
            vec_phase_angle/=vec_n
            vec_sif_err[vec_n==1]=-999.9
            vec_sif_err/=vec_n
            vec_sif_relative[vec_n==1]=-999.9
            vec_sif_relative/=vec_n
            vec_sza[vec_n==1]=-999.9
            vec_sza/=vec_n
            vec_vza[vec_n==1]=-999.9
            vec_vza/=vec_n
            vec_NIR[vec_n==1]=-999.9
            vec_NIR/=vec_n
            
            #print(sif_757_1sigma[counter,wo[0],wo[1]])
            for j in range(len(wo[0])):
                cloud_fraction[counter,wo[0][j], wo[1][j]] = vec_cloud_fraction[wo[0][j], wo[1][j]]
                daily_correction_factor[counter,wo[0][j],wo[1][j]] = vec_daily_correction_factor[wo[0][j],wo[1][j]]
                dcSIF[counter,wo[0][j],wo[1][j]] = vec_dcSIF[wo[0][j],wo[1][j]]
                sif[counter,wo[0][j],wo[1][j]] = vec_sif[wo[0][j],wo[1][j]]
                phase_angle[counter,wo[0][j],wo[1][j]] = vec_phase_angle[wo[0][j],wo[1][j]]
                sif_err[counter,wo[0][j],wo[1][j]] = vec_sif_err[wo[0][j],wo[1][j]]
                sif_relative[counter,wo[0][j],wo[1][j]] = vec_sif_relative[wo[0][j],wo[1][j]]
                sza[counter,wo[0][j],wo[1][j]] = vec_sza[wo[0][j],wo[1][j]]
                vza[counter,wo[0][j],wo[1][j]] = vec_vza[wo[0][j],wo[1][j]]
                nir[counter,wo[0][j],wo[1][j]] = vec_NIR[wo[0][j],wo[1][j]]
            #print(np.max(Tskin[counter,:,:]))
            #for i in dict_l2:
            #    cmd1 = 'vec_'+i+'[vec_n==1]=-999.9'
            #    cmd2 = 'vec_' + i + '/=vec_n'
                #cmd3 = i + '[:,:,:] = vec_' + i+'[:,:,:]'
            #    print(cmd1)
            #    print(cmd2)
        #    vec_SIF_avg[vec_n==1]=-999.9
        #    vec_SIF_avg_norm[vec_n==1]=-999.9
            #vec_SIF_avg/=vec_n
            #vec_SIF_avg_norm/=vec_n
            
            #SIF_a[counter,:,:]=-999.9
            #SIF_norm[counter,:,:]=-999.9
            n[counter,:,:] = vec_n[:,:]
            #for i in dict_l2:
            #  cmd = i + '[counter,:,:] = vec_' + i+'[:,:]'
            #  #print(cmd)
            #  print(cmd)
            #SIF_a[counter,:,:]=vec_SIF_avg[:,:]
            #SIF_norm[counter,:,:]=vec_SIF_avg_norm[:,:]
            #print('###############')
    
    
    
    
    
    f.close()
      #  print ' done'

@jit(nopython=True, parallel=True)
def favg(arr,ix,iy,iz,inp,s):
    for i in range(s):
        arr[ix[i],iy[i]]+=inp[iz[i]]
    return arr        
        
def standalone_main():
    parser = OptionParser(usage="usage: %prog l2_file2")
    parser.add_option( "-o","--outFile", dest="outFile",
                       default='C:/Users/haod776/OneDrive - PNNL/Documents/work/co-authors/pattern/SIF/TROPO_SIF_2018-08/TROPOMI_SIF_daily_grid_2018_8_upscale_2.nc',
                       help="output filename (default OCO2_SIF_map.nc)")
    parser.add_option( "--latMin", dest="latMin",
                       type=float,
                       default=-90,
                       help="min latitude region")
    parser.add_option( "--dLat", dest="dLat",
                       type=float,
                       default=0.2,
                       help="latitude resolution (1 degree default)")
    parser.add_option( "--dLon", dest="dLon",
                       type=float,
                       default=0.2,
                       help="longitude resolution (1 degree default)")
    parser.add_option( "--startTime", dest="start",
                       default='2018-08-01',
                       help="default 2014-09-06")
    parser.add_option( "--stopTime", dest="stop",
                       default='2018-08-31',
                       help="default 2015-01-01")
    parser.add_option( "--dTime", dest="dTime",
                       default=1,
                       type=int,
                       help="default 1 month (determines time window size for each time step)")
    
    parser.add_option('--mode', dest='mode', type=int, default=-1,
                      help='mode (0=ND, 1=GL, 2=TG, etc, -1 for all)')

    parser.add_option('--biome', dest='biome', type=int, default=-1,
                      help='IGBP biome type (-1 default for ALL)')

    parser.add_option( "--latMax", dest="latMax",
                       type=float,
                       default=90,
                       help="max latitude region")
    parser.add_option( "--lonMin", dest="lonMin",
                       type=float,
                       default=-180,
                       help="min longitude region")
    parser.add_option( "--lonMax", dest="lonMax",
                       type=float,
                       default=180,
                       help="max longitude region")
    parser.add_option( "--folder", dest="folder",
                       default='C:/Users/haod776/OneDrive - PNNL/Documents/work/co-authors/pattern/SIF/TROPO_SIF_2018-08/TROPO_SIF_2018-08/',
                       help="Default folder DIR root where data is stored in DIR/YYYY/MM/DD/LtSIF/oco2*.nc4")
   # /data/oco2/scf/product/B7???r/r0?/'
    # Parse command line arguments
    (options, args) = parser.parse_args()
    
    # start gridding
    grid(options, args)

if __name__ == "__main__":
    standalone_main()


