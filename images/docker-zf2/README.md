This is forked from maglnet/docker-zf2, add these php extensions:

- php5-pgsql
- php5-imagick
- php5-memcached

How to use:
* location to zend framework 2 code dir
* run commander `docker run -d -p 80:80 -v $(pwd):/zf2-app surenkid/docker-zf2` (if your develop environment is windows,use `docker run -d -p 80:80 -v %cd%:/zf2-app surenkid/docker-zf2` instead)
