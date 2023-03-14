from base import base, add_flag_to_position, check_num_flags
import random


status = base
winningNumbers = [1, 4, 6, 33, 44, 49]
for i in winningNumbers:
    status = add_flag_to_position(status, i)
    # status = add_flag_to_position(status, i) # 2 x to check that it does the _exists check..


print(hex(status))
check = 0xff00f0f00000000000000000000000000f0000000000f0000f00000000000000
c = check_num_flags(check, 6, status)
print(c)


randomNumber = 2929290459964961279215818016791723193587102244018403859363363849432929292929
            #  0x42c8d28844a29c5c4e2124caa5bf92d45e96fe044b13b2a148e60a25a148e60a25
            # 30207470459964961279215818016791723193587102244018403859363363849439350753829
print(len(bin(randomNumber)))

print('9'*80)

def duplicates(winningNumbers: list) -> bool:
    check = []
    for i in winningNumbers:
        if i in check:
            return False
    return True


winningNumbers = []
lastNum = 0
for i in range(0, 32):
    shifted = (randomNumber >> i * 8) ^ randomNumber
    res = (shifted % 40) + 1
    if res != lastNum: 
        if len(winningNumbers) < 6:
            winningNumbers.append(res)
            print(shifted & winningNumbers[i])
        else:
            break


print(hex(randomNumber))
print(shifted)
print(winningNumbers)

print('\ngenerate\n')
shr = randomNumber << 16
xor = randomNumber ^ shr
anded = xor & shr

print(hex(randomNumber))
print(hex(shr))
print(hex(xor))
print(hex(anded))

print(shr)
print(xor)

print(hex(0xFF00F0F00000000000000000000000000F0000000000F000000000000000000F & 0xFF00F0F00000000000000000000000000F0000000000F00000000000000000ff))


randomnumber = 0x679ed1402f705180e06e33a7aeb4a6fc94d5914ed79c6e62f9f17fc78b998a75281

randomnumber >> 2
print(hex(randomnumber >> 8))


0xff0f0f0 #state

0xff0f0f0 # 

0xff00000 # shifted

0xff00000

randomMask = 0x00000000000000000000000000000000000000000000000000000000000000FF
singleNum = (randomnumber >> 8) & randomMask
singleNum = singleNum % 49
print(hex(singleNum), singleNum)

print(1234121 & 0)

print(status)
print(hex(status))

from datetime import datetime 

# map
# 0 = Stop bit (base) - beginning of every word
# 1-49 = Numbers
# 50-60 = timestamp
# 61-64 = id
        #    0xf0000000000000000000000000000000000000000000000000006408ec210000

check =    0xff00f0f00000000000000000000000000f0000000000f0000f00000000000000

base =     0xF000000000000000000000000000000000000000000000000000000000000000
# Draw Date
date_pos = 0x00000000000000000000000000000000000000000000000000FFFFFFFFFF0000
         # 0xf00000000000000000000000000000000000000000000000000019023a460000
# Draw Id
id_mask  =    0x000000000000000000000000000000000000000000000000000000000000FFFF
numbersMask = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000 

ptr  =         0x000000000000000000000000000000000000000000000000000000000000FFFF
total_mask  =  0x00000000000000000000000000000000000000000000000000000000FFFF0000
prevId_mask  = 0x0000000000000000000000000000000000000000000000000000FFFF00000000
nextId_mask  = 0x000000000000000000000000000000000000000000000000FFFF000000000000
           
            # 0xab8483f64d9c6d1ecf9b849ae677dd3315835cb2000000000000000000000000
address_id0 = 0xff00f0f00000000000000000000000000f0000000000f0000f00000000000000



def addTimestamp(state: int) -> int:
    ts = int(datetime.now().timestamp())
    print(int(ts))

    return (ts << 0x10) ^ state # << 16

def addId(state:int) -> int:
    _id = random.randint(1,0xffff) # 65535 ids!
    # No shift required, these are the least significant bits.
    return _id ^ state

ts_added = addTimestamp(base)
id_added = addId(ts_added)
nums_added = 0xff00f0f00000000000000000000000000f0000000000f0000f00000000000000 | id_added


print(hex(ts_added))
print(hex(id_added))
print(hex(nums_added))

print((), 0x1f  << 0x9f)

print(hex(31337))
print(hex((0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 << 0x60 ) ^ 1))

print(id_mask)

hex_arr = 0xF00000000000000000000000000000000000000000000000000000000000000
base = 0xF00000000000000000000000000000000000000000000000000000000000000 
bit_pos = 12 * 4
shifted = base >> bit_pos
hex_arr = hex_arr ^ shifted

print(hex(hex_arr))


total_mask  =  0x000000000000000000000000000000000000000000000000000000000000FFFF
ptr_mask  =    0x00000000000000000000000000000000000000000000000000000000FFFF0000
prevId_mask  = 0x0000000000000000000000000000000000000000000000000000FFFF00000000
nextId_mask  = 0x000000000000000000000000000000000000000000000000FFFF000000000000
           
            # 0xab8483f64d9c6d1ecf9b849ae677dd3315835cb2000000000000000000000000
address_id0 = 0x0000000000000000000000000000000000000000000000000000000012345678

totalGames = address_id0 & total_mask
nextIdPointer = (address_id0 & ptr_mask) >> 0x10

print(hex(nextIdPointer))
print(hex(totalGames))

