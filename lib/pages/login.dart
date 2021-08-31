import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instagram/config/config.dart';
import 'package:instagram/pages/home.dart';
import 'package:instagram/query-mute/file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static TextEditingController username = TextEditingController();
  static TextEditingController password = TextEditingController();
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  bool isLoading = false;
  QueryMutation login = QueryMutation();

  String getUsers = """
  query getUsers{
      getUsers{
        username
      }
    }
""";

  sendData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading = true;
    });
    if (username.text.isEmpty || password.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Material Dialog'),
              content: Text('this one cannot be empty'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close')),
              ],
            );
          });
      setState(() {
        isLoading = false;
      });
    } else {
      GraphQLClient _client = graphQLConfiguration.clientToQuery();
      QueryResult result = await _client.mutate(
        MutationOptions(
          document: gql(login.login(username.text, password.text))
          //document: login.login(username.text, password.text)
        ),
      );
      if(result.data != null){
        String token = result.data['login']['token'];
        prefs.setString('token', token);
        username.clear();
        password.clear();
        print('Your token is: $token');
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => Home()));
      }else{
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Exception'),
              content: Text(result.exception.graphqlErrors.first.message),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close')),
              ],
            );
          });
          setState(() {
            isLoading = false;
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                alignment: Alignment.center,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: username,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'username',
                      hintText: 'Enter Your Name'),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                alignment: Alignment.center,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: password,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Password',
                      hintText: 'Enter Your Password'),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    alignment: Alignment.center,
                    child: TextButton(
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text('login',
                              style: TextStyle(color: Colors.white)),
                      onPressed: () => sendData(),
                    )),
              )
            ],
          ),
        ));
  }
}
