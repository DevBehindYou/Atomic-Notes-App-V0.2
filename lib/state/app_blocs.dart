import 'package:atomic_notes/database/energy_service.dart';
import 'package:atomic_notes/database/notes_repository.dart';
import 'package:atomic_notes/database/sync_status.dart';
import 'package:atomic_notes/state/notes/notes_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Every bloc the app shares, created once above the [MaterialApp] so any screen, including the
/// ones pushed as routes, reads the same instance with `context.read` or `BlocBuilder`.
class AppBlocs extends StatelessWidget {
  const AppBlocs({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<NotesBloc>(
            create: (_) => NotesBloc(
              source: NotesRepository.instance,
              isSyncEnabled: () => SyncStatusHelper.isSyncOn,
              isOnline: _hasConnection,
              instantSyncCost: () => EnergyService.syncInstantCost,
            ),
          ),
        ],
        child: child,
      );
}

Future<bool> _hasConnection() async =>
    !(await Connectivity().checkConnectivity()).contains(ConnectivityResult.none);
