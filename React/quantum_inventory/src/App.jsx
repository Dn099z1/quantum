import { useState, useContext, useEffect } from "react";
import { ThemeProvider } from "styled-components";
import GlobalStyle from "./styles";
import theme from "./styles/theme";
import Clothes from "./components/Clothes";
import * as S from "./styles/scomponents";
import Inventory from "./components/Inventory";
import { BsArrowRight } from "react-icons/bs"; // Ícone para a setinha
import { BagsContext } from "./contexts/BagsContext";
import { DndProvider } from "react-dnd";
import { TouchBackend } from "react-dnd-touch-backend";
import ConfirmModal from "./components/ConfirmModal";
import ConfirmModalProvider from "./contexts/ConfirmModalContext";
import useRequest from "./hooks/useRequest";

function App() {
  const [showInventory, setShowInventory] = useState(false);
  const [showClothes, setShowClothes] = useState(false); // Novo estado para exibir Clothes
  const { setBags } = useContext(BagsContext);
  const { request } = useRequest();

  useEffect(() => {
    const action = (e) => {
      const { action, bag, chest, hotbar, item_types, weapons } = e.data;
      if (action === "open" || action === "update") {
        setBags((oldBags) => ({
          ...oldBags,
          bag,
          chest,
          weapons,
          hotbar,
          item_types,
        }));

        if (action === "open") {
          setShowInventory(true);
        }
      } else if (action === "close") {
        setShowInventory(false);
      }
    };

    window.addEventListener("message", action);
    window.onkeydown = async (data) => {
      if (data.keyCode == 27) {
        setShowInventory(false);
        await request("closeInventory");
      }
    };
  }, []);

  const close = async () => {
    setShowInventory(false);
    await request("closeInventory");
  };

  return (
    <>
      {showInventory && (
        <ConfirmModalProvider>
          <ThemeProvider theme={theme}>
            <DndProvider
              backend={TouchBackend}
              options={{
                enableMouseEvents: true,
              }}
            >
              <GlobalStyle />
              <ConfirmModal />
              <S.Page>
                <S.BgImage />
                <S.Filter>
                  <S.HeadInventory>
                    <S.HeadInventoryTitle>
                      
         
                    </S.HeadInventoryTitle>
                  </S.HeadInventory>
                  <Inventory />
                </S.Filter>
                
              </S.Page>
            </DndProvider>
          </ThemeProvider>
        </ConfirmModalProvider>
      )}
      {showClothes && <Clothes />}
    </>
  );
}

export default App;
