import { useContext } from "react";
import { GiBeard } from "react-icons/gi";
import { BiBody } from "react-icons/bi";
import Title from "../../Title";
import Slider from "../../../Slider";
import ColorPicker from "../../../ColorPicker";
import CharacterContext from "../../../../contexts/CharacterContext";
import * as S from "../styles";

function Facial() {
  const { character, setCharacter } = useContext(CharacterContext);

  return (
    <S.Container>
      <Title icon={<GiBeard />} title="Barba" />
      <Slider
        label="Modelo de barba"
        value={character.beardModel}
        setValue={(val) => setCharacter((old) => ({ ...old, beardModel: val }))}
        min={-1}
        middle={0}
        max={28}
        step={1}
        ruler={true}
      />
      <ColorPicker
        label="Cor da barba"
        value={character.beardColor}
        setValue={(val) => setCharacter((old) => ({ ...old, beardColor: val }))}
      />
      <Slider
        label="Opacidade da barba"
        value={character.beardOpacity}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, beardOpacity: val }))
        }
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />

      <Title icon={<BiBody />} title="Pelos corporais" space={true} />
      <Slider
        label="Modelo dos pelos"
        value={character.chestModel}
        setValue={(val) => setCharacter((old) => ({ ...old, chestModel: val }))}
        min={-1}
        middle={0}
        max={16}
        step={1}
        ruler={true}
      />
      <ColorPicker
        label="Cor dos pelos"
        value={character.chestColor}
        setValue={(val) => setCharacter((old) => ({ ...old, chestColor: val }))}
      />
      <Slider
        label="Opacidade dos pelos"
        value={character.chestOpacity}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, chestOpacity: val }))
        }
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
    </S.Container>
  );
}

export default Facial;