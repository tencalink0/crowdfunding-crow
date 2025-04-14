//SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./CampaignBase.sol";

contract Modifiers is CampaignBase {
    modifier onlyCreator(uint _campaignId) {
        require(msg.sender == campaigns[_campaignId].creator, "Unauthorised access");
        _;
    }

    modifier ethTransered() {
        require(msg.value > 0, "No eth sent");
        _;
    }

    modifier goalMet(uint _campaignId) {
        require(campaigns[_campaignId].pledged >= campaigns[_campaignId].goal, "Goal hasn't been met");
        _;
    }

    modifier goalNotMet(uint _campaignId) {
        require(campaigns[_campaignId].pledged < campaigns[_campaignId].goal, "Goal has been met");
        _;
    }

    modifier notClaimed(uint _campaignId) {
        require(campaigns[_campaignId].claimed == false, "Funds have already been claimed");
        _;
    }

    modifier fundsAvailable(uint _campaignId) {
        require(campaigns[_campaignId].contributions[msg.sender] > 0, " ");
        _;
    }

    modifier beforeDeadline(uint256 _campaignId) {
        require(block.timestamp < campaigns[_campaignId].deadline, "The deadline has passed");
        _;
    }

    modifier afterDeadline(uint256 _campaignId) {
        require(block.timestamp >= campaigns[_campaignId].deadline, "The deadline has not yet been reached");
        _;
    }
}