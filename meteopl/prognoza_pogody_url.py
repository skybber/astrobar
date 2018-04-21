#!/usr/bin/python

import datetime

# Replace row=x,col=y by your location from map

url_template = "http://www.meteo.pl/um/metco/mgram_pict.php?ntype=0u&fdate={0}{1}&row=444&col=143&lang=en"
utc_gen_time = datetime.datetime.utcnow()-datetime.timedelta(hours=4)

gen_day = utc_gen_time.strftime('%Y%m%d')

if utc_gen_time.hour >= 18:
    round_hour = "18"
elif utc_gen_time.hour >= 12:
    round_hour = "12"
elif utc_gen_time.hour >= 6:
    round_hour = "06"
else:
    round_hour = "00"
print(url_template.format(gen_day, round_hour))
