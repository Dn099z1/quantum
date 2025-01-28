import React from 'react';
import { useContext } from 'react';
import { AiOutlineEye } from 'react-icons/ai';
import { VscEye } from 'react-icons/vsc';
import Slider from '../../../Slider';
import Title from '../../Title';
import ColorPicker from '../../../ColorPicker';
import CharacterContext from '../../../../contexts/CharacterContext';
import * as S from "../styles";
function EyeFeatures() {
  const { character, setCharacter } = useContext(CharacterContext);

  return (
    <>
    <S.Container>
      <Title icon={<AiOutlineEye />} title="Olhos" />
      <Slider
        label="Cor dos olhos"
        value={character.eyesColor}
        setValue={(val) => setCharacter((old) => ({ ...old, eyesColor: val }))}
        min={0}
        max={31}
        step={1}
        ruler={true}
      />
      <Slider
        label="Abertura dos olhos"
        value={character.eyesOpening}
        setValue={(val) => setCharacter((old) => ({ ...old, eyesOpening: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Title icon={<VscEye />} title="Sobrancelhas" space={true} />
      <Slider
        label="Altura das Sobrancelhas"
        value={character.eyebrowsHeight}
        setValue={(val) => setCharacter((old) => ({ ...old, eyebrowsHeight: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Largura das Sobrancelhas"
        value={character.eyebrowsWidth}
        setValue={(val) => setCharacter((old) => ({ ...old, eyebrowsWidth: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Modelo das Sobrancelhas"
        value={character.eyebrowsModel}
        setValue={(val) => setCharacter((old) => ({ ...old, eyebrowsModel: val }))}
        min={0}
        max={33}
        step={1}
        ruler={true}
      />
      <ColorPicker
        label="Cor das Sobrancelhas"
        value={character.eyebrowsColor}
        setValue={(val) => setCharacter((old) => ({ ...old, eyebrowsColor: val }))}
      />
      <Slider
        label="Opacidade das Sobrancelhas"
        value={character.eyebrowsOpacity}
        setValue={(val) => setCharacter((old) => ({ ...old, eyebrowsOpacity: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      </S.Container>
    </>
  );
}

export default EyeFeatures;