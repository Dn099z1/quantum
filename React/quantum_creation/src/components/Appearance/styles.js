import styled, { css } from "styled-components";

export const Container = styled.div`
  ${({ theme }) => css`
    background-image: linear-gradient(
      to right,
      ${theme.colors.black(0.9)},
      ${theme.colors.black(0.5)},
      ${theme.colors.black(0)}
    );
    padding: 2rem;
    position: absolute;
    left: 0;
    width: 32%;
    
    display: flex;
    flex-direction: column;
    height: 100vh;
    gap: 5rem;
  `}
`;

export const Button = styled.button`
  padding: 10px 20px;
  width: 10rem;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: rgb(0, 255, 170);
  color: black;
  border: none;
  font-size: 15px;
  font-weight: 700;
  border-radius: 5px;
  cursor: pointer;

  position: absolute;
  bottom: 20px; /* Distância da parte inferior */
  left: 145%; /* Move para o centro horizontal do contêiner */
  transform: translateX(-50%); /* Centraliza horizontalmente */

  &:hover {
    background-color: rgba(0, 255, 170, 0.54);
  }
`;



export const Header = styled.div`
  display: flex;
  gap: 2rem;
  position: relative;
  top: -4rem;
  left: -5rem;
  width: 100%;
  justify-content: center;
  transform: perspective(500px) rotateY(30deg);  
  align-items: center;
`;


export const Title = styled.h1`
  ${({ theme }) => css`
    color: ${theme.colors.shape()};
    text-transform: uppercase;
    padding-top: 4rem;
    padding-left: 1rem;
    position: relative;
    width: 70%;
    height: 125px;

    & > span {
      position: absolute;
      font-size: 2.4rem;
     
      letter-spacing: 3px;
      text-shadow: 1px 1px ${theme.colors.dark(0.5)};
    }

    &::before {
      position: absolute;
      content: "";


      width: 100%;
      height: 5.5rem;
    }
  `}
`;

export const Description = styled.p`
  ${({ theme }) => css`
    color: ${theme.colors.shape()};
    font-size: 1.2rem;

  `}
`;


export const TabContent = styled.div`
  flex: 1;
  left: 4rem;

  border-radius: 2rem;
  width: 100%;
  height: calc(100% - 10rem);
  display: flex;
  justify-content: center;
  align-items: center;
  position: absolute;
  top: 5rem; 
`;

export const Tabs = styled.div`
  width: 60%;
  flex: 1;
 margin-top: 20vh;
  display: flex;
  align-items: center;
  gap: 2rem;
`;

export const TabsList = styled.ul`
  list-style: none;
  padding: 0;
  width: 5rem;
  height: 100%;
  gap: 1.5rem;
  display: flex;
  align-items: flex-start;
  flex-direction: column;
`;

export const TabButton = styled.li`
  ${({ theme, active }) => css`
    background-color: ${theme.colors.black(0.6)};
    width: 2.5rem;
    height: 2.5rem;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    color: ${theme.colors.shape()};
    border-radius: 50%;
    border: 1px solid ${theme.colors.shape(0)};
    outline: 2px solid ${theme.colors.shape(0.2)};
    gap: 1rem;
    transition: all 0.3s ease;
    cursor: pointer;

    & > svg {
      font-size: 1.2rem;
      color: ${theme.colors.shape()};
    }

    & > span {
      text-transform: uppercase;
      font-size: 0.5rem;
    }

    &:hover {
      background-color: ${theme.colors.dark(0.5)};
    }

    ${active &&
    css`
      background-color: ${theme.colors.dark(0.4)};
      outline: 2px solid ${theme.colors.primary(0.3)};
    `}

    &.finish {
      background-color: #51eda1;

      & > svg {
        color: ${theme.colors.dark()};
      }
    }
  `}
`;