import styled from "styled-components";

export const AvatarContainer = styled.div`
  position: absolute;
  top: 60px;
  left: 220px;
  display: flex;
  align-items: center;
  
  padding: 10px;
  border-radius: 5px;
`;

export const Avatar = styled.img`
  width: 50px;
  height: 50px;
  border-radius: 50%;
  margin-right: 10px;
`;

export const PlayerInfo = styled.div`
  color: white;
  font-size: 14px;

  p {
    margin: 0;
  }
`;
