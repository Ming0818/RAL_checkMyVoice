__author__ = 'kimsavinfo'
'''
Socket Server :
- listen to the local port 30000
- waiting for a tcp/ip socket 
- tcp/ip socket format : 
	naoIP#naoPort#fileName1
	naoIP#naoPort#fileName1#fileName2#fileName3
- save the information in the matrice files_to_download.mat
'''

import scipy.io
import numpy as np
import socket

# Start server
socketListener = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
socketListener.bind(('', 30000))

isNAOReady = True
while isNAOReady:
		socketListener.listen(5)
		client, address = socketListener.accept()
		print "{} connected".format( address )
		
		response = client.recv(255)
		if response != "":
				print response
				# Get all infos from the socket
				data = response.split('|')
				print "NAO host "  + data[0]
				print "NAO port " + data[1]
				
				files_to_download = np.zeros(( len(data) ,), dtype=np.object)
				
				for iField in range(0, len(data)):
					print "SOCKET : data "+ str(iField) +" = "+data[iField]
					files_to_download[iField] = data[iField]
				
				# Save infos in the matrice
				scipy.io.savemat('files_to_download.mat', mdict={'files_to_download': files_to_download})

				isNAOReady = False
				
print "Close"
client.close()
socketListener.close()