import 'package:flutter/material.dart';
import '../models/servicio_model.dart';
import '../providers/servicio_provider.dart';

class NuevoVEN_Servicio extends StatefulWidget {
  String titulo;
  Servicio oServicio = Servicio();
  final _provider = VEN_ServicioProvider();
  int codigoVEN_ServicioSeleccionado = 0;
  String mensaje = "";
  bool validacion = false;
  NuevoVEN_Servicio(this.titulo, this.codigoVEN_ServicioSeleccionado, {Key? key}) : super(key: key);
  @override
  _NuevoVEN_Servicio createState() => _NuevoVEN_Servicio();
}

class _NuevoVEN_Servicio extends State<NuevoVEN_Servicio> {
  final _tfCodigoCliente = TextEditingController();
  final _tfRazonSocial = TextEditingController();
  final _tfRuc = TextEditingController();
  final _tfDireccion = TextEditingController();
  final _tfContacto = TextEditingController();
  final _tfTelefono = TextEditingController();
  final _tfAnexo = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.oServicio.inicializar();
    if (widget.codigoVEN_ServicioSeleccionado > 0) {
      _listarKeyProvider();
    }
  }

  Future<String> _listarKeyProvider() async {
    Servicio oServicioModel = Servicio();
    oServicioModel.inicializar();
    var oServicioModeltmp =
        await widget._provider.listarKey(widget.codigoVEN_ServicioSeleccionado);

    // ignore: avoid_print
    print(oServicioModeltmp);
    setState(() {
      widget.oServicio = oServicioModeltmp;
      if (widget.oServicio.codigoServicio! > 0) {
        widget.mensaje = "Estas actualizando los datos";
        _mostrarDatos();
      }
    });
    return "Procesado";
  }

  void _mostrarDatos() {
    _tfCodigoCliente.text = widget.oServicio.codigoServicio.toString();
    _tfRazonSocial.text = widget.oServicio.nombreCliente.toString();
    _tfRuc.text = widget.oServicio.numeroOrdenServicio.toString();
    _tfDireccion.text = widget.oServicio.fechaProgramada.toString();
    _tfContacto.text = widget.oServicio.linea.toString();
    _tfTelefono.text = widget.oServicio.estado.toString();
    _tfAnexo.text = widget.oServicio.observaciones .toString();
  }

  void _cargarEntidad() {
    widget.oServicio.codigoServicio = int.parse(_tfCodigoCliente.text);
    widget.oServicio.nombreCliente = _tfRazonSocial.text;
    widget.oServicio.numeroOrdenServicio = _tfRuc.text;
    widget.oServicio.fechaProgramada = _tfDireccion.text;
    widget.oServicio.linea = _tfContacto.text;
    widget.oServicio.estado = _tfTelefono.text;
    widget.oServicio.observaciones = _tfAnexo.text;
  }

  bool _validarRegistro() {
    if (_tfCodigoCliente.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar codigoServicio ";
      });
      return false;
    }
    if (_tfRazonSocial.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar nombreCliente ";
      });
      return false;
    }
    if (_tfRuc.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar numeroOrdenServicio ";
      });
      return false;
    }
    if (_tfDireccion.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar fechaProgramada ";
      });
      return false;
    }
    if (_tfContacto.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar linea ";
      });
      return false;
    }
    if (_tfTelefono.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar estado ";
      });
      return false;
    }
    if (_tfAnexo.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar observaciones ";
      });
      return false;
    }

    return true;
  }

  void _grabarRegistro() {
    if (_validarRegistro()) {
      _ejecutar_ServicioGrabadoProvider();
    }
  }

  // ignore: non_constant_identifier_names
  Future<String> _ejecutar_ServicioGrabadoProvider() async {
    String accion = "N";
    if (widget.oServicio.codigoServicio! > 0) {
      accion = "A";
    }
    _cargarEntidad();
    Servicio oServicioModeltmp = Servicio();
    oServicioModeltmp.inicializar();
    var oServicioModeltmpReg =
        await widget._provider.registraModifica(widget.oServicio, accion);
    // ignore: avoid_print
    print(oServicioModeltmpReg);
    setState(() {
      widget.oServicio = oServicioModeltmpReg;
      if (widget.oServicio.codigoServicio! > 0) {
        widget.mensaje = "Grabado correctamente";
      }
      // ignore: avoid_print
      print(widget.oServicio);
    });
    return "Procesado";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registro de Servicios " + widget.titulo),
          actions: [
            IconButton(icon: Icon(Icons.save), onPressed: _grabarRegistro),
          ],
        ),
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(" Código de Servicio:" +
                  widget.oServicio.codigoServicio.toString()),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: <Widget>[
                  TextField(
                      controller: _tfCodigoCliente,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Codigo de Servicio ",
                        labelText: "Código Servicio",
                      )),
                  TextField(
                      controller: _tfRazonSocial,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Nombre Cliente ",
                        labelText: "Nombre de cliente",
                      )),
                  TextField(
                      controller: _tfRuc,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Numero de orden de Servicio ",
                        labelText: "N° Orden",
                      )),
                  TextField(
                      controller: _tfDireccion,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Fecha Programada ",
                        labelText: "Fecha Programada",
                      )),
                  TextField(
                      controller: _tfContacto,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Linea ",
                        labelText: "Linea",
                      )),
                  TextField(
                      controller: _tfTelefono,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Estado ",
                        labelText: "Estado",
                      )),
                  TextField(
                      controller: _tfAnexo,
                      decoration: const InputDecoration(
                        hintText: "Ingrese Observaciones ",
                        labelText: "Observaciones",
                      )),
                  Text("Mensaje:" + widget.mensaje),
                ],
              ),
            )
          ],
        ));
  }
}
