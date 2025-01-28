import styled, { css } from "styled-components";

export const Wrap = styled.div`
  ${({ theme }) => css`
    display: flex;
    margin: 0;
    gap: 0;
    align-items: center;
    flex-wrap: wrap;
    overflow: hidden;
    
  `}
`;

export const Status = styled.div`
  ${({ theme }) => css`
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    position: relative;
stroke-linejoin: round;
    width: 100px;
    height: 100px;
    margin: 0 -1.25rem;

    & svg {
      position: absolute;
      z-index: 2;
      stroke-linejoin: round;
      color: ${theme.colors.shape()};
      font-size: 1.2rem;
    }
  `}
`;

export const SvgWrapper = styled.svg.attrs({
  viewBox: "0 0 120 120",
})`
  position: absolute;
  width: 50%;
  stroke-linejoin: round;
  height: 50%;
`;

export const PathBackground = styled.path`
  ${({ theme }) => css`
    fill: ${theme.colors.dark(0.5)};
    border-radius: 20px;
    stroke: ${theme.colors.dark(0.5)};
    stroke-linejoin: round;
  `}
`;

export const PathForeground = styled.path`
  ${({ theme, color }) => css`
    fill: none;
    border-radius: 200rem;
    stroke: ${color || theme.colors.primary()};
    transition: stroke-dashoffset 0.5s;
    stroke-linecap: round;
    stroke-linejoin: round; 
  `}
`;
