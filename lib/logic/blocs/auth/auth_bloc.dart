import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthEvent {}
class LoginWithGoogle extends AuthEvent {}
class LoginAsGuest extends AuthEvent {}

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {}
class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginWithGoogle>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthSuccess());
    });

    on<LoginAsGuest>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthSuccess());
    });
  }
}
