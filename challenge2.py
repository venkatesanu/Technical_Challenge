import json
import requests
res = requests.get('http://169.254.169.254/latest/dynamic/instance-identity/document')
response= json.loads(res.text)
#print(res.json())
#print(type(response))
print("AWS EC2 instance metadata:")
print(response)
print("=========")
def data_key(mykey):
#for i in response:
#	print(i, response[i])
	print("Value for Entered data key->", mykey,"is", response[mykey])
#print("Print particular data key")
mykey = input("Enter particular data key:")
data_key(mykey)
