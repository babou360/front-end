import 'package:flutter/material.dart';
import 'package:instagram/pages/home.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:instagram/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await initHiveForFlutter();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String token = prefs.getString('token');
  //String token ="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImJhYm91IiwiaWF0IjoxNjMwMTM4NDU4LCJleHAiOjE2NjE2OTYwNTh9.8EA1AVxKZZBjQhmGQpvWOBCyMUfkeXg4YmeSQ44iKd4";

  final HttpLink httpLink = HttpLink(
    'http://192.168.43.51:4000',
  );

  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer $token',
  );

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: httpLink,
    );
  }

  var app = GraphQLProvider(client: client, child: MyApp());
  runApp(app);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:instagram/config/config.dart';
// import 'package:instagram/pages/home.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:instagram/pages/login.dart';


// GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
// void main() async{
//   await initHiveForFlutter();
//   //WidgetsFlutterBinding.ensureInitialized();
//    GraphQLProvider(
//     client: graphQLConfiguration.client,
//     child: CacheProvider(child: MyApp()),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Login(),
//     );
//   }
// }
