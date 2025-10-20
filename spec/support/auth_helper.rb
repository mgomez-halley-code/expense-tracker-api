module AuthHelpers
  def auth_headers_for(user)
    post api_v1_login_path, params: { user: { email: user.email, password: user.password } }
    { 'Authorization' => response.headers['Authorization'] }
  end
  
  def json_response
    JSON.parse(response.body)
  end
end
