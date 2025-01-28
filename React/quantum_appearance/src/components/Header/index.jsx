import * as S from "../GenericalStyles";
import { useContext } from "react";
import CamContext from "../../contexts/CamContext";
import { MdFace } from "react-icons/md";
import { IoMdBody } from "react-icons/io";

function Header({ title, icon }) {
  const { cam, setCam } = useContext(CamContext);

  const handleChangeCam = () => {
    if (cam.type === "body") {
      setCam((old) => ({
        ...old,
        type: "head",
      }));
    } else {
      setCam((old) => ({
        ...old,
        type: "body",
      }));
    }
  };

  return (
    <S.Header>
      <S.HeaderDivider position="flex-start">
        <S.Logo src="https://host-two-ochre.vercel.app/files/valley_sem_fundo.png" />
      </S.HeaderDivider>
      <S.HeaderDivider position="center">
        <S.Title>
          <S.WrapIcon>{icon}</S.WrapIcon>
          {title}
        </S.Title>
      </S.HeaderDivider>
      <S.HeaderDivider position="flex-end">
        <S.PovButton onClick={handleChangeCam}>
          {cam.type === "head" ? <MdFace /> : <IoMdBody />}
        </S.PovButton>
      </S.HeaderDivider>
    </S.Header>
  );
}

export default Header;
