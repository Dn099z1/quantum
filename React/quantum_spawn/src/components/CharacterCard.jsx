import { FaLock } from "react-icons/fa";
import { Avatar } from "../styles";
import { Card, CardContent, ContentWrapper, Job, Name } from "../styles";
import { LockedIcon, LockedText } from "../styles";

const CharacterCard = ({
  name,
  identifier,
  avatar,
  onClick,
  isLocked,
  job,
}) => {
  return (
    <Card onClick={!isLocked ? onClick : null} locked={isLocked}>
      <CardContent>
        {isLocked ? (
          <>
            <LockedIcon>
              <FaLock />
            </LockedIcon>
            <ContentWrapper>
              <LockedText>Slot Bloqueado</LockedText>
            </ContentWrapper>
          </>
        ) : (
          <>
            <Avatar 
              src={avatar || "https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=100&h=100&fit=crop"} 
              alt={name} 
            />
            <ContentWrapper>
              <Job>{job || "Desempregado"}</Job>
              <Name>
                {name} <span>#{identifier}</span>
              </Name>
            </ContentWrapper>
          </>
        )}
      </CardContent>
    </Card>
  );
};

export default CharacterCard;
