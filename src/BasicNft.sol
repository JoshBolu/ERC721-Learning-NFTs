// SPDX-License-Identifier:MIT SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private tokenCounter;
    mapping(uint256 => string) private tokenIdToUri;

    constructor() ERC721("Dogie", "DOG") {
        tokenCounter = 0;
    }

    function mintNft(string memory tokenUri) public {
        tokenIdToUri[tokenCounter] = tokenUri;
        _safeMint(msg.sender, tokenCounter);
        tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return tokenIdToUri[tokenId];
    }

    function transfer(address to, uint256 tokenId) public {
        _transfer(msg.sender, to, tokenId);
    }
}

// https://ipfs.io/ipfs/bafybeibc5sgo2plmjkq2tzmhrn54bk3crhnc23zd2msg4ea7a4pxrkgfna/8456 = ipfs://bafybeibc5sgo2plmjkq2tzmhrn54bk3crhnc23zd2msg4ea7a4pxrkgfna/8456 this is the format youll need to view the NFT metadata and image(https://ipfs.io/ipfs)

// ipfs:// - is the identifier for ipfs(URI)
// https://ipfs.io - is the location of the ipfs gateway(URL)
