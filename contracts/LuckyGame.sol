// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract LuckyGame {
    // Define the owner of the smart contract
    address public owner;

    constructor() {
        console.log("Owner contract deployed by:", msg.sender);
        owner = msg.sender;
    }
}
