//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract CampaignBase {
    struct Campaign {
        address payable creator;
        uint goal;
        uint pledged;
        uint256 deadline;
        bool claimed;
        mapping(address => uint) contributions; // stores how much each user has payed
    }

    // campaign id -> campaign 
    mapping(uint => Campaign) public campaigns;
    uint public campaignCount;
}