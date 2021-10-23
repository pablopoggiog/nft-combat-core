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

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDamage
    ) {
        for (uint256 i = 0; i < characterNames.length; i++) {
            Character memory newCharacter = Character({
                index: i,
                name: characterNames[i],
                imageURI: characterImageURIs[i],
                hp: characterHp[i],
                maxHp: characterHp[i],
                attackDamage: characterAttackDamage[i]
            });

            characters.push(newCharacter);
        }
    }
}
