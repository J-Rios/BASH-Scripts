import socket
import struct
import sys
import time

REF_TIME_1970 = 2208988800

def ntp_get_date(addr, port=123):
	client = socket.socket( socket.AF_INET, socket.SOCK_DGRAM )
	client.settimeout(10)
	data = b'\x1b' + 47 * b'\0'
	client.sendto( data, (addr, port))
	try:
		data, address = client.recvfrom( 1024 )
	except Exception as e:
		print("Error: {}".format(e))
		return "Can't connect to NTP Server"
	if (data is None) or (len(data) == 0):
		return "No data received from NTP Server"
	ts = struct.unpack( '!12I', data )[10]
	ts = ts - REF_TIME_1970
	return time.ctime(ts)

if __name__ == "__main__":
	addr = "time.nist.gov"
	port = 123
	if len(sys.argv) > 1:
		addr = sys.argv[1]
	if len(sys.argv) > 2:
		port = int(sys.argv[2])
	date = ntp_get_date(addr, port)
	print(date)
