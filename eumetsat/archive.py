#!/usr/bin/python

import os
import datetime
import re
import shutil
from stat import *

utc_gen_time = datetime.datetime.utcnow()

gen_day = utc_gen_time.strftime('%Y%m%d')

day_year = utc_gen_time.strftime('%Y')
day_month = utc_gen_time.strftime('%m')
day_day = utc_gen_time.strftime('%d')

def doArchive(data_dir, reobj):
    for fn in os.listdir(data_dir):
        fpath = os.path.join(data_dir, fn)
        m = reobj.match(fn)
        if m is not None:
            f_year = m.group(1)
            f_month = m.group(2)
            f_day = m.group(3)
            if f_year != day_year or f_month != day_month or f_day != day_day:
                archive_path = os.path.join(data_dir, f_year)
                archive_path = os.path.join(archive_path, f_month)
                archive_path = os.path.join(archive_path, f_day)
                if not os.path.exists(archive_path):
                    os.makedirs(archive_path)
                dst_fpath = os.path.join(archive_path, fn)
                os.rename(fpath, dst_fpath)

data_dir1='./data1/'
reobj1 = re.compile(r"msgce\.ir\.(\d{4})(\d{2})(\d{2})\.\d{4}\.\d\.jpg")
doArchive(data_dir1, reobj1)

data_dir2='./data2/'
reobj2 = re.compile(r"msgcz\.24M\.(\d{4})(\d{2})(\d{2})\.\d{4}\.\d\.jpg")
doArchive(data_dir2, reobj2)

    
