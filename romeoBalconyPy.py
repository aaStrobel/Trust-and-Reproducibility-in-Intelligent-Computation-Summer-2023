#Romeo's balcony.py

import socket

# Define Juliet's IP address, port, and Romeo's own port
juliet_ip = '10.10.0.101'
port = 12345
own_ip = '10.10.0.100'

# Create a new socket object and connect to Juliet's IP address and port
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((juliet_ip, port))

# Receive Juliet's message
juliet_msg = client_socket.recv(1024).decode()

print("Juliet:", juliet_msg)

# Romeo's response
romeo_msg = "O Romeo, Romeo! wherefore art thou Romeo?\nDeny thy father and refuse thy name;\nOr, if thou wilt not, be but sworn my love,\nAnd I’ll no longer be a Capulet."

# Send Romeo's response to Juliet
client_socket.send(romeo_msg.encode())

# Close the socket
client_socket.close()