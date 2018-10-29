pragma solidity ^0.4.23;

import '../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';

contract TokenBattlerToken is ERC721Token {
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;


  struct TokenBattler {
    string battler;
    string ipsfHash;
    uint dna;
    bool publishing;
    address mintedBy;
    uint64 mintedAt;
  }


  TokenBattler [] TokenBattlers;

  event Mint(address owner, uint256 tokenId);


  constructor(string _name, string _symbol) public ERC721Token(_name, _symbol) {}


  function mint(string _battler, string _ipsfHash, bool _publishing) external returns (uint256) {
    require(msg.sender != address(0));
    uint rand = uint(keccak256(abi.encodePacked(_ipsfHash)));
    uint _dna = rand % dnaModulus;

    TokenBattler memory tokenBattler = TokenBattler({
        battler: _battler,
        ipsfHash: _ipsfHash,
        dna: _dna,
        publishing: _publishing,
        mintedBy: msg.sender,
        mintedAt: uint64(now)
      });
      uint256 tokenId = TokenBattlers.push(tokenBattler) - 1;
      super._mint(msg.sender, tokenId);

      emit Mint(msg.sender, tokenId);
      return tokenId;
  }

  function burn(uint256 _tokenId) public {
    super._burn(ownerOf(_tokenId), _tokenId);
    if (TokenBattlers.length != 0) {
      delete TokenBattlers[_tokenId];
    }
  }

  function getTokenBattler(uint256 _tokenId) external view returns (string battler, string ipsfHash, uint dna, bool publishing, address mintedBy, uint64 mintedAt) {
    TokenBattler memory tokenBattler = TokenBattlers[_tokenId];

    battler = tokenBattler.battler;
    ipsfHash = tokenBattler.ipsfHash;
    dna= dna;
    publishing = tokenBattler.publishing;
    mintedBy = tokenBattler.mintedBy;
    mintedAt = tokenBattler.mintedAt;
  }

  function getAllTokenBattlersOfOwner(address _owner) external view returns (uint256[]) {
    return ownedTokens[_owner];
  }

  function getAllTokenBattlers() external view returns (uint256[]) {
    return allTokens;
  }
}
