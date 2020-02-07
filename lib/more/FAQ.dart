import 'package:flutter/material.dart';
import 'package:go_luggage_free/more/ContactUs.dart';
import 'package:go_luggage_free/more/Question.dart';
import 'package:go_luggage_free/shared/utils/Constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class FAQ extends StatelessWidget {
  String faqQuery = """"
    query {
      faqQuestions {
        question,
        answer
      }
    }
  """;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ", style: Theme.of(context).textTheme.title,),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed:() => Navigator.pop(context, false)
        ),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 8.0),
              child: Center(
                  child: Text("Need Help?", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black),)
              )
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              child: Center(child: Text("Contact Us", style: Theme.of(context).textTheme.body1.copyWith(color: Colors.blue[900]),)),
              onTap: () async {
                /* print("Entered onTap");
                String phoneNumber = "+917854866007";
                String url = "whatsapp://send?phone=$phoneNumber";
                await canLaunch(url) ? launch(url) : launch("tel://$phoneNumber"); */
                // await FlutterLaunch.launchWathsApp(phone: "8369276419", message: "");
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUs(), settings: RouteSettings(name: "Contact Us Page")));
              },
            ),
          )
        ],
      ),
      body: Query(
        options: QueryOptions(
          document: faqQuery
        ),
        builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
          if(result.errors != null) {
            print("Error in Fetching Faq = ${result.errors}");
            return Center(child: Text("An Error Occoured. Please try later"),);
          }
          if(result.loading) {
            print("Loading FAQ's data");
            return Center(child: CircularProgressIndicator(),);
          }
          print("Result for faq = ${result.data.toString()}");
          List<dynamic> faqs = result.data["faqQuestions"];
          List<Question> questions = [];
          faqs.forEach((faq) {
            questions.add(Question.fromMap(faq));
          });
          if(questions.isEmpty) {
            return Center(child: Text("No FAQ Questions yet. Try again later"),);
          }
          return Container(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text(questions[index].question, style: Theme.of(context).textTheme.headline),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text(questions[index].answer, style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black),),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}