import React, { useCallback, useEffect, useMemo, useRef, useState } from "react";
import styled, { css, keyframes } from "styled-components";
import useInteractions from "../../hooks/useInteractions";
import useRequest from "../../hooks/useRequest";
import * as S from "./styles";
import { BiChevronLeft } from "react-icons/bi";
import { AiFillStar, AiOutlineStar, AiOutlineLoading } from "react-icons/ai";
import { CiWallet } from "react-icons/ci";

const Dynamic = () => {
  const searchRef = useRef();
  const {
    search,
    setSearch,
    category,
    setCategory,
    interactions,
    handleClickInteraction,
    isFavorite,
  } = useInteractions();

  const { request } = useRequest();
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    searchRef.current.focus();
    setLoading(false); // Supondo que você deseja definir o carregamento como false após o componente ser montado.
  }, []);

  const filteredInteractions = useMemo(() => {
    if (search) {
      return interactions.filter((item) =>
        item.title.toLowerCase().includes(search.toLowerCase())
      );
    }

    const currentCategory =
      category.length > 0 ? category[category.length - 1] : "main";
    return interactions.filter((item) =>
      item.category.includes(currentCategory)
    );
  }, [interactions, search, category]);

  const handleBackButton = useCallback(() => {
    setCategory((prev) => {
      const newCategory = [...prev];
      newCategory.pop();
      return newCategory;
    });
  }, []);

  const handleToggleFavorite = (action, value) => {
    const actionStr = value ? `${action}:${value}` : action;

    if (isFavorite(action, value)) {
      request("deleteFavorite", { action: actionStr });
    } else {
      request("setFavorite", { action: actionStr });
    }
  };

  const openWebsite = () => {
    window.open("https://newvalley.online", "_blank");
  };

  // Função para chamar o callback NUI 'openIdentity'
  const handleOpenIdentity = () => {
    request("openIdentity");
  };


  const StyledImage = styled.img`
  width: 4rem;
  height: auto; 
`;

  return (
    <S.MobileFrame>
      <S.Container>
        <S.Title>
          <StyledImage onClick={openWebsite} src="https://host-two-ochre.vercel.app/files/valley_sem_fundo.png" alt="b" />
        </S.Title>
        <S.Header>
          {category.length > 1 && (
            <S.BackButton onClick={handleBackButton}>
              <BiChevronLeft />
            </S.BackButton>
          )}
          <S.Search
            ref={searchRef}
            placeholder="Pesquisar por..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
          {/* Botão de pessoa no canto superior direito */}
          <S.IdentityButton onClick={handleOpenIdentity}>
            <CiWallet />
          </S.IdentityButton>
        </S.Header>
        <S.ActionList>
          {loading && (
            <S.Loading>
              <AiOutlineLoading /> <small>Carregando...</small>
            </S.Loading>
          )}
          {!loading && (
            <>
              {filteredInteractions.length > 0 ? (
                <>
                  {filteredInteractions.map((interaction) => (
                    <S.Item key={interaction.title}>
                      <S.ItemDescription
                        onClick={() => handleClickInteraction(interaction)}
                      >
                        {interaction.icon}
                        {interaction.title}
                      </S.ItemDescription>
                      {interaction.type !== "category" && (
                        <S.FavButton
                          onClick={() =>
                            handleToggleFavorite(
                              interaction.action,
                              interaction.value
                            )
                          }
                        >
                          {isFavorite(interaction.action, interaction.value) ? (
                            <AiFillStar />
                          ) : (
                            <AiOutlineStar />
                          )}
                        </S.FavButton>
                      )}
                    </S.Item>
                  ))}
                </>
              ) : (
                <S.EmptyFeedback>Nada foi encontrado!</S.EmptyFeedback>
              )}
            </>
          )}
        </S.ActionList>
      </S.Container>
    </S.MobileFrame>
  );
};

export default React.memo(Dynamic);
