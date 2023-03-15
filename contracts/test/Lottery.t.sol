    // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/lottery.sol";

    // bytes32 winnerHash = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2000000000000000000000001;
    // bytes32 loserHash =  0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2000000000000000000000001;

contract LotteryTest is Test {
    Lottery public lottery;
    address loser = makeAddr("LoserUser");
    address winner = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2; // makeAddr("winnerUser");
    bytes32 losingTicket = 0xf0000000fff000000ff00000f000000000000000000000000000000000000000;
    bytes32 drawResult =   0xf00ff0000ff00000000000000000000f000000000000f0000000000000000000;
    bytes32 allOn = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    bytes32 allOff = 0x0;

    // bytes32 winnerZeroIndex = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb200000000000000000000;

    bytes32 _ticketsInPlay = 0xf00ff0000ff00000000000000000000f000000000000f0000000000000000001;

    uint256 ADD_BLOCKS = 100;

    uint40 maxTs = 1099511627775;

    function setUp() public {
        lottery = new Lottery();
    }

    function testLotteryFull(uint16 x) public {
        // vm.assume(i > 0 && i < type(uint16).max - 1);
        uint40 blockNumber = 10_000_120;
        vm.startPrank(winner);

        lottery.gameId();

        uint16 len = 2; // type(uint16).max - 1;

        for (uint16 i = 1; i < len; i++) {
            vm.roll(++blockNumber);
            lottery.addGame(blockNumber + lottery.TS_OFFSET());
            blockNumber++;

            vm.roll(blockNumber + lottery.TS_OFFSET() + lottery.TS_OFFSET());

            lottery.addPlayerTickets(drawResult, i);
            lottery.playerNumbers(winner, i);
            // lottery.playerMetaData(winner);

            emit log_uint(lottery.drawDate(i));
            emit log_uint(block.number);

            lottery.addwinningTicket(i);
            bytes32 nums = lottery.drawResultNumbers(i);
            lottery.drawResultFull(i);

            lottery.checkWinner(winner, i);
            assertEq(lottery.playerNumbers(winner, i), nums);
            assertEq(lottery.ticketsInPlay(_ticketsInPlay), 1);

            if (i % 5 == 0) {
                vm.stopPrank();
                vm.startPrank(loser);
                lottery.addPlayerTickets(losingTicket, i);
                lottery.playerNumbers(loser, i);
                vm.stopPrank();
                vm.startPrank(winner);
            }
            lottery.checkMatchedNumbers(winner, i);
            lottery.checkMatchedNumbers(loser, i);
        }

        lottery.gameId();

        lottery.getGamesPaginate(1, len);
        lottery.getAllGamesOfPlayer(winner);
        lottery.getAllGamesOfPlayer(loser);

        emit log_uint(type(uint16).max - 1);
    }

    function testAddGame() public {
        uint40 blockNumber = 10_000_120;
        for (uint16 i = 1; i < 1000; i++) {
            vm.roll(++blockNumber);
            lottery.addGame(blockNumber + lottery.TS_OFFSET());
            blockNumber++;
            vm.roll(blockNumber + lottery.TS_OFFSET() + lottery.TS_OFFSET());

            lottery.gameId();
            lottery.addwinningTicket(1);

            lottery.drawResultNumbers(i);
            lottery.drawDate(i);
            lottery.drawResultFull(i);
        }
    }

    function testFailDrawDateHasNotPassed() public {
        uint40 blockNumber = 10_000_120;
        vm.roll(109);
        lottery.gameId();
        lottery.addGame(blockNumber++);
        lottery.addwinningTicket(1);
    }

    function testFailAddGameOverflow() public {
        lottery.addGame(maxTs + 10);
        emit log_uint(block.number);
    }

    function testFailAddGameDrawDateInPast() public {
        lottery.addGame(uint40(block.number - 1));
    }
}
