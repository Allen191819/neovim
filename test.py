import requests as req
import json


def test_get_all_users():
    url = "http://baidu.com"
    r = req.get(url)

    print(r.text)
    print(r.status_code)
    print(r.headers)
    
