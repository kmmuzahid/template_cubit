import 'package:flutter/material.dart';
import 'package:graft/graft.dart';

// =============================================================================
// 1. STATE DEFINITION (Clean, zero-boilerplate domain model with GraftState)
// =============================================================================

class UserState extends GraftState {
  String name;
  String email;
  bool isVerified;
  int notificationCount;

  UserState({
    this.name = 'Alice Johnson',
    this.email = 'alice@example.com',
    this.isVerified = true,
    this.notificationCount = 3,
  });
}

// =============================================================================
// 2. GRAFT (Business Logic & State Transitions with direct cascade updates)
// =============================================================================

class UserGraft extends Graft<UserState> {
  UserGraft() : super(UserState());

  void updateName(String newName) {
    state
      ..name = newName
      ..update();
  }

  void updateEmail(String newEmail) {
    state
      ..email = newEmail
      ..update();
  }

  void toggleVerified() {
    state
      ..isVerified = !state.isVerified
      ..update();
  }

  void incrementNotifications() {
    state
      ..notificationCount += 1
      ..update();
  }

  /// Batched Multi-Property Update:
  /// Updates name, email, verification, and notification count simultaneously
  /// in a single statement. Triggers exactly ONE diff pass with zero intermediate rebuild glitches.
  void batchUpdateProfile({
    required String name,
    required String email,
    required bool isVerified,
    required int notifications,
  }) {
    state
      ..name = name
      ..email = email
      ..isVerified = isVerified
      ..notificationCount = notifications
      ..update(); // 💥 All 4 fields updated in 1 single pass!
  }
}

// =============================================================================
// 3. MAIN ENTRY POINT & APP SETUP
// =============================================================================

void main() {
  // 1. Enable colorized console dev logging:
  Graft.observer = GraftDevObserver();

  // 2. Register Graft factory in DI:
  GraftRegistry.register(UserGraft.new);

  runApp(const GraftExampleApp());
}

class GraftExampleApp extends StatelessWidget {
  const GraftExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graft State Management Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      // 3. Attach navigator observer for route stack inheritance & auto-disposal:
      navigatorObservers: [GraftRouteObserver()],
      home: const HomeScreen(),
    );
  }
}

// =============================================================================
// 4. SCREEN 1: HOME SCREEN (First Initializer & Owner)
// =============================================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Looks in route stack; if not found, creates new instance & owns it:
    final graft = context.use<UserGraft>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Graft Showcase 🌱'),
        actions: [
          // Select only notifications count:
          graft.select(
            (s) => s.notificationCount,
            (count) => IconButton(
              icon: Badge(
                label: Text('$count'),
                child: const Icon(Icons.notifications),
              ),
              onPressed: () => graft.incrementNotifications(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =================================================================
            // Multi-Child Slot Diffing: graft.column
            // =================================================================
            const _SectionHeader(
              title: '1. Multi-Child Slot Diffing (graft.column)',
              subtitle: 'Only changed slots rebuild! Const widgets have 0 rebuilds.',
            ),
            const SizedBox(height: 8),

            graft.column((s) => [
              // Const widget: Flutter skips re-rendering entirely (0 rebuilds)
              const Card(
                color: Colors.deepPurple,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    '⚡ Const Header Banner (0 rebuilds)',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Slot 1: Name
              ListTile(
                leading: const Icon(Icons.person, color: Colors.deepPurple),
                title: Text('Name: ${s.name}'),
                subtitle: const Text('Rebuilds ONLY when name changes'),
              ),

              // Slot 2: Email
              ListTile(
                leading: const Icon(Icons.email, color: Colors.deepPurple),
                title: Text('Email: ${s.email}'),
                subtitle: const Text('0 rebuilds if email is unchanged'),
              ),

              // Slot 3: Conditional Badge
              if (s.isVerified)
                const Chip(
                  avatar: Icon(Icons.verified, color: Colors.green),
                  label: Text('Verified User Account'),
                ),
            ]),

            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Change Name'),
                  onPressed: () => graft.updateName(
                    graft.state.name == 'Alice Johnson'
                        ? 'Bob Smith'
                        : 'Alice Johnson',
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.alternate_email),
                  label: const Text('Change Email'),
                  onPressed: () => graft.updateEmail(
                    graft.state.email == 'alice@example.com'
                        ? 'bob@example.com'
                        : 'alice@example.com',
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Toggle Verified'),
                  onPressed: () => graft.toggleVerified(),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.flash_on),
                  label: const Text('⚡ Batch Update All Fields'),
                  onPressed: () {
                    final isOriginal = graft.state.name == 'Alice Johnson';
                    graft.batchUpdateProfile(
                      name: isOriginal ? 'Dr. John Doe' : 'Alice Johnson',
                      email: isOriginal ? 'john.doe@company.org' : 'alice@example.com',
                      isVerified: !graft.state.isVerified,
                      notifications: graft.state.notificationCount + 5,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),

            // =================================================================
            // Non-List Widgets: graft.listTile & graft.card
            // =================================================================
            const _SectionHeader(
              title: '2. Non-List Slots (graft.listTile & graft.card)',
              subtitle: 'Each slot diffs independently without whole-widget rebuilds.',
            ),
            const SizedBox(height: 8),

            graft.listTile(
              leading: (s) => CircleAvatar(
                backgroundColor: s.isVerified ? Colors.green : Colors.grey,
                child: Text(s.name.isNotEmpty ? s.name[0] : '?'),
              ),
              title: (s) => Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: (s) => Text(s.email),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),

            const SizedBox(height: 8),

            graft.card(
              color: Colors.deepPurple.shade50,
              child: (s) => Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Card slot diffed: ${s.name} (${s.isVerified ? "Verified" : "Unverified"})',
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(),

            // =================================================================
            // Route-Stack Sharing & Lifecycle
            // =================================================================
            const _SectionHeader(
              title: '3. Route-Stack Lifecycle & Inheritance',
              subtitle: 'Pushed screens borrow the active Graft. Disposed when owner pops.',
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Push Edit Screen (Borrows Current Graft)'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Push Isolated Screen (context.create)'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const IsolatedProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// 5. SCREEN 2: EDIT PROFILE SCREEN (Borrows Instance from Route Stack)
// =============================================================================

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Automatically reuses the exact same UserGraft created by HomeScreen!
    final graft = context.use<UserGraft>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrower Screen 🔄'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: graft.column((s) => [
          const Text(
            'This screen called context.use<UserGraft>() and borrowed the existing instance from HomeScreen.',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Name: ${s.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Current Email: ${s.email}'),
                  const SizedBox(height: 4),
                  Text('Status: ${s.isVerified ? "Verified" : "Unverified"}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              graft.updateName('Edited by Second Screen!');
              Navigator.of(context).pop();
            },
            child: const Text('Update Name & Pop Back to Home'),
          ),
        ]),
      ),
    );
  }
}

// =============================================================================
// 6. SCREEN 3: ISOLATED SCREEN (Forces New Instance via context.create)
// =============================================================================

class IsolatedProfileScreen extends StatelessWidget {
  const IsolatedProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Forces a brand new UserGraft owned specifically by this route:
    final graft = context.create<UserGraft>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolated Screen 🛡️'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: graft.column((s) => [
          const Text(
            'This screen used context.create<UserGraft>() to create a completely independent instance.',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 16),
          Text('Independent Name: ${s.name}'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => graft.updateName('Isolated Change'),
            child: const Text('Change (Does NOT Affect Home)'),
          ),
        ]),
      ),
    );
  }
}

// =============================================================================
// HELPER WIDGETS
// =============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
