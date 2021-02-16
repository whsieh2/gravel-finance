import React from "react";

import { NetworkErrorMessage } from "./NetworkErrorMessage";

export function ConnectWallet({ connectWallet, networkError, dismiss }) {
  return (
    <div
      style={{
        position: "fixed",
        zIndex: 2,
        top: 0,
        left: 0,
        width: "100%",
        height: "100%",
        background: '#cbd5e0',
      }}
    >
    <div className="container"style={{ backgroundColor: '#cbd5e0', top: 500 }}>
      <div className="row justify-content-md-center">
        <div className="col-12 text-center">
          {/* Metamask network should be set to Localhost:8545. */}
          {networkError && (
            <NetworkErrorMessage
              message={networkError}
              dismiss={dismiss}
            />
          )}
        </div>
        <div className="col-6 p-4 text-center" style={{ top: 200 }}>
          <h3>Welcome to Gravel!</h3>
          <p></p>
          <p>Begin by connecting to your Wallet</p>
          <button
          style={{
          backgroundColor: '#edf2f7',
          borderColor: '#99CCFF',
          }}
            className="btn btn-warning"
            type="button"
            onClick={connectWallet}
          >
            Connect Wallet
          </button>
        </div>
      </div>
    </div>
    </div>
  );
}
