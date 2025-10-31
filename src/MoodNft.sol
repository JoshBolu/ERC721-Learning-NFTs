// SPDX-License-Identifier:MIT SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    // errors
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private tokenCounter;
    string private sadSvgImageUri;
    string private happySvgImageUri;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private tokenIdToMood;

    constructor(
        string memory sadSvgImageUriInput,
        string memory happySvgImageUriInput
    ) ERC721("Mood NFT", "MN") {
        tokenCounter = 0;
        sadSvgImageUri = sadSvgImageUriInput;
        happySvgImageUri = happySvgImageUriInput;
    }

    function mintNft() public {
        _safeMint(msg.sender, tokenCounter);
        tokenIdToMood[tokenCounter] = Mood.HAPPY;
        tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        // only owner of NFT should be able to change the mood
        if (
            getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender
        ) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (tokenIdToMood[tokenId] == Mood.HAPPY) {
            tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = happySvgImageUri;
        } else {
            imageURI = sadSvgImageUri;
        }
        // ways to join strings and variables in solidity
        // string memory tokenMetaData = '{"name": "' name() '"}';
        // string memory tokenMetaData = abi.encodePacked'{"name": "', name() '"}';

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                name(),
                                '", "description": "An NFT that changes based on mood.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
