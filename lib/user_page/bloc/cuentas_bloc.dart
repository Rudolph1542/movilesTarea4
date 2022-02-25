import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'cuentas_event.dart';
part 'cuentas_state.dart';

class CuentasBloc extends Bloc<CuentasEvent, CuentasState> {
  CuentasBloc() : super(CuentasInitial()) {
    on<CuentasEvent>(Cuentass);
  }
  final String url =
      'https://api.sheety.co/605858022764815db6b56e85137e763f/hc1/hoja1';

  void Cuentass(CuentasEvent event, Emitter emitter) async {
    var MapaCuenta = await getCuentass();
    if (MapaCuenta == null) {
      emitter(CuentasErrorState(errorMsg: "Error"));
    } else {
      emitter(CuentasReady(mapaCuenta: MapaCuenta));
    }
  }

  Future getCuentass() async {
    try {
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == HttpStatus.ok) return jsonDecode(res.body);
    } catch (e) {
      print(e);
    }
  }
}
