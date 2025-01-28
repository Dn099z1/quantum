function useRequest() {
  const request = async (method, body = {}) => {
    return fetch(`http://quantum_dynamic/${method}`, {
      method: "POST",
      body: JSON.stringify(body),
    });
  };

  return {
    request,
  };
}

export default useRequest;
