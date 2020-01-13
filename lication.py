#!/usr/bin/env python

import requests

SHA1 = "30b5f49d7203600afd271c65b288024d8beb5859"
url = 'http://18.218.151.201:8082/sha/SHA1'

data = requests.get(url).json
print data()['scanStatus']
