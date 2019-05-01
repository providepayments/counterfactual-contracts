module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  // networks: {
  //   ganache: {
  //     host: "localhost",
  //     port: 7545,
  //     network_id: "*" // Match any network id
  //   },
  //   test: {
  //     host: "localhost",
  //     port: 7545,
  //     network_id: "*",
  //     gasPrice: 1,
  //     gas: 8000000000000000
  //   }
  // },
  mocha: {
    reporter: 'mochawesome'
  },
  solc: {
    optimizer: {
      enabled: true, runs: 200
    }
  }
};
