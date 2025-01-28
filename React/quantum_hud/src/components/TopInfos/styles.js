import styled, { css } from "styled-components";
// Supports weights 300-900
import '@fontsource-variable/rubik';

export const Wrap = styled.ul`
  position: absolute;
  display: flex;
  flex-wrap: wrap;
  top: 1rem;
  right: 25px;
  list-style: none;
  gap: 1rem;
`;

export const Info = styled.li`
  ${({ theme, talking }) => css`
    background: ${theme.colors.dark(0.4)};
    padding: 0 1rem;
    color: ${theme.colors.shape()};
    height: 30px;
    font-family: 'Rubik Variable', sans-serif;
    font-size : medio;
    display: flex;

    font-weight: normal;
    gap: 0.6rem;
    align-items: center;
    border-radius: 5px;
    font-size: 0.9rem;

    ${talking &&
    css`
      color: ${theme.colors.shape()};
    `}

    & > svg {
      color: ${theme.colors.shape()};
    }
  `}
`;
