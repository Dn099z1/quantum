import styled, { css } from "styled-components";

export const Container = styled.div`
  ${({ theme }) => css`
    flex: 1;
    padding: 2rem 2rem 3rem;
    border-radius: 50px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.5rem;
  `}
`;

export const GenderButtons = styled.div`
  display: flex;
  gap: 1rem;
`;
export const Button = styled.button`
  margin-top: 20px;
  padding: 10px 20px;
  background-color: #007BFF;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  
  &:hover {
    background-color: #0056b3;
  }
`;
export const GenderButton = styled.button`
  ${({ selected, theme }) => css`
    padding: 0.5rem 1.5rem;
    
    border-radius: 40px;

    font-weight: bold;
    cursor: pointer;
    border: 2px solid #363534;
    background-color: ${selected ? (theme === "masculino" ? "#c78b50" : "#c78b50") : "#363534"};
    color: ${selected ? "#fff" : "#fff"};
    transition: all 0.3s ease;

    &:hover {
      opacity: 0.8;
    }
  `}
`;
