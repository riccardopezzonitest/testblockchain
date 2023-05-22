// SPDX-License-Identifier: GPL-3.0
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


pragma solidity >=0.7 <0.9.0;


contract NewEvidence_SmartContractStorage{
    address public owner;
    uint256 public fileCount = 0;
    mapping(uint256 => File) public files;

    struct File {
        uint256 fileId;
        bytes32 fileHash;
        address payable uploader;
    }

    event EvidenceAdded(
        uint256 fileId,
        bytes32 fileHash,
        address payable uploader
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this method");
        _;
    }

    function newevidence (
        bytes32 _fileHash
    ) external onlyOwner {

        fileCount++;

        files[fileCount] = File(
            fileCount,
            _fileHash,
            payable(msg.sender)
        );
        
        emit EvidenceAdded(
            fileCount,
            _fileHash,
            payable(msg.sender)
        );
    }

    constructor(address _owner) {
        owner = _owner;
    }

}


contract SmartContractFactory {
    mapping(address => address) public userToContract;

    event ContractCreated(address indexed user, address indexed contractAddress);

    function createSmartContract() external {
        // Create a new smart contract with the caller as the owner
        NewEvidence_SmartContractStorage newContract = new NewEvidence_SmartContractStorage(msg.sender);
        
        // Store the mapping between the user and the created contract address
        userToContract[msg.sender] = address(newContract);
        
        emit ContractCreated(msg.sender, address(newContract));
    }
}