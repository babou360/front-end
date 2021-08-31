// import "package:flutter/material.dart";
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:graphql/client.dart';

// class GraphQLConfiguration {
//   static String token ="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImJhYm91IiwiaWF0IjoxNjMwMTM4NDU4LCJleHAiOjE2NjE2OTYwNTh9.8EA1AVxKZZBjQhmGQpvWOBCyMUfkeXg4YmeSQ44iKd4";
//   static final HttpLink httpLink = HttpLink(
//     uri: 'http://192.168.43.51:4000',
//   );

//   static final AuthLink authLink = AuthLink(
//     getToken: () async{
//       return 'Bearer $token';
//     }
//     // getToken: () async => 'Bearer $token',
//   );

//   static final Link link = authLink.concat(httpLink);

//   ValueNotifier<GraphQLClient> client = ValueNotifier(
//     GraphQLClient(
//       link: link,
//       cache: GraphQLCache(store: HiveStore()),
//     ),
//   );
// }

import "package:flutter/material.dart";
import 'package:graphql_flutter/graphql_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe

 class GraphQLConfiguration {
  static HttpLink httpLink = HttpLink(
     "http://192.168.43.51:4000",
  );

  static String token ="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImJhYm91IiwiaWF0IjoxNjMwMTM4NDU4LCJleHAiOjE2NjE2OTYwNTh9.8EA1AVxKZZBjQhmGQpvWOBCyMUfkeXg4YmeSQ44iKd4";
  static  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer $token',
  );

  static final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  // ValueNotifier<GraphQLClient> client = ValueNotifier(
  //   GraphQLClient(
  //     link: httpLink,
  //     cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
  //   ),
  // );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: link,
    );
  }
}