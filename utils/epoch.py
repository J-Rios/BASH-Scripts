import datetime

t0 = datetime.datetime(1970, 1, 1, 0, 0, 0, 0)
t1 = datetime.datetime.now()

print((t1-t0).total_seconds())
