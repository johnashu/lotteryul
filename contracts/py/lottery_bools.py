from base import base, add_flag_to_position, check_num_flags
import random

status = base
winningNumbers = [1, 4, 6, 33, 44, 63]
for i in winningNumbers:
    status = add_flag_to_position(status, i)
    # status = add_flag_to_position(status, i) # 2 x to check that it does the _exists check..


print(hex(status))
check = 0xFF00F0F00000000000000000000000000F0000000000F000000000000000000F
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