import * as S from "./styles";
import Input from "../../Input";
import Title from "../Title";
import { AiOutlineIdcard } from "react-icons/ai";
import { useContext } from "react";
import CharacterContext from "../../../contexts/CharacterContext";

function Identity() {
  const { character, setCharacter } = useContext(CharacterContext);

  return (
    <S.Container>
      <Title icon={<AiOutlineIdcard />} title="Identidade" />
      <Input
        label="Nome"
        placeholder="Ex: Arnaldo"
        value={character.name}
        onChange={(e) =>
          setCharacter((old) => ({ ...old, name: e.target.value }))
        }
      />
      <Input
        label="Sobrenome"
        placeholder="Ex: Da Silva"
        value={character.surname}
        onChange={(e) =>
          setCharacter((old) => ({ ...old, surname: e.target.value }))
        }
      />
      <Input
        label="Idade"
        type="number"
        value={character.age}
        onChange={(e) =>
          setCharacter((old) => ({ ...old, age: Number(e.target.value) }))
        }
        min={18}
        max={100}
        placeholder="Ex: 25"
      />
      <S.GenderButtons>
        <S.GenderButton
          selected={character.gender === "masculino"}
          onClick={() =>
            setCharacter((old) => ({ ...old, gender: "masculino" }))
          }
        >
          Homem
        </S.GenderButton>
        <S.GenderButton
          selected={character.gender === "feminino"}
          onClick={() =>
            setCharacter((old) => ({ ...old, gender: "feminino" }))
          }
        >
          Mulher
        </S.GenderButton>
      </S.GenderButtons>
    
    </S.Container>
  );
}

export default Identity;
