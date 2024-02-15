// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract Contract {
    enum Choices {
        Yes,
        No
    }

    struct Vote {
        Choices choice;
        address voter;
    }

    Vote[] public votes;

    function createVote(Choices choice) external {
        require(!hasVoted(msg.sender));
        votes.push(Vote(choice, msg.sender));
    }

    function changeVote(Choices choice) external {
        require(hasVoted(msg.sender));
        uint i = 0;
        while (i < votes.length) {
            if (votes[i].voter == msg.sender) {
                votes[i].choice = choice;
            }
            i++;
        }
    }

    function hasVoted(address addrs) public view returns (bool) {
        Vote memory vote = findVoter(addrs);

        return vote.voter == addrs;
    }

    function findChoice(address addrs) external view returns (Choices choice) {
        Vote memory vote = findVoter(addrs);
        return vote.choice;
    }

    // we use memory in the return type because we are returning a new instance of Vote
    // and not a reference to the storage, Using memory will create a new instance of the struct in memory
    // If we used calldata, it would be a reference to the storage
    function findVoter(address addrs) internal view returns (Vote memory vote) {
        uint i = 0;
        while (i < votes.length) {
            if (votes[i].voter == addrs) {
                return votes[i];
            }
            i++;
        }

        return Vote(Choices(0), address(0));
    }
}
