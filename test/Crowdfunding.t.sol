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
        crowdfunding.createCampaign(2, 3600);
        vm.prank(cand2);
        crowdfunding.createCampaign(1, 60);
    }

    function testPledging() public {
        vm.prank(addr1);
        crowdfunding.pledge{value: 0.3 ether}(0);

        (, , uint pledged1, ,) = crowdfunding.getCampaign(0);
        assertEq(pledged1, 0.3 ether);

        vm.prank(addr2);
        crowdfunding.pledge{value: 0.8 ether}(1);
        vm.prank(addr3);
        crowdfunding.pledge{value: 0.3 ether}(1);

        (, , uint pledged2, ,) = crowdfunding.getCampaign(1);
        assertEq(pledged2, 1.1 ether);
    }
}