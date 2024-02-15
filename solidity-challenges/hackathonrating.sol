// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Hackathon {
    struct Project {
        string title;
        uint[] ratings;
    }

    Project[] projects;

    // TODO: add the findWinner function

    function newProject(string calldata _title) external {
        // creates a new project with a title and an empty ratings array
        projects.push(Project(_title, new uint[](0)));
    }

    function rate(uint _idx, uint _rating) external {
        // rates a project by its index
        projects[_idx].ratings.push(_rating);
    }

    function findWinner() external view returns (Project memory p) {
        Project memory highest = Project("", new uint[](1));

        for (uint i = 0; i < projects.length; i++) {
            uint currentAvg = calcAverage(projects[i]);
            uint h = calcAverage(highest);

            if (currentAvg > h) {
                highest = projects[i];
            }
        }

        return highest;
    }

    function calcAverage(Project memory p) internal pure returns (uint) {
        uint sum = 0;

        for (uint i = 0; i < p.ratings.length; i++) {
            sum += p.ratings[i];
        }

        return sum / p.ratings.length;
    }
}
