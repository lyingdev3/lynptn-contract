const chai = require('chai');
const LyingPutin = artifacts.require('./LyingPutin.sol');
chai.use(require('chai-bignumber')()).should();

contract('Mint', (accounts) => {
  const user = accounts[2];
  describe('Mint', () => {
    it('mints', async () => {
      const nft = await LyingPutin.deployed();
      const price = await nft.salePrice();
      const amount = 4;
      await nft.mint(String(amount), {
          value: price * amount
      });

      const supply = await nft.totalSupply();
      console.log(supply.toString());

      const uri = await nft.tokenURI('4');
      console.log(uri);
    });
  });
});
