import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vgv/features/connectivity/bloc/connectivity_cubit.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        if (state is ConnectivityOffline) {
          return Column(
            children: [
              Material(
                color: Colors.amber.shade700,
                child: const SafeArea(
                  bottom: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi_off, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'No internet connection',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: child),
            ],
          );
        }
        return child;
      },
    );
  }
}
