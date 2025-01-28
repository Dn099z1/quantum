import styled, { createGlobalStyle, css } from "styled-components";

export const theme = {
  colors: {
    shape: (opacity = 1) => `rgba(255, 255, 255, ${opacity})`,
    dark: (opacity = 1) => `rgba(0, 0, 0, ${opacity})`,
    primary: (opacity = 1) => `rgba(207, 183, 27, ${opacity})`,
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

export const Wrap = styled.section`
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
`;

export const Identify = styled.div`
  ${({ theme }) => css`
    background-color: ${theme.colors.dark(0.7)};
    width: 40rem;
    padding: 2rem;
    margin-bottom: 2rem;
    border-radius: 50px;
    display: flex;
    gap: 1rem;
    position: relative;
    overflow: hidden;
    
    /* Borda externa */
    border: 10px solid #272928;
    
    /* Borda interna (simulando o frame do tablet) */
    box-shadow: inset 0 0 0 5px #1b1c1c;

    /* Estilo do conteúdo */
    background-color: ${theme.colors.dark(0.7)};
  `}
`;


export const Left = styled.div`
  width: 40%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 1rem;
`;

export const WrapLogo = styled.div`
  ${({ theme }) => css`
    background-color: ${theme.colors.dark(0.25)};
    border: 2px solid ${theme.colors.shape(0.3)};
    height: 3.3rem;
    width: 100%;
    border-radius: 300px;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 0.5rem 0;
  `}
`;

export const Logo = styled.img`
  height: 100%;
`;

export const WrapImage = styled.div`
  border: 5px solid ${theme.colors.shape(0.2)};
  border-radius: 30px;
  width: 100%;
  height: 17rem;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
`;

export const Image = styled.img`
  object-fit: cover;
  object-position: center;
  width: 100%;
  height: 100%;
  border-radius: 30px;
`;

export const BtnImage = styled.button`
  ${({ theme }) => css`
    background-color: ${theme.colors.primary(0.8)};
    width: 3rem;
    height: 3rem;
    border-radius: 50%;
    color: ${theme.colors.shape()};
    font-size: 1.5rem;
    display: flex;
    justify-content: center;
    align-items: center;
    border: 0;
    box-shadow: 3px 3px 3px ${theme.colors.dark(0.8)};
    position: absolute;
    bottom: -1.5rem;
    cursor: pointer;

    &:hover {
      background-image: linear-gradient(
        to bottom,
        ${theme.colors.dark(0.1)},
        ${theme.colors.dark(0.1)}
      );
      background-color: ${theme.colors.primary()};
    }
  `}
`;

export const WrapInfos = styled.div`
  flex: 1;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 1rem;
`;

export const Header = styled.div`
  ${({ theme }) => css`
    background-color: ${theme.colors.dark(0.2)};
    border: 1px solid ${theme.colors.shape(0.3)};
    height: 3.3rem;
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.7rem;
    border-radius: 30px;
    gap: 0.5rem;
    position: relative;
  `}
`;

export const LeftHeader = styled.div`
  display: flex;
  gap: 0.5rem;
`;

export const WrapName = styled.div`
  display: flex;
  flex-direction: column;
`;

export const IdNumber = styled.div`
  ${({ theme }) => css`
    background-color: ${theme.colors.primary(0.1)};
    border: 2px solid ${theme.colors.shape(0.25)};
    height: 100%;
    padding: 0.5rem;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 0.7rem;
    border-radius: 30px;
    color: ${theme.colors.shape()};
  `}
`;

export const Name = styled.strong`
  ${({ theme }) => css`
    color: ${theme.colors.shape()};
    font-size: 0.8rem;
    text-transform: uppercase;
  `}
`;

export const Job = styled.span`
  ${({ theme }) => css`
    color: ${theme.colors.primary()};
    font-size: 0.75rem;
  `}
`;

export const InfoList = styled.ul`
  list-style: none;
  padding: 0;
  width: 100%;
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
`;

export const Info = styled.li`
  ${({ theme }) => css`
    /* background-color: ${theme.colors.dark(0.2)}; */
    flex: 1;
    min-width: calc(50% - 0.5rem);
    height: 3.2rem;
    border-bottom: 1px solid ${theme.colors.shape(0.1)};
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 0.4rem;

    &.highlight {
      background-color: ${theme.colors.dark(0.2)};
      border-radius: 30px;
      padding: 0.5rem;
      border: 0;
    }
  `}
`;

export const InfoLabel = styled.span`
  ${({ theme }) => css`
    color: ${theme.colors.primary()};
    font-size: 0.7rem;
  `}
`;

export const InfoContent = styled.span`
  ${({ theme }) => css`
    color: ${theme.colors.shape()};
    font-size: 0.7rem;
    text-transform: uppercase;
    display: flex;
    align-items: center;
    gap: 0.3rem;

    & > svg {
      color: ${theme.colors.primary()};
      font-size: 1rem;
    }
  `}
`;

export const ModalImage = styled.div`
  ${({ theme }) => css`
    background-color: ${theme.colors.dark(0.5)};

    border: 1px solid ${theme.colors.primary(0.3)};
    position: absolute;
    align-self: flex-start;
    width: 20rem;
    padding: 1rem;
    border-radius: 20px;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    margin-top: 5%;
    box-shadow: 3px 3px 3px ${theme.colors.dark(0.5)};
  `}
`;

export const TitleForm = styled.span`
  ${({ theme }) => css`
    color: ${theme.colors.shape()};
    font-size: 0.8rem;
  `}
`;

export const Form = styled.div`
  width: 100%;
  display: flex;
  gap: 0.5rem;
`;

export const Input = styled.input`
  ${({ theme }) => css`
    background-color: ${theme.colors.dark(0.2)};
    border: 1px solid ${theme.colors.shape()};
    height: 2rem;
    flex: 1;
    border-radius: 30px;
    outline: none;
    padding: 0 0.5rem;
    color: ${theme.colors.shape()};
    font-weight: lighter;

    &::placeholder {
      color: ${theme.colors.shape(0.5)};
    }
  `}
`;

export const CancelImageButton = styled.button`
  ${({ theme }) => css`
    background-color: ${theme.colors.dark(0.2)};
    border: 1px solid ${theme.colors.primary()};
    color: ${theme.colors.shape()};
    border-radius: 30px;
    width: 2rem;
    height: 2rem;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
  `}
`;

export const SubmitImageButton = styled.button`
  ${({ theme }) => css`
    width: 2rem;
    height: 2rem;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: ${theme.colors.primary()};
    border: 1px solid ${theme.colors.primary()};
    color: ${theme.colors.shape()};
    border-radius: 30px;
    cursor: pointer;
  `}
`;

export const ButtonCloseImage = styled.button`
  ${({ theme }) => css`
    background-color: transparent;
    border: 0;
    color: ${theme.colors.shape()};
    width: 1rem;
    height: 1rem;
    display: flex;
    justify-content: center;
    align-items: center;
    position: absolute;
    top: 0.5rem;
    right: 0.5rem;
    cursor: pointer;
  `}
`;
