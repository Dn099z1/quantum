import { useContext, useEffect, useState } from "react";
import * as S from "./styles";
import PagesContext from "../../contexts/PagesContext";
import { UserContext } from "../../contexts/UserContext";
import LogoFac from "../../assets/logo_fac.png";
import LogoJob from "../../assets/logo_job.png";
import { useSpring, animated } from "@react-spring/web";

const logos = {
  fac: LogoFac,
  job: LogoJob,
};

const Login = () => {
  const { setCurrentPage } = useContext(PagesContext);
  const { user } = useContext(UserContext);
  const [progress, setProgress] = useState(0);

  // Efeito para simular progresso
  useEffect(() => {
    const interval = setInterval(() => {
      setProgress((prev) => {
        if (prev >= 100) {
          clearInterval(interval);
          setCurrentPage("membros"); // Chama a página após completar
          return 100;
        }
        return prev + 1;
      });
    }, 40); // Incrementa a cada 30ms
  }, [setCurrentPage]);

  // Animação da barra de progresso
  const progressAnimation = useSpring({
    width: `${progress}%`,
    config: { duration: 300 },
  });

  return (
    <S.Container facType={user.fac_type as any}>
      <S.Filter>
        <S.BtnLogin>
          <S.WrapLogo>
            <S.Logo src={logos[user.fac_type as "fac" | "job"]} />
          </S.WrapLogo>
          <S.Title>
            New Valley - <b>{user.fac}</b>
          </S.Title>

          {/* Barra de loading animada */}
          <S.ProgressBarWrapper>
            <animated.div style={progressAnimation} />
          </S.ProgressBarWrapper>
        </S.BtnLogin>
      </S.Filter>
    </S.Container>
  );
};

export default Login;
