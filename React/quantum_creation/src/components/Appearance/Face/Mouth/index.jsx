import React from 'react';
import { useContext } from 'react';
import { GiLips } from 'react-icons/gi';
import { SiEgghead } from 'react-icons/si';
import Slider from '../../../Slider';
import Title from '../../Title';
import CharacterContext from '../../../../contexts/CharacterContext';
import * as S from "../styles";

function MouthFeatures() {
  const { character, setCharacter } = useContext(CharacterContext);

  return (
    <>
    <S.Container>
      <Title icon={<GiLips />} title="Boca" space={true} />
      <Slider
        label="Lábios"
        value={character.lips}
        setValue={(val) => setCharacter((old) => ({ ...old, lips: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Largura da mandíbula"
        value={character.jawWidth}
        setValue={(val) => setCharacter((old) => ({ ...old, jawWidth: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Altura da mandíbula"
        value={character.jawHeight}
        setValue={(val) => setCharacter((old) => ({ ...old, jawHeight: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Title icon={<SiEgghead />} title="Queixo" space={true} />
      <Slider
        label="Comprimento do queixo"
        value={character.chinLength}
        setValue={(val) => setCharacter((old) => ({ ...old, chinLength: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Posição do queixo"
        value={character.chinPosition}
        setValue={(val) => setCharacter((old) => ({ ...old, chinPosition: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Largura do queixo"
        value={character.chinWidth}
        setValue={(val) => setCharacter((old) => ({ ...old, chinWidth: val }))}
        min={-1}
        middle={0}
        max={0.99}
        step={0.01}
        ruler={true}
      />
      <Slider
        label="Formato do queixo"
        value={character.chinShape}
        setValue={(val) => setCharacter((old) => ({ ...old, chinShape: val }))}
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

export default MouthFeatures;