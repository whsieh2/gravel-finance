import React from "react";

import { NetworkErrorMessage } from "./NetworkErrorMessage";
import { Card, Row, InputNumber, Select, Button, Space } from "antd";
import { Radio } from "antd";
export function Loading() {
  return (
    <div
      style={{
        position: "fixed",
        zIndex: 2,
        top: 0,
        left: 0,
        width: "100%",
        height: "100%",
        background: "linear-gradient(#1e212d, #3e404b)",
      }}
    >
    <div
      className="container p-4"
      style={{ background: "linear-gradient(to bottom right, #bbcfff, #1e366b)",boxShadow:"-10px 3px 10px black", borderRadius: 30, marginTop:150,
  width: 1000, height: 635}}
    >
            <div className="row">
              <div className="col-12">
                <h1 style={{ marginBottom: 5 }} >
                  Illuminate
                </h1>
                <h4 style={{ marginBottom: 25 }} >
                  Fixed Yield Aggregator

                </h4>

              </div>
            </div>
    <div>
        <Row>


          <div
            style={{
              position: "absolute",
              zIndex: 3,
              top: "50%",
              left: "50%",
              width: "100px",
              height: "50px",
              marginLeft: "-50px",
              marginTop: " -25px",
              textAlign: "center",
            }}
          >
            <div className="spinner-border" role="status">
              <span className="sr-only">Loading...</span>
            </div>
          </div>


      </Row>
  </div>
    </div>
    <p style={{textAlign:'center', fontSize: 12, marginTop: 100, color: '#C8C8C8' }}>
        Created for <a href="https://gravel.substack.com/" target="_blank" rel="noopener noreferrer">Gitcoin Kernel Cohort II Fellowship</a>
        </p>
        <p style={{textAlign:'center', fontSize: 12, marginTop: -10, color: '#C8C8C8' }}>
        Developed by: <a href="https://twitter.com/_WillHsieh" target="_blank" rel="noopener noreferrer">Will</a>
      </p>
      <p style={{textAlign:'center', fontSize: 12, marginTop: -10, color: '#C8C8C8'}}>
        Stay tuned for more updates to come!
      </p>
    </div>
  );
}
