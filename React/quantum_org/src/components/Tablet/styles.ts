import styled from "styled-components";

export const Container = styled.section`
  background-image: linear-gradient(to bottom right,rgb(32, 32, 30),rgb(24, 21, 21));
  width: 1100px;
  height: 650px;
  border-radius: 50px;
  padding: 2px;
  box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;
`;

export const Border = styled.div`
  background-color: black;
  border-radius: 48px;
  width: 100%;
  height: 100%;
  padding: 10px;
`;

export const Screen = styled.div`
  background-color: white;
  width: 100%;
  height: 100%;
  border-radius: 50px;
  overflow: hidden;
  position: relative;
`;
