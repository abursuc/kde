# KDE - Kernel Local Descriptors

This code implements the kernel local descriptors presented in "Kernel Local Descriptors with Implicit Rotation Matching" at ICMR 2015 <https://hal.inria.fr/hal-01145656>. 

<img src="imgs/kde_teaser.png"/>

KDE is distributed under the _____ License (see the LICENCE file).

## Setup

### Depedencies 

The code is written in MATLAB and works as standalone. 
Other extensions:

1. [Yael](http://yael.gforge.inria.fr/index.html) for optimized PCA learning and file reading/writing for the formats we use.
  - To download it's easiest to go [here]((http://yael.gforge.inria.fr/index.html)) and download the precompiled yael_matlab binaries for your OS (e.g. [yael_matlab_linux64_v438.tar.gz](https://gforge.inria.fr/frs/download.php/file/34218/yael_matlab_linux64_v438.tar.gz)) 
2. [Linear Discriminant Projections](http://cmp.felk.cvut.cz/~radenfil/projects/siamac.html) used for the HBench submission


## Citation

If you use this work please cite our publication  "Kernel Local Descriptors with Implicit Rotation Matching" from ICMR 2015 <https://hal.inria.fr/hal-01145656>: 

```
@inproceedings{Bursuc15,
  author    = {Bursuc, Andrei and Tolias, Giorgos and J{\'e}gou, Herv{\'e}},
  title     = {{Kernel Local Descriptors with Implicit Rotation Matching}},
  url       = {https://hal.inria.fr/hal-01145656},
  booktitle = {{ACM International Conference on Multimedia Retrieval }},
  year      = {2015}
  }
```
