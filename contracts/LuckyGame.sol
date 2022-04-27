// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract LuckyGame {
    // Define the owner of the smart contract
    address payable private owner;

    uint256 public prize;
    uint256 public counter;
    uint256 private ROUNDS;
    uint256 public rewards;

    mapping(address => uint256) public deposits;

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    constructor() {
        console.log("Owner contract deployed by:", msg.sender);
        owner = payable(msg.sender);
        prize = 0;
        counter = 0;
        rewards = 0;
        ROUNDS = 3;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function changeOwner(address payable newOwner) public isOwner {
        owner = newOwner;
    }

    function _getRewards() private {
        console.log("Get Profits:", rewards);
        console.log("Owner:", owner);
        uint256 rewardsCopy = rewards;
        rewards = 0;
        owner.transfer(rewardsCopy);
    }

    function _pay(address payable winnerAddress) private {
        console.log("Pay the winner!:", winnerAddress);
        uint256 prizeCopy = prize;
        prize = 0;
        winnerAddress.transfer(prizeCopy);
    }

    function _withdraw(address payable winnerAddress) private {
        console.log("withdraw called:", counter);
        // send rewards to the owner wallet
        _pay(winnerAddress);
        _getRewards();
        // Reset parametes!!!!
        counter = 0;
    }

    function _updatePrize(uint256 amount) private {
        prize += (amount / 10) * 8;
        rewards += (amount / 10) * 2;
    }

    function _check(address payable playerAddress, uint256 amount) private {
        console.log("Counter called:", counter);
        counter = counter + 1;

        deposits[playerAddress] += amount;
        _updatePrize(amount);

        if (counter == ROUNDS) {
            console.log("We got the winner!!!", playerAddress);
            _withdraw(playerAddress);
        }
    }

    function bet() public payable {
        require(msg.value > 1 wei);
        // map players and deposits
        address payable playerAddress = payable(msg.sender);
        _check(playerAddress, msg.value);
    }
}
