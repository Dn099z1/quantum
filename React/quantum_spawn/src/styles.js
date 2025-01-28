import styled, { createGlobalStyle, css } from "styled-components";
import '@fontsource/krona-one';
import '@fontsource-variable/orbitron';

export const theme = {
  colors: {
    shape: (opacity = 1) => `rgba(255, 255, 255, ${opacity})`,
    dark: (opacity = 1) => `rgba(0, 0, 0, ${opacity})`,
    primary: (opacity = 1) => `rgba(199, 167, 40, ${opacity})`,
    accept: (opacity = 1) => `rgba(0, 204, 102, ${opacity})`,
    reject: (opacity = 1) => `rgba(255, 26, 26, ${opacity})`,
  },
  fonts: {
    family: {
      primary: "'Geologica', sans-serif",
    },
  },
};

export const GlobalStyle = createGlobalStyle`
    ${({ theme }) => css`



      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        -webkit-font-smoothing: antialiased;
      }

      html {
        width: 100%;
      }


      body {
      background: linear-gradient(to right, rgba(0, 0, 0, 0.7), transparent);


       overflow: hidden;
        width: 100%;
        height: 100vh;
        margin: 0;
        padding: 0;
        position: relative;
      
      }

      body,
      h1,
      h2,
      h3,
      h4,
      h5,
      h6,
      input,
      button,
      textarea {
        font-family: ${theme.fonts.family.primary};
      }

      strong {
        font-weight: normal;
        display: block;
        font-size: 0.8rem;
      }

      p {
        font-size: 0.8rem;
        margin-top: 0.6rem;
        font-weight: 100;
        color: ${theme.colors.shape(0.7)};
      }

      span.author {
        margin-top: 0.6rem;
        font-size: 0.7rem;
        color: ${theme.colors.primary()};
      }

      ::-webkit-scrollbar {
        width: 2px;
      }

      /* Track */
      ::-webkit-scrollbar-track {
        background: ${theme.colors.dark()};
      }

      /* Handle */
      ::-webkit-scrollbar-thumb {
        background: ${theme.colors.primary()};
      }

      /* Handle on hover */
      ::-webkit-scrollbar-thumb:hover {
        background: ${theme.colors.primary()};
      }
    `}
`;

export const Wrap = styled.div`
  position: relative;
  width: 100%;
  height: 100vh;
`;






export const Container = styled.div`
  background: ${theme.colors.shape};
  padding: 2rem;
  border-radius: 10px;
  width: 350px;
  text-align: center;
  position: relative; /* Ou absolute, dependendo do seu layout */
  top: 15rem; /* Ajuste a distância conforme necessário */
  
  img {
  position: relative;
  top: -15rem;  
  }

    @media (max-width: 768px) {
    padding: 1.5rem;
  }

  @media (max-width: 480px) {
    padding: 1rem;
  }
`;





export const Subtitle = styled.h2`
  font-size: 0.8rem;
  position: relative;
  top: -11rem;
  color: rgba(255,255,255,0.5);
  margin-bottom: 2rem;
  text-transform: uppercase;
  @media (max-width: 768px) {
    font-size: 1rem;
  }
`;

export const CharacterList = styled.div`
  display: flex;
  align-items: center;
  flex-direction: column;
  
  gap: 1rem;
`;

export const Avatar = styled.img`
  width: 45px;
  height: 45px;
  border-radius: 50%;
  margin-top: 190%;
  object-fit: cover;
  border: 2px solid rgba(255, 255, 255, 0.2);
  transition: border-color 0.3s ease;
  flex-shrink: 0; /* Evita que o avatar encolha */
  margin-right: 1rem; /* Adiciona algum espaço à direita do avatar */
`;

export const Card = styled.div`
  padding: 1.5rem;
  width: 20rem;
  height: 5rem;
  background: rgb(20, 20, 20);

  color: #fff;
  border-radius: 12px;
  cursor: ${({ locked }) => (locked ? "not-allowed" : "pointer")};
  transition: all 0.3s ease;
  border: 2px solid rgba(255, 255, 255, 0.2);
  display: flex;
  align-items: center;
  position: relative;

  &:hover {
    transform: translateY(-2px);
    border: 1px solid rgba(255, 255, 255, 0.4);
    background: rgba(30, 30, 30, 0.95);
  }

  @media (max-width: 480px) {
    width: 18rem;
    padding: 1.25rem;
  }
`;




export const CardContent = styled.div`
  display: flex;
  align-items: center;
  gap: 1rem;
  width: 100%;
   padding: 0.5rem;
`;

export const Icon = styled.span`
  font-size: 1.5rem;
  @media (max-width: 480px) {
    font-size: 1.2rem;
  }
`;


export const Name = styled.h3`
  font-size: 1.1rem;
  font-weight: 600;
  letter-spacing: 0.5px;
  color: rgba(255, 255, 255, 0.95);
  display: flex;
  align-items: center;
  gap: 0.5rem;

  span {
    font-size: 0.8rem;
    color: rgba(255, 255, 255, 0.6);
    font-weight: 400;
  }
`;

export const LoadingWrap = styled.div`
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  height: 100vh;

`;

export const LoadingText = styled.p`
  font-size: 24px;
  color: white;
  margin-bottom: 20px;
`;


export const LoadingBar = styled.div`
  height: 100%;
  width: ${({ progress }) => `${progress}%`};

  transition: width 0.2s ease;
`;

export const LockedIcon = styled.div`

`;

export const ContentWrapper = styled.div`
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
`;

export const Job = styled.h4`
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.7);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  font-weight: 400;
`;


export const LockedText = styled.h3`
  font-size: 1rem;
  color: rgba(255, 255, 255, 0.7);
  font-weight: 500;
  letter-spacing: 0.5px;
`;




export const Filter = styled.div`
  ${({ theme }) => css`
    width: 100%;
    height: 100vh;
    background-color: ${theme.colors.dark(0.5)};
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
    position: absolute;
    gap: 5rem;
    top: 0;
    left: 0;
  `}
`;

export const Title = styled.h1`
  ${({ theme }) => css`
    color: ${theme.colors.shape()};
    font-family: 'Krona One', sans-serif;
    top: -12rem;
    position: relative;
    text-transform: uppercase;
    letter-spacing: 1px;
  `}
`;

export const List = styled.div`
  display: flex;
  gap: 2rem;
`;

export const ActionList = styled.div`
  display: flex;
  gap: 2rem;
`;

export const Logo = styled.img`
  width: 50rem;
  opacity: 0.1;
`;

