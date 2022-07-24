pragma solidity 0.5.16;

import "./ERC721Full.sol";

pragma experimental ABIEncoderV2;

contract Profiles is ERC721Full {

    enum ProfileType{ MEDICO, PACIENTE, FARMACIA }

    struct Profile {
        string id;
        string nombre;
        ProfileType tipo;
    }

    Profile[] public profiles;

    mapping(string => bool) _profileExists;

    constructor() ERC721Full("Profile", "PROFILE") public {
    }

    event addedUser();

    function getProfileWithAdress(address owner) external view returns(Profile memory){
        uint256 balance = balanceOf(owner);
        uint256 index = tokenOfOwnerByIndex(owner, balance-1);
        Profile memory profileData = profiles[index-1];
        return profileData;
    }

    function addNewProfile(
        string memory id,
        string memory  nombre,
        ProfileType tipo
    ) public {
        require(!_profileExists[id]);
        uint _id = profiles.push(
            Profile(
                id,
                nombre,
                tipo
            )
        );
        _mint(msg.sender, _id);
        _profileExists[id] = true;
        emit addedUser();
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        //void method to avoid the transfer of profile NFT's
    }

}
