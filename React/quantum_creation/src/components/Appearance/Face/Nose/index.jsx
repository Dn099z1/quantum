import React from 'react';
import { useContext } from 'react';
import { GiNoseFront } from 'react-icons/gi';
import { CgSmileNoMouth } from 'react-icons/cg';
import Slider from '../../../Slider';
import Title from '../../Title';
import CharacterContext from '../../../../contexts/CharacterContext';
import * as S from "../styles";
function NoseFeatures() {
  const { character, setCharacter } = useContext(CharacterContext);

  return (
    <>
    <S.Container>
      <Title icon={<GiNoseFront />} title="Nariz" space={true} />
      <Slider
        label="Largura do nariz"
        value={character.noseWidth}
        setValue={(val) => setCharacter((old) => ({ ...old, noseWidth: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Altura do nariz"
        value={character.noseHeight}
        setValue={(val) => setCharacter((old) => ({ ...old, noseHeight: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Comprimento do nariz"
        value={character.noseLength}
        setValue={(val) => setCharacter((old) => ({ ...old, noseLength: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Ponte nasal"
        value={character.noseBridge}
        setValue={(val) => setCharacter((old) => ({ ...old, noseBridge: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Ponta do nariz"
        value={character.noseTip}
        setValue={(val) => setCharacter((old) => ({ ...old, noseTip: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Variação do nariz"
        value={character.noseShift}
        setValue={(val) => setCharacter((old) => ({ ...old, noseShift: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Title icon={<CgSmileNoMouth />} title="Bochechas" space={true} />
      <Slider
        label="Altura dos ossos da bochecha"
        value={character.cheekboneHeight}
        setValue={(val) => setCharacter((old) => ({ ...old, cheekboneHeight: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Largura dos ossos da bochecha"
        value={character.cheekboneWidth}
        setValue={(val) => setCharacter((old) => ({ ...old, cheekboneWidth: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Largura da bochecha"
        value={character.cheeksWidth}
        setValue={(val) => setCharacter((old) => ({ ...old, cheeksWidth: val }))}
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

export default NoseFeatures;