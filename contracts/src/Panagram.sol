// SPDX-License-Identifer: MIT

pragma solidity ^0.8.24;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {IVerifier} from "./Verifier.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


// @title Panagram
contract Panagram is ERC1155, Ownable {

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event Panagram__VerifierUpdated(IVerifier verifier);
    event Panagram__NewRoundStarted(bytes32 answer);
    event Panagram__WinnerCrowned(address indexed winner, uint256 round);
    event Panagram__RunnerUpCrowned(address indexed runnerUp, uint256 round);

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error Panagram__InvalidVerifierAddress();
    error Panagram__MinTimeNotPassed(uint256 minDuration, uint256 timePassed);
    error Panagram__NoRoundWinner();
    error Panagram__FirstPanagramNotSet();
    error Panagram__AlreadyGuessedCorrectly(uint256 round, address user);
    error Panagram__IncorrectProof();

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    uint256 public constant MIN_DURATION = 10800; // 3 hours
    uint256 public s_roundStartTime;
    address public s_currentRoundWinner;
    bytes32 public s_answer;
    uint256 public s_currentRound;
    uint256 public s_currentGuessRound;
    
    IVerifier public s_verifier;

    /*//////////////////////////////////////////////////////////////
                                MAPPINGS
    //////////////////////////////////////////////////////////////*/
    mapping (address => uint256) public s_lastCorrectGuessRound;
    
    /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(IVerifier _initialVerifier) ERC1155("ipfs://bafybeicqfc4ipkle34tgqv3gh7gccwhmr22qdg7p6k6oxon255mnwb6csi/{id}.json") Ownable(msg.sender) {
        s_verifier = _initialVerifier;
    }

    function setVerifier(IVerifier _newVerifier) external onlyOwner {
        if(address(_newVerifier) == address(0)) {
            revert Panagram__InvalidVerifierAddress();
        }
        s_verifier = _newVerifier;
        emit Panagram__VerifierUpdated(_newVerifier);
    }

    function newRound(bytes32 _answer) external onlyOwner {
        if(s_roundStartTime == 0) { // first round
            s_roundStartTime = block.timestamp;
            s_answer = _answer;
        } else {
            if(block.timestamp < s_roundStartTime + MIN_DURATION) {
                revert Panagram__MinTimeNotPassed(MIN_DURATION, block.timestamp - s_roundStartTime);
            }
            if(s_currentRoundWinner == address(0)) {
                revert Panagram__NoRoundWinner();  // Previous round must have a winner to start a new one.
            }
            s_roundStartTime = block.timestamp;
            s_currentRoundWinner = address(0);
            s_answer = _answer;
        }
        s_currentRound++;
        emit Panagram__NewRoundStarted(_answer);
    }

    function makeGuess(bytes memory _proof) external returns (bool) {
        if(s_currentRound == 0) {
            revert Panagram__FirstPanagramNotSet();
        }
        if(s_lastCorrectGuessRound[msg.sender] == s_currentRound) {
            revert Panagram__AlreadyGuessedCorrectly(s_currentGuessRound, msg.sender);
        }
        bytes32[] memory publicInputs = new bytes32[](1);
        publicInputs[0] = s_answer;

        bool proofResult = s_verifier.verify(_proof, publicInputs);
        if(!proofResult) {
            revert Panagram__IncorrectProof();
        }

        s_lastCorrectGuessRound[msg.sender] = s_currentRound;
        if(s_currentRoundWinner == address(0)) { //  First correct guess for this round
            s_currentRoundWinner = msg.sender;
            _mint(msg.sender, 0, 1, ""); // Mint NFT ID 0 (Winner NFT)
            emit Panagram__WinnerCrowned(msg.sender, s_currentRound);
        } else {
            _mint(msg.sender, 1, 1, ""); // // Mint NFT ID 1 (Participant NFT)
            emit Panagram__RunnerUpCrowned(msg.sender, s_currentRound);
        }
        return true;
    }
}