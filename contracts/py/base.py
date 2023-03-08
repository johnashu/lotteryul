base = 0xF000000000000000000000000000000000000000000000000000000000000000
full = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF


def bytes_to_array(state: int) -> list:
    rtn = []
    splitted = str(hex(state))
    for b in splitted[2:]:
        rtn.append(1 if b.upper() == "F" else 0)
    return rtn


def bytes_to_arrays(state: int, _split: int) -> list:
    rtn = []
    splitted = str(hex(state))
    zone = []
    for i, b in enumerate(splitted[3:]):
        if i % _split == 0:
            rtn.append(zone)
            zone = []
        zone.append(1 if b.upper() == "F" else 0)
    return rtn


def _exists(state: int, pos: int) -> bool:
    bit_pos = pos * 4
    shifted = base >> bit_pos
    anded = state & shifted
    return anded == shifted


def add_flag_to_position(state: int, pos: int) -> int:
    if _exists(state, pos):
        return state
    if pos > 63:
        return state
    bit_pos = pos * 4
    shifted = base >> bit_pos
    return state ^ shifted


def remove_flag_to_position(state: int, pos: int) -> int:
    if not _exists(state, pos):
        return state
    if pos > 63:
        return state
    bit_pos = 4 * pos
    shifted = base >> bit_pos
    return state ^ shifted


def check_num_flags(check: int, amount: int, state: int) -> bool:
    count = 0
    # skip 0 as that is our init bit
    for i in range(1, 64):
        if _exists(check, i):
            count += 1

    return count == amount and check == state
