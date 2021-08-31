class QueryMutation {


  String login(String username, String password){
    return """
      query{
          login(username: "$username", password: "$password"){
            username
            createdAt
            token
          }
      }    
     """;
  }
}