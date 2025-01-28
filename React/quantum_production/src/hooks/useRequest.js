function useRequest() {
  const request = async (method, body = {}) => {
    return fetch(`http://quantum_production/${method}`, {
      method: "POST",
      body: JSON.stringify(body),
    });
  };

  return {
    request,
  };
}

export default useRequest;
