import styled, { css } from "styled-components";

export const Container = styled.div`
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
`;

export const Label = styled.label`
  ${({ theme }) => css`
    color: ${theme.colors.shape()};
    text-transform: uppercase;
    font-size: 0.7rem;
  `}
`;

export const Input = styled.input`
  ${({ theme }) => css`
    background-color: rgba(122, 122, 121, 0.28);
    border: 2px solid ${theme.colors.shape(0.1)};
    border-radius: 12px;
    outline: 0;
    height: 40px;
    transition: border-color 0.5s;
    padding: 0 0.5rem;
    color: ${theme.colors.shape()};

    &:focus {
      border-color: ${theme.colors.shape()};
    }
  `}
`;
