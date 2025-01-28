import { useCallback, useEffect, useState } from "react";
import * as S from "./styles";
import { ThemeProvider } from "styled-components";
import CharacterCard from "./components/CharacterCard";
import useRequest from "./hooks/useRequest";
import { FaPlay } from "react-icons/fa";
import "./index.css";
function App() {
  const [characters, setCharacters] = useState({});
  const [selectedCharacter, setSelectedCharacter] = useState(null);
  const { request } = useRequest();

  const nuiMessage = useCallback((event) => {
    const { action, characterList } = event.data;
    if (action === "open") {
      setCharacters(characterList);
    }
  }, []);

  useEffect(() => {
    window.addEventListener("message", nuiMessage);
    window.onkeydown = async (data) => {
      if (data.keyCode === 27) {
        setCharacters({});
        setSelectedCharacter(null); // Limpa a seleção ao fechar
        request("close");
      }
    };

    return () => {
      window.removeEventListener("message", nuiMessage);
    };
  }, [nuiMessage, request]);

  const handleSelectCharacter = (index) => {
    setSelectedCharacter(index); // Marca o personagem selecionado
  };

  const handlePlay = () => {
    if (selectedCharacter !== null) {
      request("selectCharacter", { index: selectedCharacter });
      setCharacters({});
      setSelectedCharacter(null); // Limpa após selecionar
    }
  };

  return (
    <>
      {Object.keys(characters).length > 0 && (
        <ThemeProvider theme={S.theme}>
          <S.GlobalStyle />
          <S.Wrap>
            <S.Container>
              <S.Title className="text-2xl font-mono font-extrabold ">
                Personagens
              </S.Title>
              <S.Subtitle className="font-extrabold ">
                Selecione um personagem <b /> para você interpretar
              </S.Subtitle>
              <S.CharacterList>
                {Object.entries(characters).map(([key, character]) => (
                  <CharacterCard
                    key={key}
                    name={character.name}
                    avatar={character.avatar}
                    job={character.job}
                    identifier={character.id}
                    onClick={() => handleSelectCharacter(key)}
                    isLocked={character.locked}
                  />
                ))}
              </S.CharacterList>

              {selectedCharacter !== null && (
                <button onClick={handlePlay} class="btn">
                  <FaPlay className="text-white" />

                  <span class="text">Jogar</span>
                </button>
              )}
            </S.Container>
          </S.Wrap>
        </ThemeProvider>
      )}
    </>
  );
}

export default App;
