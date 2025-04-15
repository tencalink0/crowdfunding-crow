//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "forge-std/Test.sol";
import "../src/Crowdfunding.sol";

contract CrowdFundingTest is Test {
    CrowdFunding public crowdfunding;
    address public cand1;
    address public cand2;
    address public addr1;
    address public addr2;
    address public addr3;

    uint public id1;
    uint public id2;

    function setUp() public {
        cand1 = address(0x001);
        cand2 = address(0x002);
        addr1 = address(0x003);
        addr2 = address(0x004);
        addr3 = address(0x005);

        vm.deal(addr1, 100 ether);
        vm.deal(addr2, 100 ether);
        vm.deal(addr3, 100 ether);

        crowdfunding = new CrowdFunding();
        vm.prank(cand1);
        id1 = crowdfunding.createCampaign(2, 3600);
        vm.prank(cand2);
        id2 = crowdfunding.createCampaign(1, 60);
    }

    function testPledging() public {
        vm.prank(addr1);
        crowdfunding.pledge{value: 0.3 ether}(id1);

        (, , uint pledged1, ,) = crowdfunding.getCampaign(id1);
        assertEq(pledged1, 0.3 ether);

        vm.prank(addr2);
        crowdfunding.pledge{value: 0.8 ether}(id2);
        vm.prank(addr3);
        crowdfunding.pledge{value: 0.3 ether}(id2);

        (, , uint pledged2, ,) = crowdfunding.getCampaign(id2);
        assertEq(pledged2, 1.1 ether);
    }

    function testEarlyClaim() public {
        vm.prank(cand1);

        vm.expectRevert();
        crowdfunding.claimFunds(id1);

        vm.prank(addr1);
        vm.expectRevert();
        crowdfunding.claimFunds(id2);
    }

    function testLatePledging() public {
        vm.warp(3605);

        vm.prank(addr1);
        vm.expectRevert();
        crowdfunding.pledge{value: 0.5 ether}(id1);

        vm.prank(addr2);
        vm.expectRevert();
        crowdfunding.pledge{value: 0.5 ether}(id2);
    }

    function testClaim() public {
        testPledging();
        vm.warp(3605);
        vm.prank(cand1);

        vm.expectRevert();
        crowdfunding.claimFunds(id1);

        vm.prank(cand2);
        crowdfunding.claimFunds(id2);

        assertEq(cand1.balance, 0 ether);
        assertEq(cand2.balance, 1.1 ether);
    }
}