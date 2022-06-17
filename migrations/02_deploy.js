const LyingPutin = artifacts.require('LyingPutin');

const deploy = async (deployer, network, accounts) => {
  await deployer.deploy(LyingPutin, 'Lying Putin', 'LYNPTN');
};

module.exports = deploy;
