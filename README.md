# Benchmarks for climate data analysis
Use this repo to benchmark data analysis techniques across CDO, NCL, NCO, python, and julia. Matlab and IDL are the past so I'm not bothering with them ;)

## Interpolation tests
Setup is 4 times daily 100-day T42L40 resolution files, from dry dynamical core model.

* Time for NCL interpolation script with **automatic iteration**: ***70s exactly***
* Time for interpolation script with **explicit iteration through variables**: ***71s almost identical***
* Time for interpolation with CDO: ***30s pre-processing*** (probably due to inefficiency of overwriting original ncfile with file that dleetes coordinates), ***94s for setting things up*** (because we have to write surface geopotential to same massive file, instead of declaring as separate variable in NCL), and ***122s actual interpolation*** (with bunch of warnings) so ***216 total***

## Eddy flux term tests
### Macbook: 1 level, 1000 timesteps
Data used was generated with the `datagen` script via the line:
```
for reso in 5 2 1 0.5; do ./datagen $reso; done
```

Results are summarized in the below table. Turns out **NCL is much faster than all other tools**, to my surprise. Dask chunking didn't work well for small files. Note that using the NCL feature `setfileoption("nc", "Format", "LargeFile")` made absolutely **neglibile** difference in final wall-clock time, to my surprise. Also note there are no options to improve large file handling, recommendation is to split up by level or time; see [this NCL talk post](https://www.ncl.ucar.edu/Support/talk_archives/2011/2636.html) and [this stackoverflow post](https://stackoverflow.com/questions/44474507/read-large-netcdf-data-by-ncl).

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 7.4M (3) | XArray + no dask | **1.297** | 1.039 | 0.258 |
| 7.4M (3) | XArray + 100-timestep chunks | **1.116** | 0.913 | 0.179 |
| 7.4M (3) | XArray + 10-timestep chunks | **1.541** | 1.291 | 0.296 |
| 7.4M (3) | XArray + 1-timestep chunks | **6.515** | 5.640 | 1.481 |
| 7.4M (3) | CDO | **6.336** | 1.026 | 6.319 |
| 7.4M (3) | CDO + serial IO | **2.911** | 0.695 | 3.086 |
| 7.4M (3) | NCL | **0.604** | 0.325 | 0.082 |
| 7.4M (3) | NCO | **0.270** | 0.201 | 0.034 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 7.6M (4) | XArray + no dask | **1.110** | 1.075 | 0.192 |
| 7.6M (4) | XArray + 100-timestep chunks | **1.072** | 0.891 | 0.163 |
| 7.6M (4) | XArray + 10-timestep chunks | **1.552** | 1.355 | 0.298 |
| 7.6M (4) | XArray + 1-timestep chunks | **6.453** | 5.890 | 1.485 |
| 7.6M (4) | CDO | **6.495** | 2.001 | 6.801 |
| 7.6M (4) | CDO + serial IO | **2.471** | 1.290 | 1.936 |
| 7.6M (4) | NCL | **0.425** | 0.339 | 0.073 |
| 7.6M (4) | NCO | **0.302** | 0.258 | 0.035 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 30M (3) | XArray + no dask | **1.683** | 1.597 | 0.328 |
| 30M (3) | XArray + 100-timestep chunks | **1.089** | 0.935 | 0.193 |
| 30M (3) | XArray + 10-timestep chunks | **1.556** | 1.343 | 0.314 |
| 30M (3) | XArray + 1-timestep chunks | **6.336** | 5.609 | 1.462 |
| 30M (3) | CDO | **6.226** | 1.138 | 6.327 |
| 30M (3) | CDO + serial IO | **2.791** | 0.778 | 2.891 |
| 30M (3) | NCL | **0.929** | 0.790 | 0.131 |
| 30M (3) | NCO | **0.859** | 0.764 | 0.083 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 30M (4) | XArray + no dask | **1.305** | 1.547 | 0.294 |
| 30M (4) | XArray + 100-timestep chunks | **1.090** | 0.946 | 0.184 |
| 30M (4) | XArray + 10-timestep chunks | **1.575** | 1.405 | 0.317 |
| 30M (4) | XArray + 1-timestep chunks | **6.594** | 6.083 | 1.567 |
| 30M (4) | CDO | **6.519** | 2.045 | 6.873 |
| 30M (4) | CDO + serial IO | **2.389** | 1.359 | 1.785 |
| 30M (4) | NCL | **0.898** | 0.767 | 0.124 |
| 30M (4) | NCO | **0.935** | 0.822 | 0.102 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 82M (3) | XArray + no dask | **2.410** | 2.051 | 0.530 |
| 82M (3) | XArray + 100-timestep chunks | **1.217** | 1.277 | 1.661 |
| 82M (3) | XArray + 10-timestep chunks | **1.573** | 1.476 | 0.332 |
| 82M (3) | XArray + 1-timestep chunks | **6.432** | 5.781 | 1.606 |
| 82M (3) | CDO | **6.107** | 1.412 | 6.269 |
| 82M (3) | CDO + serial IO | **2.619** | 0.999 | 2.548 |
| 82M (3) | NCL | **2.194** | 1.894 | 0.286 |
| 82M (3) | NCO | **2.345** | 2.107 | 0.228 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 83M (4) | XArray + no dask | **1.485** | 1.925 | 0.405 |
| 83M (4) | XArray + 100-timestep chunks | **1.270** | 1.271 | 1.550 |
| 83M (4) | XArray + 10-timestep chunks | **1.549** | 1.446 | 0.323 |
| 83M (4) | XArray + 1-timestep chunks | **6.749** | 6.141 | 1.680 |
| 83M (4) | CDO | **6.372** | 2.189 | 6.736 |
| 83M (4) | CDO + serial IO | **2.472** | 1.512 | 1.806 |
| 83M (4) | NCL | **2.121** | 1.855 | 0.251 |
| 83M (4) | NCO | **2.391** | 2.158 | 0.223 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 185M (3) | XArray + no dask | **3.611** | 2.310 | 0.820 |
| 185M (3) | XArray + 100-timestep chunks | **1.624** | 2.984 | 2.802 |
| 185M (3) | XArray + 10-timestep chunks | **1.688** | 1.695 | 0.355 |
| 185M (3) | XArray + 1-timestep chunks | **6.736** | 6.137 | 1.764 |
| 185M (3) | CDO | **5.931** | 1.943 | 6.162 |
| 185M (3) | CDO + serial IO | **2.930** | 1.509 | 2.507 |
| 185M (3) | NCL | **4.687** | 4.054 | 0.615 |
| 185M (3) | NCO | **5.324** | 4.764 | 0.540 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 186M (4) | XArray + no dask | **1.868** | 2.135 | 0.637 |
| 186M (4) | XArray + 100-timestep chunks | **1.432** | 1.659 | 2.774 |
| 186M (4) | XArray + 10-timestep chunks | **1.692** | 1.669 | 0.370 |
| 186M (4) | XArray + 1-timestep chunks | **6.884** | 6.386 | 1.771 |
| 186M (4) | CDO | **6.251** | 2.501 | 6.511 |
| 186M (4) | CDO + serial IO | **2.604** | 1.697 | 1.894 |
| 186M (4) | NCL | **4.465** | 3.978 | 0.472 |
| 186M (4) | NCO | **5.269** | 4.740 | 0.509 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 330M (3) | XArray + no dask | **6.169** | 2.577 | 1.301 |
| 330M (3) | XArray + 100-timestep chunks | **1.923** | 2.453 | 4.830 |
| 330M (3) | XArray + 10-timestep chunks | **1.757** | 1.965 | 0.371 |
| 330M (3) | XArray + 1-timestep chunks | **6.774** | 6.396 | 1.763 |
| 330M (3) | CDO | **5.617** | 2.729 | 5.835 |
| 330M (3) | CDO + serial IO | **3.797** | 2.507 | 2.692 |
| 330M (3) | NCL | **8.363** | 7.185 | 1.148 |
| 330M (3) | NCO | **9.281** | 8.313 | 0.911 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 330M (4) | XArray + no dask | **2.931** | 2.399 | 0.997 |
| 330M (4) | XArray + 100-timestep chunks | **1.753** | 2.260 | 3.571 |
| 330M (4) | XArray + 10-timestep chunks | **1.783** | 1.910 | 0.412 |
| 330M (4) | XArray + 1-timestep chunks | **7.076** | 6.709 | 1.852 |
| 330M (4) | CDO | **6.355** | 3.090 | 6.704 |
| 330M (4) | CDO + serial IO | **3.283** | 2.304 | 2.350 |
| 330M (4) | NCL | **8.106** | 6.967 | 0.932 |
| 330M (4) | NCO | **9.216** | 8.305 | 0.869 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 742M (3) | XArray + no dask | **9.669** | 3.711 | 2.377 |
| 742M (3) | XArray + 100-timestep chunks | **3.238** | 5.851 | 7.868 |
| 742M (3) | XArray + 10-timestep chunks | **3.163** | 5.596 | 9.481 |
| 742M (3) | XArray + 1-timestep chunks | **6.901** | 7.175 | 1.808 |
| 742M (3) | CDO | **5.408** | 5.129 | 5.357 |
| 742M (3) | CDO + serial IO | **5.175** | 4.562 | 2.721 |
| 742M (3) | NCL | **18.155** | 15.812 | 2.284 |
| 742M (3) | NCO | **21.926** | 19.039 | 2.830 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 742M (4) | XArray + no dask | **3.906** | 3.081 | 1.500 |
| 742M (4) | XArray + 100-timestep chunks | **2.525** | 5.058 | 6.678 |
| 742M (4) | XArray + 10-timestep chunks | **2.701** | 4.965 | 8.274 |
| 742M (4) | XArray + 1-timestep chunks | **6.919** | 7.064 | 1.824 |
| 742M (4) | CDO | **5.316** | 3.897 | 5.787 |
| 742M (4) | CDO + serial IO | **3.548** | 3.140 | 2.561 |
| 742M (4) | NCL | **17.428** | 15.209 | 2.033 |
| 742M (4) | NCO | **21.820** | 19.057 | 2.715 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 1.3G (3) | XArray + no dask | **15.818** | 4.604 | 3.875 |
| 1.3G (3) | XArray + 100-timestep chunks | **4.342** | 9.189 | 11.659 |
| 1.3G (3) | XArray + 10-timestep chunks | **4.335** | 8.750 | 16.860 |
| 1.3G (3) | XArray + 1-timestep chunks | **7.248** | 8.445 | 1.860 |
| 1.3G (3) | CDO | **5.561** | 9.696 | 4.972 |
| 1.3G (3) | CDO + serial IO | **7.344** | 7.483 | 2.967 |
| 1.3G (3) | NCL | **31.795** | 27.663 | 3.807 |
| 1.3G (3) | NCO | **39.458** | 34.031 | 5.232 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 1.3G (4) | XArray + no dask | **7.732** | 3.709 | 3.510 |
| 1.3G (4) | XArray + 100-timestep chunks | **4.222** | 8.178 | 11.442 |
| 1.3G (4) | XArray + 10-timestep chunks | **4.159** | 9.086 | 14.940 |
| 1.3G (4) | XArray + 1-timestep chunks | **7.161** | 8.148 | 2.017 |
| 1.3G (4) | CDO | **6.070** | 6.765 | 6.089 |
| 1.3G (4) | CDO + serial IO | **4.537** | 5.301 | 2.957 |
| 1.3G (4) | NCL | **31.076** | 27.203 | 3.643 |
| 1.3G (4) | NCO | **38.764** | 33.702 | 4.999 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 2.9G (3) | XArray + no dask | **33.205** | 9.416 | 12.419 |
| 2.9G (3) | XArray + 100-timestep chunks | **11.477** | 23.268 | 20.029 |
| 2.9G (3) | XArray + 10-timestep chunks | **8.876** | 18.641 | 40.981 |
| 2.9G (3) | XArray + 1-timestep chunks | **8.703** | 12.396 | 2.311 |
| 2.9G (3) | CDO | **8.332** | 22.239 | 4.523 |
| 2.9G (3) | CDO + serial IO | **14.467** | 17.852 | 3.762 |
| 2.9G (3) | NCL | **83.779** | 63.280 | 16.465 |
| 2.9G (3) | NCO | **88.465** | 73.347 | 11.464 |

| size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- |
| 2.9G (4) | XArray + no dask | **16.529** | 6.211 | 8.986 |
| 2.9G (4) | XArray + 100-timestep chunks | **7.939** | 17.366 | 19.754 |
| 2.9G (4) | XArray + 10-timestep chunks | **6.618** | 14.956 | 28.725 |
| 2.9G (4) | XArray + 1-timestep chunks | **7.556** | 10.298 | 2.278 |
| 2.9G (4) | CDO | **6.169** | 12.271 | 4.140 |
| 2.9G (4) | CDO + serial IO | **6.150** | 11.162 | 3.127 |
| 2.9G (4) | NCL | **72.196** | 58.627 | 11.331 |
| 2.9G (4) | NCO | **85.414** | 74.449 | 10.379 |

### Macbook: 60 level, 200 timesteps
This time data was generated using
```
for reso in 10 7.5 5 3 2 1.5; do ./datagen $reso; done
```
since individual "timesteps" contain much more data.

These results were surprising: turned out **more pressure levels *significantly* slowed** the CDO operations. And I have no idea why. Maybe has to do with the particular operation used, e.g. the `-enlarge` calculated independently for each pressure level?

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 9 | 22M (3) | XArray + no dask | **1.850** | 1.637 | 0.381 |
| 9 | 22M (3) | XArray + 200 t chunks | **1.160** | 1.180 | 0.851 |
| 9 | 22M (3) | XArray + 50 t chunks | **1.117** | 0.937 | 0.181 |
| 9 | 22M (3) | XArray + 20 t chunks | **1.094** | 0.969 | 0.184 |
| 9 | 22M (3) | XArray + 10 t chunks | **1.234** | 1.006 | 0.203 |
| 9 | 22M (3) | XArray + 5 t chunks | **1.331** | 1.093 | 0.232 |
| 9 | 22M (3) | XArray + 2 t chunks | **1.594** | 1.394 | 0.334 |
| 9 | 22M (3) | XArray + 1 t chunks | **2.249** | 1.852 | 0.515 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 9 | 22M (3) | CDO | **62.858** | 9.241 | 62.275 |
| 9 | 22M (3) | CDO + serial IO | **34.465** | 7.605 | 34.887 |
| 9 | 22M (3) | NCL | **1.348** | 0.975 | 0.184 |
| 9 | 22M (3) | NCO | **0.933** | 0.813 | 0.079 |
| 9 | 22M (3) | NCO + no tmp file | **0.961** | 0.808 | 0.075 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 9 | 22M (4) | XArray + no dask | **1.998** | 1.911 | 0.382 |
| 9 | 22M (4) | XArray + 200 t chunks | **1.533** | 1.542 | 1.016 |
| 9 | 22M (4) | XArray + 50 t chunks | **1.463** | 1.263 | 0.253 |
| 9 | 22M (4) | XArray + 20 t chunks | **1.606** | 1.330 | 0.274 |
| 9 | 22M (4) | XArray + 10 t chunks | **1.791** | 1.378 | 0.287 |
| 9 | 22M (4) | XArray + 5 t chunks | **1.712** | 1.479 | 0.321 |
| 9 | 22M (4) | XArray + 2 t chunks | **2.330** | 1.956 | 0.485 |
| 9 | 22M (4) | XArray + 1 t chunks | **2.878** | 2.531 | 0.676 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 9 | 22M (4) | CDO | **fail** | **fail** | **fail** |
| 9 | 22M (4) | CDO + serial IO | **30.895** | 15.881 | 23.815 |
| 9 | 22M (4) | NCL | **1.026** | 0.890 | 0.118 |
| 9 | 22M (4) | NCO | **0.934** | 0.841 | 0.076 |
| 9 | 22M (4) | NCO + no tmp file | **0.951** | 0.852 | 0.080 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 18 | 89M (3) | XArray + no dask | **2.675** | 2.359 | 0.656 |
| 18 | 89M (3) | XArray + 200 t chunks | **1.840** | 2.108 | 1.420 |
| 18 | 89M (3) | XArray + 50 t chunks | **1.875** | 2.019 | 2.280 |
| 18 | 89M (3) | XArray + 20 t chunks | **1.917** | 2.060 | 2.546 |
| 18 | 89M (3) | XArray + 10 t chunks | **1.915** | 1.890 | 0.354 |
| 18 | 89M (3) | XArray + 5 t chunks | **2.023** | 1.968 | 0.384 |
| 18 | 89M (3) | XArray + 2 t chunks | **2.604** | 2.483 | 0.564 |
| 18 | 89M (3) | XArray + 1 t chunks | **3.776** | 3.526 | 0.935 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 18 | 89M (3) | CDO | **93.317** | 15.351 | 90.746 |
| 18 | 89M (3) | CDO + serial IO | **36.421** | 8.844 | 37.682 |
| 18 | 89M (3) | NCL | **4.405** | 3.676 | 0.531 |
| 18 | 89M (3) | NCO | **3.663** | 3.283 | 0.330 |
| 18 | 89M (3) | NCO + no tmp file | **3.232** | 2.912 | 0.293 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 18 | 89M (4) | XArray + no dask | **2.067** | 2.087 | 0.564 |
| 18 | 89M (4) | XArray + 200 t chunks | **1.498** | 1.963 | 1.713 |
| 18 | 89M (4) | XArray + 50 t chunks | **1.531** | 1.638 | 2.122 |
| 18 | 89M (4) | XArray + 20 t chunks | **1.545** | 1.634 | 2.528 |
| 18 | 89M (4) | XArray + 10 t chunks | **1.415** | 1.386 | 0.264 |
| 18 | 89M (4) | XArray + 5 t chunks | **1.585** | 1.519 | 0.308 |
| 18 | 89M (4) | XArray + 2 t chunks | **2.363** | 2.109 | 0.505 |
| 18 | 89M (4) | XArray + 1 t chunks | **3.225** | 3.010 | 0.790 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 18 | 89M (4) | CDO | **83.782** | 21.679 | 83.866 |
| 18 | 89M (4) | CDO + serial IO | **23.610** | 13.286 | 18.369 |
| 18 | 89M (4) | NCL | **3.115** | 2.665 | 0.341 |
| 18 | 89M (4) | NCO | **3.165** | 2.846 | 0.274 |
| 18 | 89M (4) | NCO + no tmp file | **3.165** | 2.854 | 0.275 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 24 | 158M (3) | XArray + no dask | **3.684** | 2.489 | 0.931 |
| 24 | 158M (3) | XArray + 200 t chunks | **1.941** | 3.718 | 1.388 |
| 24 | 158M (3) | XArray + 50 t chunks | **1.829** | 2.264 | 2.926 |
| 24 | 158M (3) | XArray + 20 t chunks | **1.840** | 2.245 | 3.066 |
| 24 | 158M (3) | XArray + 10 t chunks | **2.010** | 2.319 | 3.178 |
| 24 | 158M (3) | XArray + 5 t chunks | **1.923** | 2.012 | 0.376 |
| 24 | 158M (3) | XArray + 2 t chunks | **2.397** | 2.437 | 0.518 |
| 24 | 158M (3) | XArray + 1 t chunks | **4.513** | 4.310 | 1.100 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 24 | 158M (3) | CDO | **93.303** | 15.951 | 91.763 |
| 24 | 158M (3) | CDO + serial IO | **36.076** | 9.517 | 37.937 |
| 24 | 158M (3) | NCL | **5.310** | 4.495 | 0.570 |
| 24 | 158M (3) | NCO | **5.533** | 4.980 | 0.511 |
| 24 | 158M (3) | NCO + no tmp file | **5.321** | 4.789 | 0.500 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 24 | 158M (4) | XArray + no dask | **2.442** | 2.271 | 0.763 |
| 24 | 158M (4) | XArray + 200 t chunks | **2.085** | 2.897 | 1.967 |
| 24 | 158M (4) | XArray + 50 t chunks | **1.878** | 2.520 | 2.169 |
| 24 | 158M (4) | XArray + 20 t chunks | **1.814** | 2.093 | 2.429 |
| 24 | 158M (4) | XArray + 10 t chunks | **2.014** | 2.896 | 2.802 |
| 24 | 158M (4) | XArray + 5 t chunks | **2.047** | 2.068 | 0.442 |
| 24 | 158M (4) | XArray + 2 t chunks | **2.623** | 2.582 | 0.615 |
| 24 | 158M (4) | XArray + 1 t chunks | **3.468** | 3.313 | 0.843 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 24 | 158M (4) | CDO | **78.266** | 20.603 | 77.889 |
| 24 | 158M (4) | CDO + serial IO | **29.124** | 16.458 | 22.057 |
| 24 | 158M (4) | NCL | **6.164** | 5.233 | 0.629 |
| 24 | 158M (4) | NCO | **5.627** | 5.088 | 0.498 |
| 24 | 158M (4) | NCO + no tmp file | **4.865** | 4.414 | 0.432 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 36 | 356M (3) | XArray + no dask | **5.386** | 2.856 | 1.476 |
| 36 | 356M (3) | XArray + 200 t chunks | **2.900** | 4.700 | 2.781 |
| 36 | 356M (3) | XArray + 50 t chunks | **2.725** | 4.184 | 4.570 |
| 36 | 356M (3) | XArray + 20 t chunks | **2.607** | 3.707 | 6.256 |
| 36 | 356M (3) | XArray + 10 t chunks | **2.818** | 4.660 | 5.308 |
| 36 | 356M (3) | XArray + 5 t chunks | **3.756** | 5.638 | 5.971 |
| 36 | 356M (3) | XArray + 2 t chunks | **3.598** | 4.316 | 0.807 |
| 36 | 356M (3) | XArray + 1 t chunks | **3.686** | 4.191 | 0.915 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 36 | 356M (3) | CDO | **86.120** | 16.536 | 86.411 |
| 36 | 356M (3) | CDO + serial IO | **36.543** | 12.035 | 36.878 |
| 36 | 356M (3) | NCL | **12.972** | 11.161 | 1.460 |
| 36 | 356M (3) | NCO | **13.601** | 12.286 | 1.211 |
| 36 | 356M (3) | NCO + no tmp file | **12.030** | 10.868 | 1.119 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 36 | 356M (4) | XArray + no dask | **2.924** | 2.525 | 1.135 |
| 36 | 356M (4) | XArray + 200 t chunks | **2.301** | 3.403 | 3.604 |
| 36 | 356M (4) | XArray + 50 t chunks | **2.281** | 3.327 | 4.153 |
| 36 | 356M (4) | XArray + 20 t chunks | **2.333** | 4.330 | 3.885 |
| 36 | 356M (4) | XArray + 10 t chunks | **2.646** | 4.556 | 4.468 |
| 36 | 356M (4) | XArray + 5 t chunks | **2.802** | 4.621 | 5.220 |
| 36 | 356M (4) | XArray + 2 t chunks | **2.603** | 3.034 | 0.660 |
| 36 | 356M (4) | XArray + 1 t chunks | **3.122** | 3.370 | 0.787 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 36 | 356M (4) | CDO | **79.169** | 21.161 | 79.478 |
| 36 | 356M (4) | CDO + serial IO | **26.189** | 15.167 | 19.568 |
| 36 | 356M (4) | NCL | **10.746** | 9.450 | 1.186 |
| 36 | 356M (4) | NCO | **12.929** | 11.732 | 1.106 |
| 36 | 356M (4) | NCO + no tmp file | **11.360** | 10.296 | 1.005 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 60 | 989M (3) | XArray + no dask | **9.519** | 4.327 | 2.819 |
| 60 | 989M (3) | XArray + 200 t chunks | **6.384** | 9.653 | 5.718 |
| 60 | 989M (3) | XArray + 50 t chunks | **6.135** | 12.064 | 11.055 |
| 60 | 989M (3) | XArray + 20 t chunks | **6.488** | 12.156 | 12.298 |
| 60 | 989M (3) | XArray + 10 t chunks | **6.655** | 12.209 | 15.978 |
| 60 | 989M (3) | XArray + 5 t chunks | **6.807** | 12.613 | 16.791 |
| 60 | 989M (3) | XArray + 2 t chunks | **7.349** | 13.976 | 19.194 |
| 60 | 989M (3) | XArray + 1 t chunks | **6.080** | 8.592 | 1.520 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 60 | 989M (3) | CDO | **79.081** | 20.075 | 80.507 |
| 60 | 989M (3) | CDO + serial IO | **21.694** | 13.159 | 19.198 |
| 60 | 989M (3) | NCL | **31.795** | 27.746 | 3.571 |
| 60 | 989M (3) | NCO | **35.165** | 30.703 | 4.343 |
| 60 | 989M (3) | NCO + no tmp file | **36.595** | 31.913 | 4.520 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 60 | 989M (4) | XArray + no dask | **5.205** | 3.281 | 2.140 |
| 60 | 989M (4) | XArray + 200 t chunks | **5.711** | 8.548 | 5.936 |
| 60 | 989M (4) | XArray + 50 t chunks | **6.102** | 10.557 | 11.273 |
| 60 | 989M (4) | XArray + 20 t chunks | **5.945** | 10.100 | 10.858 |
| 60 | 989M (4) | XArray + 10 t chunks | **6.192** | 10.504 | 8.871 |
| 60 | 989M (4) | XArray + 5 t chunks | **8.126** | 12.315 | 10.254 |
| 60 | 989M (4) | XArray + 2 t chunks | **7.381** | 12.694 | 18.260 |
| 60 | 989M (4) | XArray + 1 t chunks | **4.726** | 6.402 | 1.615 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 60 | 989M (4) | CDO | **81.558** | 23.116 | 81.029 |
| 60 | 989M (4) | CDO + serial IO | **19.866** | 13.334 | 15.244 |
| 60 | 989M (4) | NCL | **28.179** | 23.592 | 3.626 |
| 60 | 989M (4) | NCO | **35.082** | 30.758 | 4.105 |
| 60 | 989M (4) | NCO + no tmp file | **34.482** | 30.119 | 4.008 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 90 | 2.2G (3) | XArray + no dask | **23.937** | 9.584 | 12.199 |
| 90 | 2.2G (3) | XArray + 200 t chunks | **19.511** | 17.259 | 17.254 |
| 90 | 2.2G (3) | XArray + 50 t chunks | **12.179** | 22.005 | 21.748 |
| 90 | 2.2G (3) | XArray + 20 t chunks | **10.709** | 23.701 | 22.772 |
| 90 | 2.2G (3) | XArray + 10 t chunks | **12.418** | 25.722 | 27.847 |
| 90 | 2.2G (3) | XArray + 5 t chunks | **16.109** | 27.997 | 20.911 |
| 90 | 2.2G (3) | XArray + 2 t chunks | **16.609** | 31.536 | 39.170 |
| 90 | 2.2G (3) | XArray + 1 t chunks | **13.299** | 26.672 | 45.581 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 90 | 2.2G (3) | CDO | **75.320** | 28.646 | 78.138 |
| 90 | 2.2G (3) | CDO + serial IO | **28.416** | 23.982 | 18.300 |
| 90 | 2.2G (3) | NCL | **76.985** | 60.432 | 13.390 |
| 90 | 2.2G (3) | NCO | **86.957** | 74.774 | 10.855 |
| 90 | 2.2G (3) | NCO + no tmp file | **88.198** | 76.474 | 10.995 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 90 | 2.2G (4) | XArray + no dask | **14.651** | 6.971 | 8.245 |
| 90 | 2.2G (4) | XArray + 200 t chunks | **14.631** | 15.453 | 16.103 |
| 90 | 2.2G (4) | XArray + 50 t chunks | **9.936** | 19.444 | 19.655 |
| 90 | 2.2G (4) | XArray + 20 t chunks | **9.412** | 18.550 | 18.795 |
| 90 | 2.2G (4) | XArray + 10 t chunks | **10.693** | 19.027 | 18.079 |
| 90 | 2.2G (4) | XArray + 5 t chunks | **13.548** | 23.398 | 19.477 |
| 90 | 2.2G (4) | XArray + 2 t chunks | **15.646** | 25.833 | 15.669 |
| 90 | 2.2G (4) | XArray + 1 t chunks | **18.741** | 30.060 | 30.747 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 90 | 2.2G (4) | CDO | **119.049** | 43.083 | 111.332 |
| 90 | 2.2G (4) | CDO + serial IO | **41.024** | 29.512 | 28.918 |
| 90 | 2.2G (4) | NCL | **129.229** | 80.965 | 28.766 |
| 90 | 2.2G (4) | NCO | **96.546** | 80.539 | 12.356 |
| 90 | 2.2G (4) | NCO + no tmp file | **78.907** | 65.833 | 11.634 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 120 | 3.9G (3) | XArray + no dask | **80.528** | 18.752 | 37.429 |
| 120 | 3.9G (3) | XArray + 200 t chunks | **124.813** | 35.979 | 74.355 |
| 120 | 3.9G (3) | XArray + 50 t chunks | **23.839** | 32.739 | 29.476 |
| 120 | 3.9G (3) | XArray + 20 t chunks | **34.452** | 44.120 | 48.859 |
| 120 | 3.9G (3) | XArray + 10 t chunks | **26.534** | 42.936 | 43.251 |
| 120 | 3.9G (3) | XArray + 5 t chunks | **30.255** | 49.303 | 51.679 |
| 120 | 3.9G (3) | XArray + 2 t chunks | **24.056** | 43.881 | 72.519 |
| 120 | 3.9G (3) | XArray + 1 t chunks | **24.733** | 48.332 | 92.443 |

| nlat | size (version) | name | real (s) | user (s) | sys (s) |
| --- | --- | --- | --- | --- | --- |
| 120 | 3.9G (3) | CDO | **102.655** | 66.191 | 92.321 |
| 120 | 3.9G (3) | CDO + serial IO | **70.412** | 49.457 | 28.073 |

### Linux test
To be added.

# Installation notes
## CDO for macOS
Was *exceedingly* difficult to get CDO compiled with threadsafe HDF5 like is the default case for Anaconda-downloaded versions on Linux. Used [this thread](https://code.mpimet.mpg.de/boards/2/topics/4630?r=5714#message-5714) for instructions. This required manually compiling HDF5 with custom `./configure` flags and custom prefix, then linking with homebrew using `brew link hdf5`.

Got frequent errors following user instructions, which disappeared by disabling `--with-pthread=/usr/local --enable-unsupported`. See discussion [here](http://hdf-forum.184993.n3.nabble.com/HDF5-parallel-and-threadsafe-td1701166.html) and Github reference to that discussion [here](https://github.com/conda-forge/hdf5-feedstock/pull/57).

I tried manually compiling the netcdf library but this seemed to make no difference -- the *provided* netcdf Homebrew library was the same.

<!-- In the end *could never* get the CDO to do NetCDF4 I/O parallelization without at least sporadic errors. However looks like *performance with thread locking is often faster anyway*. -->

