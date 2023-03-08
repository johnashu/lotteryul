from base import (
    base,
    full,
    add_flag_to_position,
    remove_flag_to_position,
    _exists,
    check_num_flags,
)

status = base

status1 = add_flag_to_position(status, 63)
print(hex(status1))

status2 = add_flag_to_position(status1, 6)
print(hex(status2))

status3 = add_flag_to_position(status2, 11)
print(hex(status3))

status = base
for i in range(1, 64):
    pre = _exists(status, i)
    status = add_flag_to_position(status, i)
    print(pre, i, hex(status))
    status = add_flag_to_position(status, i)
    post = _exists(status, i)
    print(pre, i, hex(status), post)

status = full
for i in range(1, 64):
    pre = _exists(status, i)
    status = remove_flag_to_position(status, i)
    print(pre, i, hex(status))
    status = remove_flag_to_position(status, i)
    post = _exists(status, i)
    print(pre, i, hex(status), post)
