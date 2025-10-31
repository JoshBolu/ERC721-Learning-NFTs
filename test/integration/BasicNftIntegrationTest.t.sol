// SPDX-License-Identifier:MIT SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "../../src/BasicNft.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";

contract BasicNftIntegrationTest is Test {
    BasicNft public basicNft;
    DeployBasicNft public deployer;

    address public joshua = makeAddr("joshua");
    address public ayo = makeAddr("ayo");

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        // Strings are an array of bytes(special types) and we can't compare arrays to arrays directly we can only compare primitive types like uints, bools, address, byte32
        // assert(expectedName == actualName);
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(joshua);
        basicNft.mintNft(PUG);

        assert(basicNft.balanceOf(joshua) == 1);
        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(PUG))
        );
    }

    function testTransferUpdatesRightBalances() public {
        vm.prank(joshua);
        basicNft.mintNft(PUG);

        vm.prank(joshua);
        basicNft.transfer(ayo, 0);

        assert(basicNft.balanceOf(ayo) == 1);
        assert(basicNft.balanceOf(joshua) == 0);
    }

    function testEmitTransferEventOnTransfer() public {
        vm.prank(joshua);
        basicNft.mintNft(PUG);

        vm.prank(joshua);
        vm.expectEmit(true, true, true, false, address(basicNft));
        emit Transfer(joshua, ayo, 0);
        basicNft.transfer(ayo, 0);
    }

    function testApproveAndTranferUpdatesCorrectly() public {
        vm.prank(joshua);
        basicNft.mintNft(PUG);

        vm.prank(joshua);
        basicNft.approve(ayo, 0);

        vm.prank(ayo);
        basicNft.transferFrom(joshua, ayo, 0);

        assert(basicNft.balanceOf(ayo) == 1);
        assert(basicNft.balanceOf(joshua) == 0);
    }

    function testApproveUpdatesInGetApproved() public {
        vm.prank(joshua);
        basicNft.mintNft(PUG);

        vm.prank(joshua);
        basicNft.approve(ayo, 0);

        address approvedAddress = basicNft.getApproved(0);

        assert(approvedAddress == ayo);
    }
}
