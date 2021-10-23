// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./libraries/Base64.sol";

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

    struct Boss {
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    Boss public boss;

    event NFTMinted(address sender, uint256 tokenId, uint256 characterIndex);
    event AttackComplete(uint256 newBossHp, uint256 newPlayerHp);

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDamage,
        string memory bossName,
        string memory bossImageURI,
        uint256 bossHp,
        uint256 bossAttackDamage
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

            boss = Boss({
                name: bossName,
                imageURI: bossImageURI,
                hp: bossHp,
                maxHp: bossHp,
                attackDamage: bossAttackDamage
            });
        }

        // I start from 1, as non-initialized keys in holderToNft will have default value 0 and I need to a realiable way to check whether they were initialized or not
        _tokenIds.increment();
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory output)
    {
        Character memory charAttributes = allNfts[_tokenId];

        string memory hp = Strings.toString(charAttributes.hp);
        string memory maxHp = Strings.toString(charAttributes.maxHp);
        string memory attackDamage = Strings.toString(
            charAttributes.attackDamage
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        charAttributes.name,
                        " -- NFT #: ",
                        Strings.toString(_tokenId),
                        '", "description": "This is an NFT that lets people play in the game NFT Combat!", "image": "',
                        charAttributes.imageURI,
                        '", "attributes": [ { "trait_type": "Health Points", "value": ',
                        hp,
                        ', "max_value":',
                        maxHp,
                        '}, { "trait_type": "Attack Damage", "value": ',
                        attackDamage,
                        "} ]}"
                    )
                )
            )
        );

        output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
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

        emit NFTMinted(msg.sender, newItemId, _characterIndex);
    }

    function attackBoss() public {
        uint256 nftTokenIdOfPlayer = holderToNft[msg.sender];

        Character storage player = allNfts[nftTokenIdOfPlayer];

        console.log(
            "\nPlayer with character %s about to attack. Has %s HP and %s AD",
            player.name,
            player.hp,
            player.attackDamage
        );
        console.log(
            "Boss %s has %s HP and %s AD",
            boss.name,
            boss.hp,
            boss.attackDamage
        );

        // Check that any of the fighters is already dead
        require(player.hp > 0, "Character must have HP to attack");

        require(boss.hp > 0, "Boss must have HP to be attacked");

        // The player attacks
        if (boss.hp < player.attackDamage) {
            boss.hp = 0;
        } else {
            boss.hp = boss.hp - player.attackDamage;
        }

        // The boss attacks back
        if (player.hp < boss.attackDamage) {
            player.hp = 0;
        } else {
            player.hp = player.hp - boss.attackDamage;
        }

        console.log(
            " New boss HP: %s\n New player HP: %s\n",
            boss.hp,
            player.hp
        );

        emit AttackComplete(boss.hp, player.hp);
    }

    function checkIfUserHasNFT() public view returns (Character memory) {
        uint256 nftTokenIdOfPlayer = holderToNft[msg.sender];

        // Return the character if the user has one, otherwise return a new empty one
        if (nftTokenIdOfPlayer > 0) return allNfts[nftTokenIdOfPlayer];
        else {
            Character memory emptyCharacter;
            return emptyCharacter;
        }
    }

    function getAllCharacters() public view returns (Character[] memory) {
        return characters;
    }

    function getBoss() public view returns (Boss memory) {
        return boss;
    }
}
