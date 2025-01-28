import styled, { css } from "styled-components";

export const Container = styled.div`
  ${({ theme }) => css`

    background-color: ${theme.colors.dark(0.9)};
    width: 80%;
    height: 750px;
    border-radius: 2rem;
    display: flex;
    padding: 2rem;
    gap: 2rem;
  `}
`;
export const TabletFrame = styled.div`
  ${({ theme }) => css`
    background-color: #1e211f;
    border-radius: 2rem;
    width: 70%;
    height: 600px;
    margin: auto;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    position: relative;
    padding: 2rem;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  `}
`;

export const MiniCarList = styled.div`
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  justify-content: center;
  overflow: hidden;
  position: relative;
  width: 100%;
`;

export const MiniCarImage = styled.img`
  width: 80px;
  height: 80px;
  object-fit: cover;
  object-position: center;
  border-radius: 5px;
  opacity: 0;
  animation: fadeIn 1s forwards;

  @keyframes fadeIn {
    0% {
      opacity: 0;
      transform: translateY(20px);
    }
    100% {
      opacity: 1;
      transform: translateY(0);
    }
  }
`;
export const Left = styled.div`
  flex: 3;
  border-radius: 5px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
`;

export const Title = styled.img`
  ${({ theme }) => css`
    font-size: 0.9rem;
    height: 35px;
    color: ${theme.colors.shape()};
    font-weight: 400;
    text-transform: uppercase;
    margin: 0;

    & > span {
      color: ${theme.colors.primary()};
    }
  `}
`;

export const LeftHeader = styled.div`
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 2rem;

  & > input-search {
    flex: 1;
  }
`;

export const Car = styled.div`
  ${({ theme }) => css`
    background-color: ${theme.colors.shape(0.05)};
    border: 2px solid ${theme.colors.shape(0.15)};
    border-radius: 10px;
    width: 100%;
    padding: 1rem;
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
  `}
`;

export const WrapIconCar = styled.div`
  ${({ theme }) => css`
    width: 100%;
    display: flex;
    justify-content: center;

    & > svg {
      font-size: 5rem;
      color: ${theme.colors.shape()};
      margin-bottom: 2rem;
    }
  `}
`;

export const CarImage = styled.img`
  height: 80px;
  align-self: center;
  margin-bottom: 1rem;
  object-fit: cover;
  object-position: center;
`;

export const CarTitle = styled.h1`
  ${({ theme }) => css`
    font-size: 1.8rem;
    font-weight: 400;
    text-transform: uppercase;
    color: ${theme.colors.shape()};
  `}
`;

export const CarSubtitle = styled.span`
  ${({ theme }) => css`
    text-transform: uppercase;
    color: orange;
    margin-bottom: 2rem;
    font-size: 1rem;
  `}
`;

export const Stats = styled.ul`
  width: 100%;
  list-style: none;
  padding: 0;
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
`;

export const ItemStats = styled.li`
  flex: 1;
  min-width: calc(50% - 0.5rem);
  display: flex;
  
  margin-bottom: 1rem;
  flex-direction: column;
  gap: 0.5rem;
`;

export const StatsLabel = styled.span`
  ${({ theme }) => css`
    color: ${theme.colors.shape()};
    text-transform: uppercase;
    font-size: 0.8rem;
  `}
`;

export const ProgressBar = styled.div`
  ${({ theme }) => css`
    background-color: ${theme.colors.shape(0.3)};
    clip-path: polygon(5% 0%, 100% 0%, 95% 100%, 0% 100%);
    width: 100%;
    height: 10px;
    display: flex;
    align-items: center;
    padding: 0 5px;
  `}
`;

export const Progress = styled.div`
  ${({ theme, progress }) => css`
    background-color: ${theme.colors.shape()};
    ${progress &&
    css`
      width: ${progress}%;
    `}
    height: calc(100% - 6px);
    transition: width 0.5s;
    border-radius: 2px;
  `}
`;

export const Actions = styled.ul`
  width: 100%;
  height: 50px;
  list-style: none;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 0.5rem;
`;

export const BtnAction = styled.li`
  ${({ theme }) => css`
    flex: 1;
    height: 80%;

    display: flex;
    justify-content: center;
    text-align: center;
    text-transform: uppercase;
    align-items: center;
    font-weight: 400;
    font-size: 0.7rem;
    border: 2px solid ${theme.colors.primary()};
    color: ${theme.colors.shape()};
    border-radius: 50px;
    cursor: pointer;
    transition: all 0.5s;

    &.active {
      background-color: ${theme.colors.shape()};
      text-shadow: 1px 1px 1px ${theme.colors.dark(0.5)};

      &:hover {
        background-color: ${theme.colors.shape(0.6)};
      }
    }

    &:hover {
      background-color: ${theme.colors.shape(0.05)};
    }
  `}
`;

export const Right = styled.div`
  width: 100%;
  flex: 5;
  display: flex;
  gap: 1rem;
  flex-direction: column;
`;

export const RightHeader = styled.div`
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

export const Filters = styled.ul`
  width: 100%;
  list-style: none;
  padding: 0;
  display: flex;
  gap: 0.5rem;
`;

export const CarFilter = styled.li`
  ${({ theme, active }) => css`
    min-width: 35px;
    height: 35px;
    background-color: ${theme.colors.shape(0.05)};
    border: 2px solid ${theme.colors.shape(0.1)};
    border-radius: 50px;
    color: ${theme.colors.shape(0.8)};
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    padding: 0 0.2rem;
    font-size: 0.8rem;

    & > svg {
      font-size: 1rem;
    }

    ${active &&
    css`
      background-color: ${theme.colors.shape(0.3)};
      color: ${theme.colors.shape()};
      border-color: ${theme.colors.shape(0.15)};
    `}
  `}
`;

export const CloseButton = styled.button`
  ${({ theme }) => css`
    color: ${theme.colors.shape(0.3)};
    font-weight: 100;
    text-transform: uppercase;
    background-color: ${theme.colors.primary(0)};
    border: 2px solid ${theme.colors.primary(0.2)};
    border-radius: 10px;
    font-size: 0.75rem;
    padding: 0 1rem;
    height: 35px;
    transition: all 0.5s;
    cursor: pointer;

    &:hover {
      color: ${theme.colors.shape()};
      border-color: ${theme.colors.primary()};
    }
  `}
`;

export const WrapCarList = styled.div`
  width: 100%;
  flex: 1;
  max-height: calc(100% - 35px - 1rem);
`;

export const CarsList = styled.ul`
  width: 90%;
  max-height: 100%;
  list-style: none;
  display: flex;
  justify-content: flex-start;
  align-items: flex-start;
  flex-wrap: wrap;
  gap: 1rem;
  padding: 0;
  overflow-x: hidden;
  overflow-y: auto;
`;

export const EmptyCarList = styled.div`
  ${({ theme }) => css`
    width: 100%;
    text-transform: uppercase;
    text-align: center;
    color: ${theme.colors.shape()};
  `}
`;

export const DealershipStatusList = styled.ul`
  list-style: none;
  padding: 0;
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-top: 1rem;
`;

export const DealershipStatus = styled.li`
  ${({ theme }) => css`
    display: flex;
    background-color: ${theme.colors.dark(0.2)};
    flex-direction: column;
    flex: 1;
    min-width: calc(50% - 0.5rem);
    padding: 0.5rem;
    border-radius: 5px;
  `}
`;

export const DealerTitle = styled.small`
  ${({ theme }) => css`
    color: ${theme.colors.primary()};
    display: flex;
    flex-direction: column;
    font-size: 0.7rem;
  `}
`;

export const DealerValue = styled.span`
  ${({ theme }) => css`
    color: ${theme.colors.shape()};
    display: flex;
    flex-direction: column;
  `}
`;

