#Juliet's balcony.py

import socket

# Define the host and the port you want to use
host = '10.10.0.101'
port = 12345

# Create a new socket object and bind it to the host and the port
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((host, port))

# Start listening to incoming requests
server_socket.listen()

print("Waiting for a connection...")

# Accept incoming requests and obtain the client socket object
(client_socket, client_address) = server_socket.accept()

print("Connected with:", client_address)

# Romeo's message
romeo_msg = "She speaks:\nO, speak again, bright angel! for thou art\nAs glorious to this night, being o'er my head\nAs is a winged messenger of heaven\nUnto the white-upturned wondering eyes\nOf mortals that fall back to gaze on him\nWhen he bestrides the lazy-pacing clouds\nAnd sails upon the bosom of the air."

# Send Romeo's message to the client
client_socket.send(romeo_msg.encode())

# Get the response from the client
juliet_msg = client_socket.recv(1024).decode()

print("Romeo:", juliet_msg)

# Close the socket
client_socket.close()
server_socket.close()