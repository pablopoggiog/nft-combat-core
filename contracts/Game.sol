// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Game is ERC721 {
    struct Character {
        uint256 index;
        string name;
        uint256 hp;
        uint256 maxHp;
        string imageURI;
        uint256 attackDamage;
    }

    Character[] characters;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint256 => Character) public allNfts;

    mapping(address => uint256) public holderToNft;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDamage
    ) ERC721("Fighters", "FIGHTER") {
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

            console.log(
                "Done initializing %s with HP %s, img %s",
                characters[i].name,
                characters[i].hp,
                characters[i].imageURI
            );
        }

        // So we start with 1
        _tokenIds.increment();
    }

    function mintNFT(uint256 _characterIndex) external {
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        allNfts[newItemId] = Character({
            index: _characterIndex,
            name: characters[_characterIndex].name,
            imageURI: characters[_characterIndex].imageURI,
            hp: characters[_characterIndex].hp,
            maxHp: characters[_characterIndex].hp,
            attackDamage: characters[_characterIndex].attackDamage
        });

        console.log(
            "Minted NFT with tokenId %s and characterIndex %s",
            newItemId,
            _characterIndex
        );

        holderToNft[msg.sender] = newItemId;

        _tokenIds.increment();
    }
}
