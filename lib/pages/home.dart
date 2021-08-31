import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String getUsers = """
  query getUsers{
      getUsers{
        username
      }
    }
""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          backgroundColor: Colors.yellow,
        ),
        body: Query(
          options: QueryOptions(
            documentNode: gql(getUsers),
            // variables: {
            //   'nRepositories': 50,
            // },
            //pollInterval: Duration(seconds: 10),
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return Text('Loading');
            }
            List repositories = result.data['getUsers'];

            return Container(
              alignment: Alignment.center,
              child: ListView.builder(
                  itemCount: repositories.length,
                  itemBuilder: (context, index) {
                    final repository = repositories[index];

                    return Text(repository['username']);
                  }),
            );
          },
        ));
  }
}
