import * as S from "./styles";

import { AiOutlineIdcard, AiOutlineCheckCircle } from "react-icons/ai";
import { RiParentLine } from "react-icons/ri";
import { ScanFace, EyeClosed, Eye } from "lucide-react";
import { GiComb } from "react-icons/gi";
import { useContext, useState } from "react";
import Identity from "./Identity";
import Parents from "./Parents";
import { GiNoseFront  } from "react-icons/gi";
import Hair from "./Hair/Hair";
import Makeup from "./Hair/MakeUp";
import Facial from "./Hair/Facial";
import { MdFaceRetouchingNatural } from "react-icons/md";
import NoseFeatures from "./Face/Nose";
import EyeFeatures from "./Face/Eyes";
import MouthFeatures from "./Face/Mouth";

import useRequest from "../../hooks/useRequest";
import CreationContext from "../../contexts/CreationContext";

function Appearance() {
  const [tab, setTab] = useState("identity");
  const { request } = useRequest();
  const { setCreation } = useContext(CreationContext);

  const handleFinish = async () => {
    await request("finish");
  };

  // Mapeamento das abas
  const renderTabContent = () => {
    switch (tab) {
      case "identity":
        return <Identity />;
      case "parents":
        return <Parents />;
      case "nose":
        return <NoseFeatures />;
      case "eyes":
        return <EyeFeatures />;
      case "mouth":
        return <MouthFeatures />;
      case "facial":
        return <Facial />;
      case "makeup":
        return <Makeup />;
      case "hair":
        return <Hair />;
      default:
        return null;
    }
  };

  return (
    <S.Container>
      {/* <S.Header>
        <S.Title>
          <span>
            CRIAÇÃO DE PERSONAGEM
          </span>
          
        </S.Title>
      
      </S.Header> */}
      <S.Tabs>
        <S.TabsList>
          <S.TabButton
            active={tab === "identity"}
            onClick={() => setTab("identity")}
          >
            <AiOutlineIdcard />
            {/* <span>Identidade</span> */}
          </S.TabButton>
          <S.TabButton
            active={tab === "parents"}
            onClick={() => setTab("parents")}
          >
            <RiParentLine />
            {/* <span>Família</span> */}
          </S.TabButton>
          <S.TabButton
            active={tab === "nose"}
            onClick={() => setTab("nose")}
          >
           <GiNoseFront  />
            {/* <span>Nariz</span> */}
          </S.TabButton>
          <S.TabButton
            active={tab === "eyes"}
            onClick={() => setTab("eyes")}
          >
            <Eye />
            {/* <span>Olhos</span> */}
          </S.TabButton>
          <S.TabButton
            active={tab === "mouth"}
            onClick={() => setTab("mouth")}
          >
            <MdFaceRetouchingNatural  />
            {/* <span>Boca</span> */}
          </S.TabButton>
          <S.TabButton active={tab === "hair"} onClick={() => setTab("hair")}>
            <GiComb />
            {/* <span>Salão</span> */}
          </S.TabButton>
          <S.TabButton
            active={tab === "makeup"}
            onClick={() => setTab("makeup")}
          >
            <EyeClosed />
            {/* <span>Maquiagem</span> */}
          </S.TabButton>
          <S.TabButton
            active={tab === "facial"}
            onClick={() => setTab("facial")}
          >
            <ScanFace />
            {/* <span>Facial</span> */}
          </S.TabButton>
         
        </S.TabsList>
      </S.Tabs>
      <S.Button className="finish" onClick={handleFinish}>
 

        <span>Finalizar</span>
          </S.Button>

      <S.TabContent>{renderTabContent()}</S.TabContent>
    </S.Container>
  );
}

export default Appearance;
