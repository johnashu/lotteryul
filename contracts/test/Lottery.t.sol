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
    bytes32 losingTicket = 0xF000F0F0000000000FF0000000000000000000000000F000000000000000000F;
    bytes32 winningTicket = 0xff00f0f00000000000000000000000000f0000000000f0000f00000000000000;
    bytes32 allOn = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    bytes32 allOff = 0x0;

    uint40 maxTs = 1099511627775;
    uint40 blockNumber = 10_000_000;

    function setUp() public {
        lottery = new Lottery();
    }

    function testLottery(uint256 x) public {
        vm.roll(109);
        vm.prank(address(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2));
        lottery.addwinningTicketUint();
        bytes32 nums = lottery.winningTicket();

        lottery.addPlayerTickets(winner, winningTicket, 1);
        lottery.playerTickets(winnerHash);

        lottery.checkWinner(winnerHash);
        assertEq(lottery.playerTickets(winningTicket), nums);

        lottery.addPlayerTickets(loser, losingTicket, 1);
        lottery.playerTickets(losingTicket);
        lottery.checkWinner(loserHash);

        lottery.addPlayerTickets(loser, allOn, 1);
        lottery.checkWinner(loserHash);

        lottery.addPlayerTickets(loser, allOff, 1);
        vm.expectRevert();
        lottery.checkWinner(loserHash);
    }

    function testAddGame(uint256 x) public {
        for (uint256 i = 1; i < 10; i++) {
            lottery.gameId();
            lottery.addGame(blockNumber++);
            lottery.games(i);
        }
    }

    function testFailAddGameOverflow() public {
        lottery.addGame(maxTs + 1);
        emit log_uint(block.number);
    }

    function testFailAddGameDrawDateInPast() public {
        lottery.addGame(uint40(block.number - 1));
    }
}
