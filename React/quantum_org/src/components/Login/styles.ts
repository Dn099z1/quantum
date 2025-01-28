import styled, { css } from "styled-components";
import { theme } from "../../styles";
import BgLoginFac from "../../assets/bg_login_fac.png";
import BgLoginJob from "../../assets/bg_login_Job.png";

type ContainerProps = {
  facType: "fac" | "job";
};

export const Container = styled.section<ContainerProps>`
  ${({ facType }) => css`
    ${facType === "fac"
      ? css`
          background-image: url(${BgLoginFac});
        `
      : css`
          background-image: url(${BgLoginJob});
        `}
  `}
  background-size: cover;
  background-position: center top;
  width: 100%;
  height: 100%;
`;

export const Filter = styled.div`

  width: 100%;
  height: 100%;
  
  display: flex;
  justify-content: center;
  align-items: center;
`;

export const Description = styled.p`
  color: #999;
  font-size: 16px;
  margin-bottom: 25px;
`;
export const ProgressBarWrapper = styled.div`
  width: 80%;
  height: 10px;
  background-color: #333;
  border-radius: 5px;
  overflow: hidden;
  margin-top: 20px;

  div {
    height: 100%;
    background-color: ${theme.colors.primary};
    transition: width 0.3s ease-out;
  }
`;

export const BtnLogin = styled.button`
  background-color: #252525;
  width: 350px;
  padding: 50px 10px;
  border-radius: 50px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
  border: 3px solid #252525;

  transition: all 0.5s;

  &:hover {
    background-color: #252525;
  }
`;
export const ActionButton = styled.button`
  background-color: rgba(221, 145, 59, 0.86);
  height: 30px;
  width: 50%;
  color: white;
  
  font-size: 14px;
  font-weight: normal;
  cursor: pointer;
  margin-top: 20px;
  align-items: center;
  gap: 10px;
  justify-content: center;
  border-radius: 12.5px;
  border: 0;
  border: 2px solid #000;

  &.small-rounded {
    font-size: 15px;
    height: 25px;
    width: 25px;
    border-radius: 50%;
  }

  &.full-w {
    flex: 1;
  }

  &:disabled {
    cursor: not-allowed;
  }
`;
export const Title = styled.h1`
  font-size: 22px;
  letter-spacing: 2px;
  color: white;
  font-weight: bold;

  & > b {
    color: ${theme.colors.primary};
  }
`;

export const WrapLogo = styled.div`
  background-color: rgba(0, 0, 0, 0.5);
  padding: 20px;
  border-radius: 50%;
`;

export const Logo = styled.img`
  width: 64px;
  height: auto;
`;
