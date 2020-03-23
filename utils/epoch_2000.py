import datetime

t0 = datetime.datetime(2000, 1, 1, 0, 0, 0, 0)
t1 = datetime.datetime.now()

print((t1-t0).total_seconds())
