import styled, { css } from "styled-components";


export const Container = styled.div`
  ${({ theme }) => css`
    

    flex: 1;
    padding: 2rem 2rem 3rem;
    border-radius: 50px;
    display: flex;
    max-height: 40rem;
     
    overflow-x: hidden;
    overflow-y: auto;
    flex-direction: column;
    align-items: center;
    gap: 2rem;
  `}
`;
