// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/lottery.sol";

contract LotteryTest is Test {
    Lottery public lottery;
    address loser = makeAddr("LoserUser");
    address winner = makeAddr("WinnerUser");
    bytes32 losingNumbersArray = 0xF000F0F0000000000FF0000000000000000000000000F000000000000000000F;
    bytes32 winningNumbersArray = 0xFF00F0F00000000000000000000000000F0000000000F000000000000000000F;
    bytes32 losingNumbers = 0xF000F0F0000000000FF0000000000000000000000000F000000000000000000F;
    bytes32 winningNumbers = 0xf00ff0000ff00000000000000000000f000000000000f0000000000000000000;
    bytes32 allOn = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    bytes32 allOff = 0x0;

    function setUp() public {
        lottery = new Lottery();
    }

    function testLottery(uint256 x) public {
        vm.roll(109);
        lottery.addWinningNumbersUint();
        bytes32 nums = lottery.winningNumbers();

        lottery.addPlayerTickets(winner, winningNumbers);
        lottery.playerTickets(winner);

        lottery.checkWinner(winner);
        assertEq(lottery.playerTickets(winner), nums);

        lottery.addPlayerTickets(loser, losingNumbers);
        lottery.playerTickets(loser);
        lottery.checkWinner(loser);

        lottery.addPlayerTickets(loser, allOn);
        lottery.checkWinner(loser);

        lottery.resetWinningNumbers();

        lottery.addPlayerTickets(loser, allOff);
        vm.expectRevert();
        lottery.checkWinner(loser);
    }

    function testLotteryArray() public {
        lottery.addWinningNumbersArray();
        bytes32 nums = lottery.winningNumbers();

        lottery.addPlayerTickets(winner, winningNumbersArray);
        lottery.playerTickets(winner);

        lottery.checkWinner(winner);
        assertEq(lottery.playerTickets(winner), nums);

        lottery.addPlayerTickets(loser, losingNumbersArray);
        lottery.playerTickets(loser);
        lottery.checkWinner(loser);

        lottery.addPlayerTickets(loser, allOn);
        lottery.checkWinner(loser);

        lottery.addPlayerTickets(loser, allOff);
        vm.expectRevert();
        lottery.checkWinner(loser);
    }
}
