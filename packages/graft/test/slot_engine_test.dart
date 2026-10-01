import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graft/graft.dart';

class ProfileState extends Equatable {
  final String name;
  final String email;
  final bool isVerified;
  final bool isLoading;

  const ProfileState({
    this.name = 'Alice',
    this.email = 'alice@example.com',
    this.isVerified = false,
    this.isLoading = false,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    bool? isVerified,
    bool? isLoading,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [name, email, isVerified, isLoading];
}

class ProfileGraft extends Graft<ProfileState> {
  ProfileGraft() : super(const ProfileState());

  void updateName(String newName) => emit(state.copyWith(name: newName));
  void updateEmail(String newEmail) => emit(state.copyWith(email: newEmail));
  void toggleVerified() => emit(state.copyWith(isVerified: !state.isVerified));
  void setLoading(bool loading) => emit(state.copyWith(isLoading: loading));
}

class ConstHeaderWidget extends StatelessWidget {
  static int buildCount = 0;
  const ConstHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    buildCount++;
    return const Text('Const Header');
  }
}

class DynamicNameWidget extends StatelessWidget implements GraftEquivalent {
  static int buildCount = 0;
  final String name;
  const DynamicNameWidget(this.name, {super.key});

  @override
  bool isEquivalentTo(Widget other) =>
      other is DynamicNameWidget && name == other.name;

  @override
  Widget build(BuildContext context) {
    buildCount++;
    return Text('Name: $name');
  }
}

class DynamicEmailWidget extends StatelessWidget implements GraftEquivalent {
  static int buildCount = 0;
  final String email;
  const DynamicEmailWidget(this.email, {super.key});

  @override
  bool isEquivalentTo(Widget other) =>
      other is DynamicEmailWidget && email == other.email;

  @override
  Widget build(BuildContext context) {
    buildCount++;
    return Text('Email: $email');
  }
}

void main() {
  setUp(() {
    ConstHeaderWidget.buildCount = 0;
    DynamicNameWidget.buildCount = 0;
    DynamicEmailWidget.buildCount = 0;
  });

  testWidgets('graft.column diffs slots and rebuilds ONLY the changed slot',
      (tester) async {
    final graft = ProfileGraft();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: graft.column(
            (s) => [
              const ConstHeaderWidget(),
              DynamicNameWidget(s.name),
              DynamicEmailWidget(s.email),
            ],
          ),
        ),
      ),
    );

    // Initial render: every slot built once
    expect(ConstHeaderWidget.buildCount, 1);
    expect(DynamicNameWidget.buildCount, 1);
    expect(DynamicEmailWidget.buildCount, 1);
    expect(find.text('Const Header'), findsOneWidget);
    expect(find.text('Name: Alice'), findsOneWidget);
    expect(find.text('Email: alice@example.com'), findsOneWidget);

    // 1. Update ONLY the name
    graft.updateName('Bob');
    await tester.pump();

    // Verify: ONLY DynamicNameWidget rebuilt! Const header and email had 0 rebuilds!
    expect(ConstHeaderWidget.buildCount, 1,
        reason: 'Const widget should have 0 extra rebuilds');
    expect(DynamicNameWidget.buildCount, 2,
        reason: 'Changed slot should have rebuilt once');
    expect(DynamicEmailWidget.buildCount, 1,
        reason: 'Unchanged slot should have 0 extra rebuilds');
    expect(find.text('Name: Bob'), findsOneWidget);

    // 2. Update ONLY the email
    graft.updateEmail('bob@example.com');
    await tester.pump();

    // Verify: ONLY DynamicEmailWidget rebuilt! Const header and name had 0 rebuilds!
    expect(ConstHeaderWidget.buildCount, 1,
        reason: 'Const widget should have 0 extra rebuilds');
    expect(DynamicNameWidget.buildCount, 2,
        reason: 'Unchanged slot should have 0 extra rebuilds');
    expect(DynamicEmailWidget.buildCount, 2,
        reason: 'Changed slot should have rebuilt once');
    expect(find.text('Email: bob@example.com'), findsOneWidget);

    graft.dispose();
  });

  testWidgets('graft.column handles direct Text widgets with content diffing',
      (tester) async {
    final graft = ProfileGraft();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: graft.column(
            (s) => [
              const Text('Static Banner'),
              Text('Hello ${s.name}'),
              Text('Contact: ${s.email}'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Static Banner'), findsOneWidget);
    expect(find.text('Hello Alice'), findsOneWidget);
    expect(find.text('Contact: alice@example.com'), findsOneWidget);

    // Update name
    graft.updateName('Charlie');
    await tester.pump();

    expect(find.text('Hello Charlie'), findsOneWidget);
    expect(find.text('Contact: alice@example.com'), findsOneWidget);

    graft.dispose();
  });

  testWidgets(
      'graft.listTile isolates slots and only rebuilds the changed slot',
      (tester) async {
    final graft = ProfileGraft();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: graft.listTile(
            leading: (s) => DynamicNameWidget(s.name),
            title: (s) => DynamicEmailWidget(s.email),
            trailing: const ConstHeaderWidget(),
          ),
        ),
      ),
    );

    expect(ConstHeaderWidget.buildCount, 1);
    expect(DynamicNameWidget.buildCount, 1);
    expect(DynamicEmailWidget.buildCount, 1);

    // Update ONLY name
    graft.updateName('Zoe');
    await tester.pump();

    // Only leading (name) rebuilt! title and trailing had 0 extra rebuilds!
    expect(ConstHeaderWidget.buildCount, 1,
        reason: 'Trailing const widget should have 0 extra rebuilds');
    expect(DynamicNameWidget.buildCount, 2,
        reason: 'Leading slot should have rebuilt once');
    expect(DynamicEmailWidget.buildCount, 1,
        reason: 'Title slot should have 0 extra rebuilds');

    // Update ONLY email
    graft.updateEmail('zoe@example.com');
    await tester.pump();

    // Only title (email) rebuilt! leading and trailing had 0 extra rebuilds!
    expect(ConstHeaderWidget.buildCount, 1,
        reason: 'Trailing const widget should have 0 extra rebuilds');
    expect(DynamicNameWidget.buildCount, 2,
        reason: 'Leading slot should have 0 extra rebuilds');
    expect(DynamicEmailWidget.buildCount, 2,
        reason: 'Title slot should have rebuilt once');

    graft.dispose();
  });

  testWidgets('graft.column gracefully handles conditional list resizing',
      (tester) async {
    final graft = ProfileGraft();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: graft.column(
            (s) => [
              Text('Name: ${s.name}'),
              if (s.isVerified) const Text('Verified Badge'),
              Text('Email: ${s.email}'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Name: Alice'), findsOneWidget);
    expect(find.text('Verified Badge'), findsNothing);
    expect(find.text('Email: alice@example.com'), findsOneWidget);

    // Mount conditional widget (list size 2 -> 3)
    graft.toggleVerified();
    await tester.pump();

    expect(find.text('Verified Badge'), findsOneWidget);

    // Update a property while expanded
    graft.updateName('Bob');
    await tester.pump();

    expect(find.text('Name: Bob'), findsOneWidget);
    expect(find.text('Verified Badge'), findsOneWidget);

    // Unmount conditional widget (list size 3 -> 2)
    graft.toggleVerified();
    await tester.pump();

    expect(find.text('Verified Badge'), findsNothing);
    expect(find.text('Name: Bob'), findsOneWidget);

    graft.dispose();
  });

  testWidgets(
      'graft.select only rebuilds when the selected slice changes, ignoring unrelated field changes',
      (tester) async {
    final graft = ProfileGraft();
    int selectorBuilds = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: graft.select(
            (s) => s.isVerified,
            (isVerified) {
              selectorBuilds++;
              return Text(isVerified ? 'VERIFIED' : 'NOT VERIFIED');
            },
          ),
        ),
      ),
    );

    expect(selectorBuilds, 1);
    expect(find.text('NOT VERIFIED'), findsOneWidget);

    // 1. Update UNRELATED fields (name and email)
    graft.updateName('Dan');
    await tester.pump();
    graft.updateEmail('dan@example.com');
    await tester.pump();

    // Selector MUST have 0 extra rebuilds!
    expect(selectorBuilds, 1,
        reason: 'Selector should ignore changes to name and email');

    // 2. Update SELECTED field (isVerified)
    graft.toggleVerified();
    await tester.pump();

    expect(selectorBuilds, 2, reason: 'Selector must rebuild when selected slice changes');
    expect(find.text('VERIFIED'), findsOneWidget);

    graft.dispose();
  });

  testWidgets('graft.layout switches seamlessly between loading and content states',
      (tester) async {
    final graft = ProfileGraft();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: graft.layout((context, state) {
            if (state.isLoading) {
              return const Text('Loading...');
            }
            return Text('Content for ${state.name}');
          }),
        ),
      ),
    );

    expect(find.text('Content for Alice'), findsOneWidget);
    expect(find.text('Loading...'), findsNothing);

    // Switch to Loading
    graft.setLoading(true);
    await tester.pump();

    expect(find.text('Loading...'), findsOneWidget);
    expect(find.text('Content for Alice'), findsNothing);

    // Switch back to Content with new name
    graft.updateName('Elena');
    graft.setLoading(false);
    await tester.pump();

    expect(find.text('Content for Elena'), findsOneWidget);
    expect(find.text('Loading...'), findsNothing);

    graft.dispose();
  });
}
