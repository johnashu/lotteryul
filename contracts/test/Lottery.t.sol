    // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/lottery.sol";

contract LotteryTest is Test {
    Lottery public lottery;
    address loser = makeAddr("LoserUser");
    address winner = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2; // makeAddr("winnerUser");
    bytes32 winnerHash = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2000000000000000000000001;
    bytes32 loserHash = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2000000000000000000000001;
    bytes32 losingTicket = 0xf0000000fff000000ff000000000000000000000000000000f00000000000000;
    bytes32 drawResult = 0xf00ff0000ff00000000000000000000f000000000000f0000000000000000000;
    bytes32 allOn = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    bytes32 allOff = 0x0;

    bytes32 _ticketsInPlay = 0xf00ff0000ff00000000000000000000f000000000000f0000000000000000001;

    uint256 ADD_BLOCKS = 100;

    uint40 maxTs = 1099511627775;

    function setUp() public {
        lottery = new Lottery();
    }

    function testLotteryFull() public {
        uint40 blockNumber = 10_000_120;
        vm.startPrank(winner);

        lottery.gameId();

        uint32 len = 10; //type(uint32).max - 1;

        for (uint32 i = 1; i < len; i++) {
            vm.roll(++blockNumber);
            lottery.addGame(blockNumber + lottery.TS_OFFSET());
            blockNumber++;

            vm.roll(blockNumber + lottery.TS_OFFSET() + lottery.TS_OFFSET());

            lottery.addPlayerTickets(drawResult, i);
            lottery.playerNumbers(winner, i);

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
        }

        lottery.gameId();

        lottery.getGamesPagniate(1, 10);
        lottery.getAllGamesOfPlayer(winner);
        lottery.getAllGamesOfPlayer(loser);
    }

    function testAddGame() public {
        uint40 blockNumber = 10_000_120;
        for (uint32 i = 1; i < 1000; i++) {
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
        lottery.addGame(maxTs + 1);
        emit log_uint(block.number);
    }

    function testFailAddGameDrawDateInPast() public {
        lottery.addGame(uint40(block.number - 1));
    }
}
