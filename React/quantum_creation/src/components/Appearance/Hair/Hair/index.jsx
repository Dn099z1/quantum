import { useContext } from "react";
import { GiComb } from "react-icons/gi";
import Title from "../../Title";
import Slider from "../../../Slider";
import ColorPicker from "../../../ColorPicker";
import CharacterContext from "../../../../contexts/CharacterContext";
import * as S from "../styles";

function Hair() {
  const { character, setCharacter } = useContext(CharacterContext);

  return (
    <S.Container>
      <Title icon={<GiComb />} title="Cabelo" />
      <Slider
        label="Modelo de cabelo"
        value={character.hairModel}
        setValue={(val) => setCharacter((old) => ({ ...old, hairModel: val }))}
        min={0}
        max={147}
        step={1}
        ruler={true}
      />
      <ColorPicker
        label="Cor de cabelo 1"
        value={character.firstHairColor}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, firstHairColor: val }))
        }
      />
      <ColorPicker
        label="Cor de cabelo 2"
        value={character.secondHairColor}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, secondHairColor: val }))
        }
      />
    </S.Container>
  );
}

export default Hair;