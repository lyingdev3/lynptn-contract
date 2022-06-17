pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract LyingPutin is ERC721, Ownable {
    using Strings for uint256;

    using Counters for Counters.Counter;
    Counters.Counter private _ids;

    uint256 public maxSupply = 10000;
    bool public saleIsOpen = true;

    uint256 public salePrice = 0.05 ether;

    string private baseURI = "https://ipfs.io/ipfs/bafybeicq5nvblxjra7ypkc5szdvud62mxcwueqrwkrcopjg2wkgf2x2jra/";

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    /// @dev change the base uri
    /// @param uri base uri
    function setBaseURI(string memory uri) public onlyOwner {
        baseURI = uri;
    }

    /// @dev change the sale price
    /// @param price sale price
    function setPrice(uint256 price) public onlyOwner {
        salePrice = price;
    }

    /// @dev flip sale state
    function flipSaleState() public onlyOwner {
        saleIsOpen = !saleIsOpen;
    }

    function totalSupply() public view virtual returns (uint256) {
        return _ids.current();
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    /// @dev mint number of nfts
    function mint(uint256 amount)
        public
        payable
    {
        require(saleIsOpen, "Sale is not active");
        require(msg.value == amount * salePrice, "Wrong amount");
        require(_ids.current() < maxSupply, "Not enough on max supply");

        for (uint256 i = 0; i < amount; i++) {
            _ids.increment();
            uint256 newItemId = _ids.current();
            _safeMint(msg.sender, newItemId);
        }
    }
    
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
