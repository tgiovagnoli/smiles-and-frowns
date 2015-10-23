import string,os,random

def is_array(value):
	print str( type(value) ) + " - " + str(type([]))
	return type(value)==type([])

def random_password(length=10):
    chars = string.ascii_uppercase + string.digits + string.ascii_lowercase
    chars += '!@#$%^&*'
    password = ''
    for i in range(length):
        password += chars[ ord(os.urandom(1)) % len(chars) ]
    return password

def invite_code(size=6,chars=string.ascii_uppercase+string.digits):
	return ''.join(random.choice(chars) for _ in range(size))