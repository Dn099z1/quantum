import * as S from "./styles";

function DisplayParents({ parent1, parent2 }) {
  return (
    <S.Container>
      <S.Parent1
        src={`https://host-two-ochre.vercel.app/files/creator/${parent1}.png`}
      />
      <S.Parent2
        src={`https://host-two-ochre.vercel.app/files/creator/${parent2}.png`}
      />
    </S.Container>
  );
}

export default DisplayParents;
