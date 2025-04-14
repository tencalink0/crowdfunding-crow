//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Modifiers.sol";

contract CrowdFunding is Modifiers {
    struct Campaign {
        address creator;
        uint goal;
        uint pledged;
        uint32 deadline;
        bool claimed;
        mapping(address => uint) contributions;
    }

    // campaign id -> campaign 
    mapping(uint => Campaign) public campaigns;
    uint public campaignCount;

    function createCampaign(uint _goal, uint32 _deadline) external {
        campaignCount++;

        Campaign storage c = campaigns[campaignCount];
        c.creator = msg.sender;
        c.goal = _goal;
        c.pledged = 0;
        c.deadline = _deadline;
        c.claimed = false;
    }
}