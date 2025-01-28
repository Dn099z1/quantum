import * as S from "./styles";
import { FaHeart, FaWineGlass, FaHamburger, FaShieldAlt, FaLungs } from "react-icons/fa";

function calculateOffset(value, radius) {
  const circumference = 2 * Math.PI * radius;
  return circumference - (value / 100) * circumference;
}

function createHexagonPath(radius, offset) {
  const angle = Math.PI / 3; // 60° para cada lado
  const points = Array.from({ length: 6 }).map((_, i) => {
    const x = Math.cos(angle * i) * radius + offset;
    const y = Math.sin(angle * i) * radius + offset;
    return `${x},${y}`;
  });
  return `M${points.join("L")}Z`; // Cria o caminho fechado
}

function PlayerStatus({ data }) {
  const radius = 55; // Raio do hexágono interno
  const offset = 59; // Centraliza o hexágono
  const strokeWidth = 12.2;

  return (
    <S.Wrap>
      {/* Status de Saúde */}
      <S.Status>
        <S.SvgWrapper>
          <S.PathBackground d={createHexagonPath(radius, offset)} strokeWidth={strokeWidth} />
          <S.PathForeground
            d={createHexagonPath(radius, offset)}
            strokeWidth={strokeWidth}
            strokeDasharray={2 * Math.PI * radius}
            strokeDashoffset={calculateOffset(data.health, radius)}
            color="#f0072e" // Cor do status de saúde (vermelho)
          />
        </S.SvgWrapper>
        <FaHeart />
      </S.Status>

      {/* Status de Armadura */}
      <S.Status>
        <S.SvgWrapper>
          <S.PathBackground d={createHexagonPath(radius, offset)} strokeWidth={strokeWidth} />
          <S.PathForeground
            d={createHexagonPath(radius, offset)}
            strokeWidth={strokeWidth}
            strokeDasharray={2 * Math.PI * radius}
            strokeDashoffset={calculateOffset(data.armour, radius)}
            color="#6d1f8c" // Cor do status de armadura (roxo)
          />
        </S.SvgWrapper>
        <FaShieldAlt />
      </S.Status>

      {/* Status de Fome */}
      <S.Status>
        <S.SvgWrapper>
          <S.PathBackground d={createHexagonPath(radius, offset)} strokeWidth={strokeWidth} />
          <S.PathForeground
            d={createHexagonPath(radius, offset)}
            strokeWidth={strokeWidth}
            strokeDasharray={2 * Math.PI * radius}
            strokeDashoffset={calculateOffset(100 - data.hunger, radius)}
            color="#c79e1a" // Cor do status de fome (amarelo)
          />
        </S.SvgWrapper>
        <FaHamburger />
      </S.Status>

      {/* Status de Sede */}
      <S.Status>
        <S.SvgWrapper>
          <S.PathBackground d={createHexagonPath(radius, offset)} strokeWidth={strokeWidth} />
          <S.PathForeground
            d={createHexagonPath(radius, offset)}
            strokeWidth={strokeWidth}
            strokeDasharray={2 * Math.PI * radius}
            strokeDashoffset={calculateOffset(100 - data.thirst, radius)}
            color="#1a99c7" // Cor do status de sede (azul)
          />
        </S.SvgWrapper>
        <FaWineGlass />
      </S.Status>

      {/* Status de Oxigênio */}
      {data.oxygen !== -1 && (
        <S.Status>
          <S.SvgWrapper>
            <S.PathBackground d={createHexagonPath(radius, offset)} strokeWidth={strokeWidth} />
            <S.PathForeground
              d={createHexagonPath(radius, offset)}
              strokeWidth={strokeWidth}
              strokeDasharray={2 * Math.PI * radius}
              strokeDashoffset={calculateOffset(data.oxygen, radius)}
              color="#00ffff" // Cor do status de oxigênio (ciano)
            />
          </S.SvgWrapper>
          <FaLungs />
        </S.Status>
      )}
    </S.Wrap>
  );
}

export default PlayerStatus;
