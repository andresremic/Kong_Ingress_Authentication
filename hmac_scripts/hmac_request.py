from kong_hmac import generate_request_headers
import requests


secret = b"hmac_secret"
key_id = "hmac-user"
url = "<$PROXY_IP>/bar"

get_request_headers = generate_request_headers(key_id, secret, url)
print (get_request_headers)
r = requests.get(url, headers=get_request_headers)
print('Response code: %d\n' % r.status_code)
print(r.text)

