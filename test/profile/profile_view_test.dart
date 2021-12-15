import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_recipe_viewer/data/profile.dart';
import 'package:medical_recipe_viewer/profile/profile_view.dart';

Profile profile = Profile(
    id:"id",
    name: "name",
    lastName: "lastName"
);

Widget createProfileViewScreen() =>
    MaterialApp(
        home: ProfileView(profile)
    );

void main() {
  group('terapeutas list test', () {

    // BEGINNING OF NEW CONTENT
    testWidgets(
        'Testing ProfileView structure',
            (tester) async {
          await tester.pumpWidget(createProfileViewScreen());
          await tester.pumpAndSettle();
          expect(find.byType(Column), findsNWidgets(2));
          expect(find.byType(Text), findsNWidgets(4));
          expect(find.byType(Image), findsNWidgets(2));
          expect(find.byType(Icon), findsNWidgets(1));
          expect(find.byType(Row), findsNWidgets(2));
        }
    );
    
  });
}

