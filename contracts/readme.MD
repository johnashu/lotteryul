# Yul Lottery


# Deploying

[https://book.getfoundry.sh/forge/deploying](https://book.getfoundry.sh/forge/deploying)

forge create Lottery --contracts src/Lottery.sol:Lottery --private-key  {PRIVATE_KEY} --rpc-url localhost:8545

forge create Lottery --contracts src/Lottery.sol:Lottery --private-key  {PRIVATE_KEY} --rpc-url https://api.harmony.one --legacy

# Harmony
Deployer: 0x63C32D60ae0687A379DbD0Eb5192E84Ba3C7886d
Deployed to: 0xeD54542F6CEbfaE00549541fB05E9a8adb388372
Transaction hash: 0x016b60074244adfa2163c227ac5e70a2d3a446380264756732ede7ec65d05e99


cast call 0xeD54542F6CEbfaE00549541fB05E9a8adb388372 "playerNumbers(address,uint32)" 0x63C32D60ae0687A379DbD0Eb5192E84Ba3C7886d 1 --rpc-url https://api.harmony.one

cast call 0xeD54542F6CEbfaE00549541fB05E9a8adb388372 "drawResultNumbers(uint32)" 1 --rpc-url https://api.harmony.one

cast call 0xeD54542F6CEbfaE00549541fB05E9a8adb388372 "getAllGames()"  --rpc-url https://api.harmony.one

cast call 0xeD54542F6CEbfaE00549541fB05E9a8adb388372 "gameId()" 

cast call 0xeD54542F6CEbfaE00549541fB05E9a8adb388372 "drawResultFull(uint32)"  1

cast call  0xeD54542F6CEbfaE00549541fB05E9a8adb388372 "drawDate(uint32)"  1 

cast call 0xeD54542F6CEbfaE00549541fB05E9a8adb388372 "addGame(uint40)"  39061700 --rpc-url https://api.harmony.one --legacy  --private-key  {PRIVATE_KEY} 

cast send --private-key  {PRIVATE_KEY} --from 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --value 1ether --nonce 7