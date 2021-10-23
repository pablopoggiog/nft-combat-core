// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Game {
    struct Character {
        uint256 index;
        string name;
        uint256 hp;
        uint256 maxHp;
        string imageURI;
        uint256 attackDamage;
    }

    Character[] characters;

    constructor() {
        console.log("Hello world");
    }
}
