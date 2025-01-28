import '@fontsource-variable/lexend';



export const theme = {
  fontFamily: "'Lexend Variable', sans-serif",
  colors: {
    primary: "#fff",
    primary_opacity: (opacity: number = 1) => `rgba(255, 255, 255, ${opacity})`,
    secondary: "#151c33",
    tablet: {},
  },
};
