//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./Modifiers.sol";

contract CrowdFunding is Modifiers {
    function createCampaign(uint256 _goal, uint256 _deadline) external returns (uint256) {
        Campaign storage c = campaigns[campaignCount];
        c.creator = payable(msg.sender);
        c.goal = _goal;
        c.pledged = 0;
        c.deadline = block.timestamp + _deadline;
        c.claimed = false;

        campaignCount++;
        return (campaignCount - 1);
    }

    function pledge(uint256 _campaignId) external payable beforeDeadline(_campaignId) ethTransered {
        campaigns[_campaignId].pledged += msg.value;
    }

    function claimFunds(uint256 _campaignId)
        external
        afterDeadline(_campaignId)
        notClaimed(_campaignId)
        goalMet(_campaignId)
        onlyCreator(_campaignId)
    {
        Campaign storage c = campaigns[_campaignId];
        c.creator.transfer(c.pledged);
    }

    function refund(uint256 _campaignId)
        external
        afterDeadline(_campaignId)
        goalNotMet(_campaignId)
        fundsAvailable(_campaignId)
    {
        uint256 contribution = campaigns[_campaignId].contributions[msg.sender];
        payable(msg.sender).transfer(contribution);
        campaigns[_campaignId].pledged -= contribution;
        campaigns[_campaignId].contributions[msg.sender] = 0;
    }

    function getCampaign(uint256 _campaignId) external view returns (address, uint256, uint256, uint256, bool) {
        Campaign storage c = campaigns[_campaignId];
        return (c.creator, c.goal, c.pledged, c.deadline, c.claimed);
    }
}
