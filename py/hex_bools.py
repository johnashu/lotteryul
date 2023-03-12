state = 0x00000000000000000000000000000000

allOff = 0x00000000000000000000000000000000
allOn = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

# Colours
red = 0xF0000000000000000000000000000000
green = 0x0F000000000000000000000000000000
blue = 0x00F00000000000000000000000000000
orange = 0x000F0000000000000000000000000000
black = 0x0000F000000000000000000000000000
white = 0x00000F00000000000000000000000000
purple = 0x000000F0000000000000000000000000
pink = 0x0000000F000000000000000000000000


# Land
zoneA = 0x00000000F00000000000000000000000
zoneB = 0x000000000F0000000000000000000000
zoneC = 0x0000000000F000000000000000000000
zoneD = 0x00000000000F00000000000000000000
zoneE = 0x000000000000F0000000000000000000
zoneF = 0x0000000000000F000000000000000000
zoneG = 0x00000000000000F00000000000000000
zoneH = 0x000000000000000F0000000000000000

# Character
hair = 0x0000000000000000F000000000000000
eyes = 0x00000000000000000F00000000000000
mouth = 0x000000000000000000F0000000000000
body = 0x0000000000000000000F000000000000
specs = 0x00000000000000000000F00000000000
ears = 0x000000000000000000000F0000000000
skin = 0x0000000000000000000000F000000000
nose = 0x00000000000000000000000F00000000

# Resources
ore = 0x000000000000000000000000F0000000
water = 0x0000000000000000000000000F000000
mine = 0x00000000000000000000000000F00000
gold = 0x000000000000000000000000000F0000
wood = 0x0000000000000000000000000000F000
farms = 0x00000000000000000000000000000F00
rent = 0x000000000000000000000000000000F0
ships = 0x0000000000000000000000000000000F

colours = (red, green, blue, orange, black, white, purple, pink)

allItems = [
    *colours,
    # Land
    zoneA,
    zoneB,
    zoneC,
    zoneD,
    zoneE,
    zoneF,
    zoneG,
    zoneH,
    # Character
    hair,
    eyes,
    mouth,
    body,
    specs,
    ears,
    skin,
    nose,
    # Resources
    ore,
    water,
    mine,
    gold,
    wood,
    farms,
    rent,
    ships,
]


def markTrueAtPosistion(pos):
    return state | pos


def markFalseAtPosistion(pos):
    return state ^ pos


def resetAll():
    return allOff


# for colour in colours:
#     state = markTrueAtPosistion(colour)
#     print(hex(state))

# for colour in colours:
#     state = markFalseAtPosistion(colour)
#     print(hex(state))

print("Marking True..")
for i in allItems:
    state = markTrueAtPosistion(i)
    state = markTrueAtPosistion(i)
    print(hex(state))

# print("\n\nMarking False..")

# for i in allItems[10:]:

#     state = markFalseAtPosistion(i)
#     print(hex(state))

# print(0x11111111111111111111111111111111111)


def display_hex_range():
    print(f"base =  0xf{''.join(['0'] *63)}")
    for i in range(63):
        h = ["0"] * 63
        h[i] = "f"
        print(f"bool{i+1} =  0xf{''.join(h)}")


display_hex_range()
