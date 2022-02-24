part of 'cuentas_bloc.dart';

abstract class CuentasState extends Equatable {
  const CuentasState();

  @override
  List<Object> get props => [];
}

class CuentasInitial extends CuentasState {}

class CuentasErrorState extends CuentasState {
  String errorMsg;

  CuentasErrorState({this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class CuentasReady extends CuentasState {
  final Map mapaCuenta;

  CuentasReady({this.mapaCuenta});

  @override
  List<Object> get props => [];
}
