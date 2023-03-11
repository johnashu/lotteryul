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

    uint40 maxTs = 1099511627775;
    uint40 blockNumber = 10_000_123;

    function setUp() public {
        lottery = new Lottery();
    }

    function testLottery(uint256 x) public {
        vm.roll(blockNumber);
        lottery.gameId();
        lottery.addGame(blockNumber + lottery.TS_OFFSET());
        lottery.drawResultNumbers(1);

        vm.prank(address(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2));
        vm.roll(blockNumber + lottery.TS_OFFSET() + lottery.TS_OFFSET());

        lottery.addPlayerTickets(winner, drawResult, 1);
        lottery.playerNumbers(winner, 1);

        lottery.addwinningTicket(1);
        lottery.ticketsInPlay(0xf00ff0000ff00000000000000000000f000000000000f0000000000000000001);
        bytes32 nums = lottery.drawResultNumbers(1);
        lottery.drawResultFull(1);

        lottery.checkWinner(winner, 1);
        assertEq(lottery.playerNumbers(winner, 1), nums);
        assertEq(lottery.ticketsInPlay(0xf00ff0000ff00000000000000000000f000000000000f0000000000000000001), 1);

        lottery.addPlayerTickets(loser, losingTicket, 1);
        lottery.playerNumbers(loser, 1);
        lottery.checkWinner(loser, 1);

        lottery.addPlayerTickets(loser, allOn, 1);
        lottery.checkWinner(loser, 1);

        lottery.addPlayerTickets(loser, allOff, 1);
        vm.expectRevert();
        lottery.checkWinner(loser, 1);
        lottery.gameId();
    }

    function testAddGame(uint256 x) public {
        for (uint32 i = 1; i < 10; i++) {
            lottery.gameId();
            lottery.addGame(blockNumber++);
            lottery.drawResultNumbers(i);
            lottery.drawDate(i);
            lottery.drawResultFull(i);
        }
    }

    function testFailDrawDateHasNotPassed() public {
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
