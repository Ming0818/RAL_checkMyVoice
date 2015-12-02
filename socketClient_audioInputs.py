import socket

'''
Socket Client
Send a string to the local port 30000
This file is only here for the tests
'''

hote = socket.gethostname()
port = 30000

socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
socket.connect((hote, port))
print "Connection on {}".format(port)

# socket.send(u"192.168.1.23#1234#recognize_arnaud_exist.ogg")
# socket.send(u"192.168.1.23#1234#train_arnaud_144803047522.ogg#train_arnaud_144803049784.ogg#train_arnaud_144803051339.ogg")
# socket.send(u"ftp.kimsavinfo.fr#21#train_arnaud_144803047522.ogg#train_arnaud_144803049784.ogg#train_arnaud_144803051339.ogg")
socket.send(u"ftp.kimsavinfo.fr#21#recognize_arnaud_exist.ogg")

print "Close"
socket.close()