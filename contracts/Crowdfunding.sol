//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Modifiers.sol";

contract CrowdFunding is Modifiers {
    function createCampaign(uint _goal, uint256 _deadline) external {
        campaignCount++;

        Campaign storage c = campaigns[campaignCount];
        c.creator = payable(msg.sender);
        c.goal = _goal;
        c.pledged = 0;
        c.deadline = block.timestamp + _deadline;
        c.claimed = false;
    }

    function pledge(uint _campaignId) external payable 
        beforeDeadline(_campaignId) 
        ethTransered
    {
        campaigns[_campaignId].pledged += msg.value;
    }

    function claimFunds(uint _campaignId) external 
        afterDeadline(_campaignId) 
        notClaimed(_campaignId)
        goalMet(_campaignId)
        onlyCreator(_campaignId)
    {
        Campaign storage c = campaigns[_campaignId];
        c.creator.transfer(c.pledged);
    }

    function refund(uint _campaignId) external 
        afterDeadline(_campaignId) 
        goalNotMet(_campaignId)
        fundsAvailable(_campaignId)
    {
        uint contribution = campaigns[_campaignId].contributions[msg.sender];
        payable(msg.sender).transfer(contribution);
        campaigns[_campaignId].pledged -= contribution;
        campaigns[_campaignId].contributions[msg.sender] = 0;
    }

    function getCampaign(uint _campaignId) external view
        beforeDeadline(_campaignId) 
        returns (address, uint, uint, uint256, bool) 
    {
        Campaign storage c = campaigns[_campaignId];
        return (
            c.creator,
            c.goal,
            c.pledged,
            c.deadline,
            c.claimed
        );
    }
}