//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { IERC721, IERC721Metadata } from "@openzeppelin/contracts/interfaces/IERC721Metadata.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title           Exhausted Pigeon Business NFT-Card
 * @notice          This NFT as a fully onchain NFT, evoluting based on its owner address balance.
 * @dev             This is a non-transferrable NFT, pseudo-minting (by using Transfer event only).
 *                  Non-tranfer can be easily bypassed by wrapping the NFT, this contract logic
 *                  shouldn't be reused for such situation (ticketing, Howie, etc).
 * @author          drgorilla.eth
 * @custom:website  https://www.exhausted-pigeon.xyz
 */
contract ExhaustedPigeonCard is IERC721, IERC721Metadata {
    /**
     * @dev Thrown when trying to use transfer-related functions.
     */
    error ExhaustedPigeonCard_NonTransferrable();
    

    /**
     * @dev Thrown when querying the tokenURI of a non-minted id.
     */
    error ExhaustedPigeonCard_NotMinted();


    // The nonce which correspond to the supply. Starts at one to avoid burdening the first minter for the storage slot init
    uint256 internal _nonce = 1;


    // Tracks the token owners (use to display the balance in the SVG)
    mapping(uint256=>address) internal _ownerOf;
    

    /**
     * @notice Mint a new token for the sender
     * @dev    Balance isn't tracked nor used, only the transfer matters (for UI/index interface)
     */
    function mint() public {
        _ownerOf[_nonce] = msg.sender;
        emit Transfer(address(0), msg.sender, _nonce++);
    }


    /**
     * @notice Build and return a metadata with the SVG in the image key
     */
    function tokenURI(uint256 id) public view override returns (string memory) {
        // Revert if not minted
        address _owner = _ownerOf[id];
        if(_owner == address(0)) revert ExhaustedPigeonCard_NotMinted();

        uint256 _balance = _owner.balance;

        // 3 decimals precision, in eth: A.BCD
        string memory _balanceString = string.concat(
            Strings.toString(_balance / 1 ether), // A
            '.',
            Strings.toString(_balance % 1 ether / 0.001 ether) // BCD
        );

        // Build and encode svg in base64
        bytes memory image = abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(
                bytes(
                    string.concat(
                        '<svg viewBox="0 0 400 400" version="1.1" xmlns="http://www.w3.org/2000/svg">',

                        '<defs>',
                            '<linearGradient id="Gr">',
                            '<stop offset="0%" stop-color="red" />',
                            '<stop offset="100%" stop-color="green" />',
                            '</linearGradient>',
                        '</defs>',

                        '<rect width="400" height="400" fill="#000000"/>',

                        '<path style="fill:#e6e6e6" d="M 336.44778,4.94955 C 328.20347,4.90315 318.19253,6.92616 305.93979,11.57463 329.67611,57.68161 312.35219,83.872732 285.15015,105.2716 309.00742,106.54409 327.89437,97.734324 337.67094,70.44324 357.34759,67.7405 362.51814,61.16796 368.22221,54.73891 L 394.85819,52.42633 375.72827,46.26534 C 370.00814,23.85765 361.18074,5.08866 336.44778,4.94955 Z M 324.19661,24.67533 339.9835,34.3229 354.2956,24.87198 340.24505,38.65899 Z M 6.11521,106.08643 290.78016,16.34453 C 329.0098,59.41074 278.94781,104.34899 256.2454,105.85202 L 190.64347,107.20636 242.63844,53.88969 237.30631,48.46985 181.29835,106.19889 Z"/>',
                        
                        '<text style="font-size:42.6667px;font-family:sans-serif;fill:#e6e6e6" x="8" y="146">Exhausted Pigeon</text>',
                        '<text style="font-style:italic;font-size:26.6667px;font-family:sans-serif;fill:#e6e6e6" x="42" y="180">Blockchain Engineering</text>',
                        '<text style="font-size:16px;font-family:sans-serif;fill:#e6e6e6" x="18" y="255">This NFT business card is currently owned by</text>',
                        '<text style="font-size:14px;font-family:sans-serif;fill:#e6e6e6" x="14" y="275">0x', _addressToString(_owner), '</text>',
                        '<text style="font-size:14px;font-family:sans-serif;fill:#e6e6e6" x="14" y="290">(', _balanceString, 'ETH)</text>',
                        '<rect style="fill:url(#Gr)" width="380" height="31" x="10" y="300"/>',
                        '<text style="font-size:16px;font-family:sans-serif;fill:#000000" x="', Strings.toString( _balance <= 100 ether ? _balance * 385 / 100 ether : 385 ),'" y="320">X</text>',
                        '<text style="font-size:10px;font-family:sans-serif;fill:#e6e6e6" x="10" y="350">poor af</text>',
                        '<text style="font-size:10px;font-family:sans-serif;fill:#e6e6e6" x="360" y="350">whale</text>',
                        '<text style="font-size:28px;font-family:sans-serif; fill: #ffffff;" x="8" y="380" >www.exhausted-pigeon.xyz</text>',
                        '</svg>'
                    )
                )
            )
        );
        
        // Append the json content and encode in base64
        return
                string.concat(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"Exhausted Pigeon Virtual Card", "image":"',
                                image,
                                unicode'", "description": "www.exhausted-pigeon.xyz"}'
                            )
                        )
                    )
                )
            ;
    }


    /**
     * @notice Returns the token collection name.
     */
    function name() external pure returns (string memory) {
        return "ExhaustedPigeon";
    }


    /**
     * @notice Returns the token collection symbol.
     */
    function symbol() external pure returns (string memory) {
        return "ExPig";
    }


    /**
     * @notice Returns the owner of the NFT tokenId.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner) {
        owner = _ownerOf[tokenId];
    }


    /**
     * @notice Balance is fixed/useless in non-transferability context
     */
    function balanceOf(address owner) external pure returns (uint256 balance) {
        balance = 1;
    }


    //@inheritdoc IERC1165
    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId;
    }


    /* ======== EIP721 STANDARD FUNCTION THROWING FOR NON-TRANSFERRABILITY ======== */

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external {
        revert ExhaustedPigeonCard_NonTransferrable();
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external {
        revert ExhaustedPigeonCard_NonTransferrable();
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external {
        revert ExhaustedPigeonCard_NonTransferrable();
    }

    function approve(address to, uint256 tokenId) external {
        revert ExhaustedPigeonCard_NonTransferrable();
    }

    function setApprovalForAll(address operator, bool _approved) external {
        revert ExhaustedPigeonCard_NonTransferrable();
    }

    function getApproved(uint256 tokenId) external view returns (address operator) {
        return address(0);
    }

    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return false;
    }

    /* ========== HELPER FUNCTIONS ========== */

    /**
     * @notice Convert an address to an hexadecimal string
     */
    function _addressToString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = _char(hi);
            s[2 * i + 1] = _char(lo);
        }
        return string(s);
    }

    /**
     * @notice Helper
     */
    function _char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }
}
