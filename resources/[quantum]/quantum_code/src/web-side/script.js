window.addEventListener("message", (event) => {
  const message = event.data;
  if (message.action == "OPEN_TENCODE") {
    $("#tencode").show();
  }
});

const takeCode = (number) => {
  closeNUI();
  $.post("http://quantum_code/code", JSON.stringify({ code: number }));
};

const closeNUI = () => {
  $("#tencode").hide();
  $.post("http://quantum_code/close", "[]");
};

document.onkeyup = (event) => {
  if (event.key == "Escape") {
    closeNUI();
  }
};
