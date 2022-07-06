export default fetchApi = async (method, url) => {
    let response = fetch(`localhost:8000/${url}`, {
        method,
    })
    let parsed = await response.json();

    return parsed;
}