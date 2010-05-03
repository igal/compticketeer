# Return JSON parsed from the response body.
def response_json
  return JSON.parse(response.body)
end