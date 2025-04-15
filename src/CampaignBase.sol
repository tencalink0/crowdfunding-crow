//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract CampaignBase {
    struct Campaign {
        address payable creator;
        uint256 goal;
        uint256 pledged;
        uint256 deadline;
        bool claimed;
        mapping(address => uint256) contributions; // stores how much each user has payed
    }

    // campaign id -> campaign
    mapping(uint256 => Campaign) public campaigns;
    uint256 public campaignCount;
}
