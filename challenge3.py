def find_inner_key(object,key):
    fs = (object.get(key))
    if fs:
        print(fs)
    else:
        for k, v in object.items():
            second_set_value = v.get(key, 0)
            if second_set_value:
                print(second_set_value)
            else:
                for k,v in object.items():
                    for i, j in v.items():
                        print(j[key])


object = {'x':{'y':{'z':'a'}}}
find_inner_key(object, key='x')
