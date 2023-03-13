// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

// Maffaz 2023

// The F at 0 position is there to stop the state from resetting to zero.
// If this happens, it will cost upto 21k+ Gas to reinit to a positive integer in a mapping..
// numbers start from 1 and go to 63..
// We will use 1-49 for our lottery numbers which leaves a possible 14 slots for 'other' data.
/*
                     0123456789...                                 ...49............63*/
// bytes32 base = 0xF000000000000000000000000000000000000000000000000000000000000000;

// - example: 0xFF00F0F00000000000000000000000000F0000000000F000000000000000000F
// Use a starting mask ( `0xf << 0xfc`) - This will save us GAS as we don't need to execute the shift operation or initialise from 0.
// Pay 1 time on Deployment.  Then update costs only
// bytes32 public drawResult = 0xF000000000000000000000000000000000000000000000000000000000000000;

contract Lottery {
    // Slot 0x0
    // Log the numbers of a player for a game at id x
    // Players can only have 1 ticket per game.
    // Games are tracked and linked for searching.
    //  map
    //  0-39 = player Address (160 bits) 0x9f
    //  40-47 = ???
    //  48-51 = Prev Id of this User (game Id = 0x0)
    //  52-55 = Next Id of this user (game Id = 0x0)
    //  56-59 = Total number of games (gameId = 0x0)  (0xFFFF)
    //  60-63 = id game id 1-65535 (0xFFFF)
    mapping(bytes32 playerKey => bytes32 ticket) private playerTickets;

    // Slot 0x1
    // Store an encoded bytes at id x
    //  map
    //  0 = Stop bits (base) - beginning of every word
    //  1-49 = Winning Numbers
    //  50-60 = timestamp up to 1099511627775 which is > year 3999 :P
    //  61-64 = number of winners

    // 0xf | f00f0f00000000000000000000000000f0000000000f0000f | 006408f4f | f8401
    mapping(uint256 gameId => bytes32 gameData) private games;

    // Slot 0x2
    // How many users have played with a ticket.  We can use this to check if there are any winners.
    // Depending on the outcome by querying this map with the winning numbers word.
    mapping(bytes32 ticket => uint256 numberOfTickets) public ticketsInPlay;

    // Number of Games - Slot 0x3
    uint256 public gameId = 0x1; // initialise

    // min blocks before a draw can be set. - Slot 0x4
    uint40 public constant TS_OFFSET = 0x1;

    error DrawCanOnlyBeInTheFuture();
    error DrawDateHasNotPassed();
    error StartOrEndValueIncorrect();

    event NewTicketAdded(address indexed player, bytes32 numbers, uint32 indexed gameId);

    function getAllGames() public view returns (bytes32[] memory) {
        bytes32[] memory allGames = new bytes32[](gameId);
        unchecked {
            uint32 counter;
            for (uint256 i = 1; i < gameId+1; i++) {
                allGames[counter] = games[i];
                ++counter;
            }
        }
        return allGames;
    }

    function getGamesPagniate(uint32 start, uint32 end) public view returns (bytes32[] memory) {
        if (end > gameId || start == 0) revert StartOrEndValueIncorrect();
        bytes32[] memory allGames = new bytes32[](end-start);
        unchecked {
            uint32 counter;
            for (uint256 i = start; i < end; i++) {
                allGames[counter] = games[i];
                ++counter;
            }
        }
        return allGames;
    }

    // TODO: track and link ids..
    function getAllGamesOfPlayer(address _player) public view returns (bytes32[] memory) {
        uint256 LIMIT = 10;
        bytes32[] memory allPlayerGames = new bytes32[](LIMIT);
        unchecked {
            uint32 counter;
            for (uint32 i; i < gameId; i++) {
                bytes32 _playerNumbers = playerNumbers(_player, i);
                if (counter >= LIMIT) break;
                if (_playerNumbers != 0x0) {
                    assembly {
                        _playerNumbers := xor(_playerNumbers, i)
                    }
                    allPlayerGames[counter] = _playerNumbers;
                    ++counter;
                }
            }
        }
        return allPlayerGames;
    }

    function playerNumbers(address _player, uint32 _gameId) public view returns (bytes32 numbers) {
        assembly {
            // shift address and add the game id to player 'key'
            let shifted := shl(0x60, _player)
            let state := xor(shifted, _gameId)

            // Store player in memory scratch space.
            mstore(0x0, state)
            // Store slot number in scratch space after player.
            mstore(0x20, playerTickets.slot)
            // Create hash from player and slot
            let hash := keccak256(0x0, 0x40)

            // load and return the players ticket numbers.
            numbers :=
                and(sload(keccak256(0x0, 0x40)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000)
        }
    }

    function drawResultNumbers(uint32 _gameId) public view returns (bytes32 result) {
        assembly {
            // Store gameId in memory scratch space.
            mstore(0x0, _gameId)
            // Store slot number in scratch space after id.
            mstore(0x20, games.slot)
            // Create hash from gameId and slot
            result :=
                and(sload(keccak256(0x0, 0x40)), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000)
        }
    }

    function drawDate(uint32 _gameId) public view returns (uint64 result) {
        assembly {
            // Store gameId in memory scratch space.
            mstore(0x0, _gameId)
            // Store slot number in scratch space after id.
            mstore(0x20, games.slot)
            // Create hash from gameId and slot
            result :=
                and(
                    shr(16, sload(keccak256(0x0, 0x40))), 0x000000000000000000000000000000000000000000000000000000FFFFFFFFFF
                )
        }
    }

    function drawResultFull(uint32 _gameId) public view returns (bytes32 result) {
        assembly {
            // Store gameId in memory scratch space.
            mstore(0x0, _gameId)
            // Store slot number in scratch space after id.
            mstore(0x20, games.slot)
            // Create hash from gameId and slot
            result := sload(keccak256(0x0, 0x40))
        }
    }

    function addGame(uint40 drawDate) public {
        if (drawDate < block.number + TS_OFFSET) _revert(DrawCanOnlyBeInTheFuture.selector);

        assembly {
            let _gameId := sload(gameId.slot)

            //  inc gameId before we start messing with memory :P
            sstore(gameId.slot, add(_gameId, 1))

            // add id and block number
            let state := xor(shl(16, drawDate), 0xF000000000000000000000000000000000000000000000000000000000000000)
            // Store id in memory scratch space.
            mstore(0x0, _gameId)

            // Store slot number in scratch space after id.
            mstore(0x20, games.slot)

            // Store new state for the game.
            sstore(keccak256(0x0, 0x40), state)
        }
    }

    /// @dev PlaceHolder to create a bitmask of numbers to bytes32 word.
    /// Should come from a trusted VRF source such as onChain or chainlink (Oracle)
    /// Checks each position 1-49 to ensure that 6 unique positions exist.
    /// Here is where we do the check for '6 numbers'.  It means we only execute it 1 time.
    /// Because we are creating a bitmask, any winning tickets have to match EXACTLY with the positions on the mask.
    function addwinningTicket(uint32 _gameId) public {
        //                                   Plus 1 incase a 0 value is passed.
        if (block.number <= (drawDate(_gameId) + 1)) _revert(DrawDateHasNotPassed.selector);

        // Mock value but should be a 32 byte VRF from a trusted source on chain or oracle.
        uint256 randomNumber = 73333815688330388439497394924671604269744030172485877353949151816386893917160;

        assembly {
            // Random number selector mask.
            let randomMask := 0x00000000000000000000000000000000000000000000000000000000000000FF

            // Load current state, starting the same as `_base` 0xF000...0000
            let state
            let counter

            // Should not reach the max 64 unless we have a random number
            // with many repeating numbers but something to check.
            for { let i } lt(i, 64) { i := add(i, 1) } {
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
                // The first will be our stop bit 'F' at position '0'
                let shifted := shr(mul(pos, 4), 0xF000000000000000000000000000000000000000000000000000000000000000)

                // XOR to create a new state with the new position added.
                let xored := xor(state, shifted)

                // check if unique. If xored == state it means we have a duplicate
                if not(and(xored, state)) {
                    // Use OR to add our shifted digit to the state
                    state := xored

                    // increment counter by 1
                    counter := add(counter, 1)

                    // We hit 6? ->  break
                    if eq(6, counter) { break }
                }
            }

            // Store gameId in memory scratch space.
            mstore(0x0, _gameId)
            // Store slot number in scratch space after id.
            mstore(0x20, games.slot)
            // Create hash from gameId and slot
            let gameHash := keccak256(0x0, 0x40)

            let updatedTicket := xor(sload(gameHash), state)

            // save state to storage.
            sstore(gameHash, updatedTicket)

            // 0xf00ff0000ff00000000000000000000f000000000000f0000000000000000000
        }
    }

    /// @dev adds a bytes string of number locations 1-49.. .
    /// We dont check the numbers here, we want 6 and indeed, more than 6 can be passed.
    /// but only an Exact match of the numbers will return true using the drawResult Mask.
    /// @param ticketBytes bytes with selected number position as 'F'
    /// Example - 0xFF00F0F00000000000000000000000000F0000000000F000000000000000000F
    // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    // 0x10000000000000000000000000000000000000000
    function addPlayerTickets(bytes32 ticketBytes, uint32 _gameId) public {
        // 45162 / 8162 GAS - Normal Solidity..

        // Very small gas advantage here using assembly..
        // Only saving ~200

        // 44986 / 7986 GAS.
        // Hash Key (player) and slot (0)
        assembly {
            // shift address and add the game id to player 'key'
            // Store player in memory scratch space.
            mstore(0x0, xor(shl(0x60, caller()), _gameId))
            // Store slot number in scratch space after player.
            mstore(0x20, playerTickets.slot)
            // Create hash from player and slot
            let hash := keccak256(0x0, 0x40)

            // Store new ticket for the player.
            sstore(hash, ticketBytes)

            // Store player in memory scratch space.
            mstore(0x0, xor(ticketBytes, _gameId))

            // Store slot number in scratch space after id.
            mstore(0x20, ticketsInPlay.slot)
            // Create hash from gameId and slot
            let ticketHash := keccak256(0x0, 0x40)

            let newAmount := add(sload(ticketHash), 1)
            // Store new ticket for the player.
            sstore(ticketHash, newAmount)
        }

        emit NewTicketAdded(msg.sender, ticketBytes, _gameId);
    }

    /// @notice checks a ticket against the winning numbers
    /// @dev uses 'and' to compare the players bytes to the winning numbers bytes.
    ///      reverts on 0 state.
    /// @param player account to check the ticket for.
    /// @return result of the player if they have won or not.
    function checkWinner(address player, uint32 _gameId) public view returns (bool result) {
        assembly {
            // shift address and add the game id to player 'key'
            let shifted := shl(0x60, player)
            let playerKey := xor(shifted, _gameId)
            // Store player in memory scratch space.
            mstore(0x0, playerKey)
            // Store slot number in scratch space after player.
            mstore(0x20, playerTickets.slot)
            // Create hash from player and slot
            let playerTicketHash := keccak256(0x0, 0x40)

            // // Create hash from player and slot - load player ticket
            let playerTicketState :=
                and(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000, sload(playerTicketHash))

            // // check the state for 0 as we load this anyway
            // // We dont check winning numbers as even if it is zero,
            // // a non zero state will not return  0 when anded
            // // if the state is zero then anded will ALWAYS be true.
            if eq(playerTicketState, 0) { revert(0, 0) }

            // Store gameId in memory scratch space.
            mstore(0x0, _gameId)
            // Store slot number in scratch space after id.
            mstore(0x20, games.slot)
            // Create hash from gameId and slot
            let gameHash := keccak256(0x0, 0x40)

            // // Use 'and' to check the state against the winning numbers.
            // // any matching bits will create a new 32 byte word with only matching
            // // positions (or 0 if there are no matches).
            let anded :=
                and(
                    and(sload(gameHash), 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000),
                    playerTicketState
                )

            // result := anded

            // // Compare anded to our players numbers state.
            // // If they are an exact match, the result will be true and thus a winner.
            result := eq(anded, playerTicketState)
        }
    }

    /**
     * @dev For more efficient reverts.
     */
    function _revert(bytes4 errorSelector) internal pure {
        assembly {
            mstore(0x00, errorSelector)
            revert(0x00, 0x04)
        }
    }
}
