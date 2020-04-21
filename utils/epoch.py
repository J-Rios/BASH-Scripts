from sys import argv
from datetime import datetime as dt_datetime

year=1970
if len(argv) >= 2:
    year = int(argv[1])

t0 = dt_datetime(year, 1, 1, 0, 0, 0, 0)
t1 = dt_datetime.now()

print("Seconds since 01/01/{}".format(year))
print((t1-t0).total_seconds())
