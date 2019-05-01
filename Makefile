.PHONY: clean compile flat solhint test

clean:
	rm -rf build/
	rm -rf flat/
	rm -rf tmp/

compile: clean
	node_modules/.bin/truffle compile

flat: clean
	mkdir flat
	mkdir tmp

	# find node_modules/openzeppelin-solidity/contracts -type f -name '*.sol' -exec cp {} tmp/ \;
	cp contracts/*.sol tmp/

	rm tmp/Migrations.sol

	sed -i '' -e "s/\(import \)\(.*\)\/\(.*\).sol/import \".\/\3.sol/g" tmp/*
	node_modules/.bin/truffle-flattener tmp/* | sed "1s/.*/pragma solidity ^0.5.8;/" > flat/Contracts.sol

solhint:
	solhint contracts/*.sol contracts/util/*.sol

test:
	node_modules/.bin/truffle test --network test
