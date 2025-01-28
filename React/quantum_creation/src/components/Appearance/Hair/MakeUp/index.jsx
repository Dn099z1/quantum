import { useContext } from "react";
import { RiBrushLine } from "react-icons/ri";
import Title from "../../Title";
import Slider from "../../../Slider";
import ColorPicker from "../../../ColorPicker";
import CharacterContext from "../../../../contexts/CharacterContext";
import * as S from "../styles";

function Makeup() {
  const { character, setCharacter } = useContext(CharacterContext);

  return (
    <S.Container>
      <Title icon={<RiBrushLine />} title="Maquiagem" />
      <Slider
        label="Modelo de blush"
        value={character.blushModel}
        setValue={(val) => setCharacter((old) => ({ ...old, blushModel: val }))}
        min={-1}
        middle={0}
        max={6}
        step={1}
        ruler={true}
      />
      <ColorPicker
        label="Cor do blush"
        value={character.blushColor}
        setValue={(val) => setCharacter((old) => ({ ...old, blushColor: val }))}
      />
      <Slider
        label="Opacidade de blush"
        value={character.blushOpacity}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, blushOpacity: val }))
        }
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Modelo do batom"
        value={character.lipstickModel}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, lipstickModel: val }))
        }
        min={-1}
        middle={0}
        max={9}
        step={1}
        ruler={true}
      />
      <ColorPicker
        label="Cor do batom"
        value={character.lipstickColor}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, lipstickColor: val }))
        }
      />
      <Slider
        label="Opacidade do batom"
        value={character.lipstickOpacity}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, lipstickOpacity: val }))
        }
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Modelo de Manchas"
        value={character.blemishesModel}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, blemishesModel: val }))
        }
        min={-1}
        middle={0}
        max={23}
        step={1}
        ruler={true}
      />
      <Slider
        label="Opacidade de Manchas"
        value={character.blemishesOpacity}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, blemishesOpacity: val }))
        }
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Modelo de envelhecimento"
        value={character.ageingModel}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, ageingModel: val }))
        }
        min={-1}
        middle={0}
        max={14}
        step={1}
        ruler={true}
      />
      <Slider
        label="Intensidade de envelhecimento"
        value={character.ageingOpacity}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, ageingOpacity: val }))
        }
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Aspecto"
        value={character.complexionModel}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, complexionModel: val }))
        }
        min={-1}
        middle={0}
        max={11}
        step={1}
        ruler={true}
      />
      <Slider
        label="Opacidade de aspecto"
        value={character.complexionOpacity}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, complexionOpacity: val }))
        }
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Danos de sol"
        value={character.sundamageModel}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, sundamageModel: val }))
        }
        min={-1}
        middle={0}
        max={10}
        step={1}
        ruler={true}
      />
      <Slider
        label="Intensidade dos danos de sol"
        value={character.sundamageOpacity}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, sundamageOpacity: val }))
        }
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Sardas"
        value={character.frecklesModel}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, frecklesModel: val }))
        }
        min={-1}
        middle={0}
        max={17}
        step={1}
        ruler={true}
      />
      <Slider
        label="Intensidade das sardas"
        value={character.frecklesOpacity}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, frecklesOpacity: val }))
        }
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Maquiagem"
        value={character.makeupModel}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, makeupModel: val }))
        }
        min={-1}
        middle={0}
        max={74}
        step={1}
        ruler={true}
      />
      <Slider
        label="Opacidade da maquiagem"
        value={character.makeupOpacity}
        setValue={(val) =>
          setCharacter((old) => ({ ...old, makeupOpacity: val }))
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

export default Makeup;