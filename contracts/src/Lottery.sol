// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

// Maffaz 2023

contract Lottery {
    // Slot 0
    // Log the numbers of a player
    mapping(address player => bytes32 ticket) public playerTickets;

    // Slot 1
    // How many users have played with a ticket.  We can use this to check if there are any winners.
    // Depending on the outcome by querying this map with the winning numbers word.
    mapping(bytes32 ticket => uint numberOfTickets) public ticketsInPlay;

    // The F at 0 position is there to stop the state from resetting to zero.
    // If this happens, it will cost upto 21k+ Gas to reinit to a positive integer..
    // numbers start from 1 and go to 63..
    // We will use 1-49 for our lottery numbers which leaves a possible 14 slots for 'other' data.
    /*
                     0123456789...                                 ...49............63*/
    bytes32 base = 0xF000000000000000000000000000000000000000000000000000000000000000; // slot 2

    //slot 3 - example: 0xFF00F0F00000000000000000000000000F0000000000F000000000000000000F
    // Use a starting mask ( `0xf << 252`) - This will save us GAS as we don't need to execute the shift operation or initialise from 0.
    // Pay 1 time on Deployment.  Then update costs only
    bytes32 public winningNumbers =
        0xF000000000000000000000000000000000000000000000000000000000000000;

    // Mock numbers to demo Array load. - slot 4
    uint256[] public winningNumbersArray = [1, 4, 6, 33, 44, 63];

    /// @dev PlaceHolder to create a bitmask of numbers to bytes32 word.
    /// Should come from a trusted VRF source such as onChain or chainlink (Oracle)
    /// Checks each position 1-49 to ensure that 6 unique positions exist.
    /// Here is where we do the check for '6 numbers'.  It means we only execute it 1 time.
    /// Because we are creating a bitmask, any winning tickets have to match EXACTLY with the positions on the mask.
    function addWinningNumbersUint() public {
        // Mock value but should be a 32 byte VRF from a trusted source on chain or oracle.
        uint256 randomNumber = 73333815688330388439497394924671604269744030172485877353949151816386893917160;
        assembly {
            // load base mask from storage.
            // This can also be hardcoded to save further gas if required.
            // 0xF000000000000000000000000000000000000000000000000000000000000000
            let _base := sload(base.slot)

            // Random number selector mask.
            let
                randomMask
            := 0x00000000000000000000000000000000000000000000000000000000000000FF

            // Load current state, starting the same as `_base` 0xF000...0000
            let state := sload(winningNumbers.slot)

            let counter

            // Should not reach the max 64 unless we have a random number
            // with many repeating numbers but something to check.
            for {
                let i
            } lt(i, 64) {
                i := add(i, 1)
            } {
                // each time we iterate, we will 'push' 4 bits off the end to find the next random number
                // Shift right by i * 4 bits
                let randomShift := shr(mul(i, 4), randomNumber)

                // isolate the number using AND with the mask to give us the last 8 bits.
                // this gives a number between 0-256 (0x00 - 0xFF)
                let randAnded := and(randomShift, randomMask)

                // Use modulo on our isolated number to find a number within our range 1-49
                // add 1 to ensure it is not 0.
                let pos := add(mod(randomShift, 48), 1)

                // Shift the 'on' bits (F) to the correct position using the 'base' mask
                let shifted := shr(mul(pos, 4), _base)

                // XOR to create a new state with the new position added.
                let xored := xor(state, shifted)

                // check if unique. If xored == state it means we have a duplicate
                if not(and(xored, state)) {
                    // Use OR to add our shifted digit to the state
                    state := xored

                    // increment counter by 1
                    counter := add(counter, 1)

                    // We hit 6? ->  break
                    if eq(6, counter) {
                        break
                    }
                }
            }
            // save state to storage.
            sstore(winningNumbers.slot, state)

            // 0xf00ff0000ff00000000000000000000f000000000000f0000000000000000000
        }
    }

    /// @dev Reset numbers to 0.
    /// Should come from a trusted VRF
    function resetWinningNumbers() public {
        winningNumbers = base;
    }

    /// @dev adds a bytes string of number locations.
    /// We dont check the numbers here, we want 6 and indeed, more than 6 can be passed.
    /// but only an Exact match of the numbers will return true using the winningNumbers Mask.
    /// @param ticketBytes bytes with selected number position as 'F'
    /// Example - 0xFF00F0F00000000000000000000000000F0000000000F000000000000000000F
    // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    function addPlayerTickets(address player, bytes32 ticketBytes) public {
        // 45162 / 8162 GAS - Normal Solidity..
        // Add player ticket to the map
        // playerTickets[player] = ticketBytes;

        // // Log the amount of tickets.
        // ++ticketsInPlay[ticketBytes];

        // Very small gas advantage here using assembly..
        // Only saving ~200

        // 44986 / 7986 GAS.
        // Hash Key (player) and slot (0)
        // bytes32 locationPlayerTickets = keccak256(abi.encode(player, 0));
        // bytes32 locationTicketsInPlay = keccak256(abi.encode(ticketBytes, 1));
        assembly {
            // Store player in memory scratch space.
            mstore(0, player)
            // Store slot number in scratch space after player.
            mstore(32, 0)
            // Create hash from previously stored player and slot
            let hash := keccak256(0, 64)

            // Store new ticket for the player.
            sstore(hash, ticketBytes)

            // Store ticketBytes in memory scratch space -
            // We can overwrite here as we are not returning but storing the value.
            mstore(0, ticketBytes)

            // Store slot number in scratch space after ticketBytes
            mstore(32, 1)

            // Create hash from previously stored ticketBytes and slot
            hash := keccak256(0, 64)

            // Store updated value
            sstore(hash, add(sload(hash), 1))
        }
    }

    /// @notice checks a ticket against the winning numbers
    /// @dev uses 'and' to compare the players bytes to the winning numbers bytes.
    ///      reverts on 0 state.
    /// @param player account to chcek the ticket for.
    /// @return result of the player if they have won or not.
    function checkWinner(address player) public view returns (bool result) {
        bytes32 _playerTickets = keccak256(abi.encode(player, 0x0)); //slot 0
        assembly {
            let state := sload(_playerTickets)
            // check the state for 0 as we load this anyway
            // We dont check winning numbers as even if it is zero,
            // a non zero state will not return  0 when anded
            // if the state is zero then anded will ALWAYS be true.
            if eq(state, 0) {
                revert(0, 0)
            }

            // Use 'and' to check the state against the winning numbers.
            // any matching bits will create a new 32 byte word with only matching
            // positions (or 0 if there are no matches).
            let anded := and(sload(winningNumbers.slot), state)

            // Compare anded to our players numbers state.
            // If they are an exact match, the result will be true and thus a winner.
            result := eq(anded, state)
        }
    }

    // Alternatives

    /// @dev PlaceHolder to add an array of numbers to bytes32 word.
    /// Use as a proxy to convert he storage -> Memory as vrf should come in memory if in an array.
    /// Should come from a trusted VRF source such as onChain or chainlink (Oracle)
    function addWinningNumbersArray() public {
        _addNumbersToBytesFromArray(winningNumbersArray);
    }

    function _addNumbersToBytesFromArray(uint256[] memory arr) public {
        assembly {
            // where array is stored in memory (0x80)
            let location := arr

            // length of array
            let length := mload(arr)

            // load our base mask from storage..
            //This can also be hardcoded to save further gas if required.
            let _base := sload(base.slot)

            // Load current state
            let state := sload(winningNumbers.slot)

            for {
                let i := 0
            } lt(i, length) {
                i := add(i, 1)
            } {
                // load item from the Array
                // arr[i], data offset = 0x20 (1st 32 is reserved for size) & i*32 (0x20) to pickup the right index
                let item := mload(add(arr, add(0x20, mul(i, 0x20))))

                // Calculate the position in hex
                let bit_pos := mul(item, 4)

                // Shift the 'on' bit (F) to the correct position
                let shifted := shr(bit_pos, _base)

                // XOR to create a new state
                state := xor(state, shifted)
            }
            // update the variable with the new numbers
            sstore(winningNumbers.slot, state)
        }
    }
}
