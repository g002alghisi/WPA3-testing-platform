# Conf folder
Here's a copy of the original configuration folder `/etc/freeradius/3.0/`, made in order
to work without modifying the original ones. The process used to prepare them is the following:
```shell
# 1. Copy anything from /etc/freeradius/3.0/
sudo cp -r /etc/freeradius/3.0/ .

# 2. Change owner and group
sudo chown -R user_name:freeradius *
```

Please notice that, as specified in the original FreeRADIUS guide, these files should be
modified as few as possible.

