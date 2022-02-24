import 'dart:io';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/user_page/bloc/cuentas_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import 'bloc/picture_bloc.dart';
import 'circular_button.dart';
import 'cuenta_item.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScreenshotController contrScreenshot = ScreenshotController();

  void sharescreenshot() async {
    final uint8List = await contrScreenshot.capture();
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/image.png');
    await file.writeAsBytes(uint8List);
    await Share.shareFiles([file.path]);
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: contrScreenshot,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            DescribedFeatureOverlay(
              featureId: 'featurecompartir',
              tapTarget: Icon(Icons.share),
              title: Text(
                'Compartir Screenshot',
                style: TextStyle(color: Colors.white),
              ),
              //contentLocation: ContentLocation.below,
              child: IconButton(
                tooltip: 'Compartir pantalla',
                onPressed: () {
                  // TODO
                  sharescreenshot();
                },
                icon: Icon(Icons.share),
              ),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BlocConsumer<PictureBloc, PictureState>(
                listener: (context, state) {
                  if (state is PictureErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${state.errorMsg}")),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is PictureSelectedState) {
                    return CircleAvatar(
                      backgroundImage: FileImage(state.picture),
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  } else {
                    return CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 122, 113, 113),
                      minRadius: 40,
                      maxRadius: 80,
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              Text(
                "Bienvenido",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.black),
              ),
              SizedBox(height: 8),
              Text("Usuario${UniqueKey()}"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DescribedFeatureOverlay(
                    featureId: 'featuretarjeta',
                    tapTarget: Icon(Icons.camera_alt),
                    title: Text(
                      'Tarjeta de crédito o débito',
                      style: TextStyle(color: Color(0xff123b5e)),
                    ),
                    targetColor: Color(0xff123b5e),
                    child: CircularButton(
                      textAction: 'Ver tarjeta',
                      iconData: Icons.credit_card,
                      bgColor: Color(0xff123b5e),
                      action: null,
                    ),
                  ),
                  DescribedFeatureOverlay(
                    featureId: 'featurefoto',
                    tapTarget: Icon(Icons.camera_alt),
                    title: Text(
                      'Cambiar foto de perfil',
                      style: TextStyle(color: Colors.orange),
                    ),
                    targetColor: Colors.orange,
                    child: CircularButton(
                      textAction: 'Cambiar foto',
                      iconData: Icons.camera_alt,
                      bgColor: Colors.orange,
                      action: () {
                        BlocProvider.of<PictureBloc>(context).add(
                          ChangeImageEvent(),
                        );
                      },
                    ),
                  ),
                  DescribedFeatureOverlay(
                    featureId: 'featuretutorial',
                    tapTarget: Icon(Icons.play_arrow),
                    title: Text(
                      'Ver tutorial de uso',
                      style: TextStyle(color: Colors.green),
                    ),
                    targetColor: Colors.green,
                    child: CircularButton(
                      textAction: 'Ver tutorial',
                      iconData: Icons.play_arrow,
                      bgColor: Colors.green,
                      action: () {
                        FeatureDiscovery.discoverFeatures(context, <String>{
                          'featuretarjeta',
                          'featurefoto',
                          'featuretutorial',
                          'featurecompartir'
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 48),
              BlocConsumer<CuentasBloc, CuentasState>(
                  builder: (context, state) {
                    if (state is CuentasReady) {
                      return Expanded(
                          child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return CuentaItem(
                            tipoCuenta: state.mapaCuenta['cuentas'][index]
                                    ['cuenta']
                                .toString(),
                            terminacion: state.mapaCuenta['cuentas'][index]
                                    ['tarjeta']
                                .toString()
                                .substring(5),
                            saldoDisponible: state.mapaCuenta['cuentas'][index]
                                    ['dinero']
                                .toString(),
                          );
                        },
                        itemCount: (state.mapaCuenta["cuentas"] as List).length,
                      ));
                    } else if (state is CuentasErrorState) {
                      return Text("No hay datos disponibles");
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                  listener: (context, state) {})
            ],
          ),
        ),
      ),
    );
  }
}
