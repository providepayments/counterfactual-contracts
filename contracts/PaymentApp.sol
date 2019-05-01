pragma solidity 0.5.7;
pragma experimental "ABIEncoderV2";

import "@counterfactual/contracts/contracts/CounterfactualApp.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract PaymentApp is CounterfactualApp {

  using SafeMath for uint256;

  struct AppState {
    address alice;
    address bob;
    uint256 aliceBalance;
    uint256 bobBalance;
  }

  struct Action {
    uint256 paymentAmount;
  }

  function resolve(bytes calldata encodedState, Transfer.Terms calldata terms)
    external
    pure
    returns (Transfer.Transaction memory)
  {
    AppState memory state = abi.decode(encodedState, (AppState));

    uint256[] memory amounts = new uint256[](2);
    amounts[0] = state.aliceBalance;
    amounts[1] = state.bobBalance;

    address[] memory to = new address[](2);
    to[0] = state.alice;
    to[1] = state.bob;
    bytes[] memory data = new bytes[](2);

    return Transfer.Transaction(
      terms.assetType,
      terms.token,
      to,
      amounts,
      data
    );
  }

  function isStateTerminal(bytes calldata encodedState)
    external
    pure
    returns (bool)
  {
    // always terminal
    return true;
  }

  function getTurnTaker(
    bytes calldata encodedState,
    address[] calldata signingKeys
  )
    external
    pure
    returns (address)
  {
    // only alice is allowed to send state updates to enforce unidirectionality
    // needed because of the concurrent state update limitation
    return signingKeys[0];
  }

  function applyAction(
    bytes calldata encodedState, bytes calldata encodedAction
  )
    external
    pure
    returns (bytes memory)
  {
    AppState memory state = abi.decode(encodedState, (AppState));
    Action memory action = abi.decode(encodedAction, (Action));

    // apply transition based on action
    AppState memory postState = applyPayment(state, action.paymentAmount);

    return abi.encode(postState);
  }

  function applyPayment(
    AppState memory state, 
    uint256 paymentAmount
  )
    internal
    pure
    returns (AppState memory)
  {
    // subtract payment amount from alice balance
    // SafeMath will throw if below zero
    state.aliceBalance = state.aliceBalance.sub(paymentAmount);
    // add payment amount to bob balance
    state.bobBalance = state.bobBalance.add(paymentAmount);
    return state;
  }

}
