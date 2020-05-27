You can backup files to COS by using this image.

1. Add a cos config file named `.cos.conf`, with the content below, saved to `/root`
2. Write a backup shell script named `coscmd.sh` and saved to `/root`
3. Run a container from this image, it will automatically run the backup script at every day 2:00 pm
4. This image was made by surenkid.


`.cos.conf` example:
```
[common]
secret_id = secret_id
secret_key = secret_key
bucket = bucket-xxxxxx
region = ap-guangzhou
max_thread = 5
part_size = 1
retry = 5
timeout = 60
schema = https
verify = md5
anonymous = False
```
