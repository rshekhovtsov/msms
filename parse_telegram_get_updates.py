import sys, json

for update in json.load(sys.stdin)['result']:
    from_=update['message']['from']
    print from_.get('id','<undefined>'), from_.get('first_name','<undefined>'),	from_.get('last_name','<undefined>'), from_.get('username','<undefined>')