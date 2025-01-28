import { useCallback, useEffect, useState } from "react";
import { ThemeProvider } from "styled-components";
import * as S from "./styles";

import TopInfos from "./components/TopInfos";
import "react-toastify/dist/ReactToastify.css";
import { ToastContainer } from "react-toastify";
import useNotification from "./hooks/useNotification";
import Prompt from "./components/Prompt";
import Clipboard from "./components/Clipboard";

function App() {
  const [time, setTime] = useState("");
  // const [street, setStreet] = useState("");
  const [hud, setHud] = useState(true);
  const [talking, setTalking] = useState(false);
  const [voice, setVoice] = useState("Normal");
  const [radio, setRadio] = useState(0);
  const [questions, setQuestions] = useState([]);
  const [clipboard, setClipboard] = useState([]);
  // const [toxic, setToxic] = useState(0);
  // const [stress, setStress] = useState(0);

  const {
    launchNotify,
    launchProgressBar,
    launchRequest,
    launchOrgNotify,
    removeRequest,
  } = useNotification();

  const nuiMessage = useCallback(
    (event) => {
      const actions = {
        updateTime: (value) => setTime(value),

        updateHud: (value) => setHud(value),
        // updateStreet: (value) => setStreet(value),
  
        updateTalking: (value) => setTalking(value),
        updateVoice: (value) => setVoice(value),

        updateRadioChannel: (value) => setRadio(value),
   
        // updateToxic: (value) => setToxic(value),
        // updateStress: (value) => setStress(value),
        notify: ({ title, message, time }) => {
          launchNotify(title, message, time);
        },
        announcement: ({ title, message, author, playAudio, time }) => {
          launchOrgNotify(title, message, author, playAudio, time);
        },
        progress: ({ title, time }) => {
          launchProgressBar(title, time);
        },
        request: ({ id, title, time }) => {
          launchRequest(id, title, time);
        },
        prompt: ({ questions }) => {
          setQuestions(questions);
        },
        removeRequest: ({ id }) => {
          removeRequest(id);
        },
        clipboard: (clipboard) => {
          setClipboard(clipboard);
        },
      };
      const { method, data } = event.data;
      if (method && actions[method]) {
        actions[method](data);
      }
    },
    [launchNotify, launchProgressBar, launchRequest, removeRequest]
  );

  useEffect(() => {
    window.addEventListener("message", nuiMessage);

    return () => {
      window.removeEventListener("message", nuiMessage);
    };
  }, [nuiMessage]);

  return (
    <ThemeProvider theme={S.theme}>
      <ToastContainer
        theme="dark"
        position="bottom-center"
        pauseOnHover={false}
        pauseOnFocusLoss={false}
      />
      <S.GlobalStyle />
      {hud && (
        <>
          <Prompt questions={questions} setQuestions={setQuestions} />
          <Clipboard clipboard={clipboard} setClipboard={setClipboard} />
          <S.WrapHud>
        
            <TopInfos
              data={{
                time,
                voice,
                talking,
                radio,
              }}
            />
            <S.BottomRight>
            

            </S.BottomRight>
          </S.WrapHud>
        </>
      )}
    </ThemeProvider>
  );
}

export default App;
