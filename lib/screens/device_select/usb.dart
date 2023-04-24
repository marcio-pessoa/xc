import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

extension IntToString on int {
  String toHex() => '0x${toRadixString(16)}';
  String toPadded([int width = 3]) => toString().padLeft(width, '0');
  String toTransport() {
    switch (this) {
      case SerialPortTransport.usb:
        return 'USB';
      case SerialPortTransport.bluetooth:
        return 'Bluetooth';
      case SerialPortTransport.native:
        return 'Native';
      default:
        return 'Unknown';
    }
  }
}

class DeviceSelectUSB extends StatefulWidget {
  const DeviceSelectUSB({super.key});

  @override
  State<DeviceSelectUSB> createState() => _DeviceSelectUSBState();
}

class _DeviceSelectUSBState extends State<DeviceSelectUSB> {
  var availablePorts = [];

  @override
  void initState() {
    super.initState();
    scanPorts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectDevice),
      ),
      body: ListView(children: _deviceList),
      floatingActionButton: FloatingActionButton(
        onPressed: scanPorts,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  List<Widget> get _deviceList {
    return [
      for (final address in availablePorts)
        Builder(builder: (context) {
          final port = SerialPort(address);
          Widget result = _expansionTitle(address, context, port);
          port.dispose();

          return result;
        }),
    ];
  }

  ExpansionTile _expansionTitle(
      address, BuildContext context, SerialPort port) {
    return ExpansionTile(
      title: Text(address),
      children: [
        CardListTile(
          name: AppLocalizations.of(context)!.description,
          value: port.description,
        ),
        // CardListTile(
        //   name: AppLocalizations.of(context)!.transport,
        //   value: port.transport.toTransport(),
        // ),
        // CardListTile(
        //   name: 'USB Bus',
        //   value: port.busNumber?.toPadded(),
        // ),
        // CardListTile(
        //   name: 'USB Device',
        //   value: port.deviceNumber?.toPadded(),
        // ),
        // CardListTile(
        //   name: 'Vendor ID',
        //   value: port.vendorId?.toHex(),
        // ),
        // CardListTile(
        //   name: 'Product ID',
        //   value: port.productId?.toHex(),
        // ),
        CardListTile(
          name: AppLocalizations.of(context)!.manufacturer,
          value: port.manufacturer,
        ),
        CardListTile(
          name: AppLocalizations.of(context)!.productName,
          value: port.productName,
        ),
        CardListTile(
          name: 'Serial Number',
          value: port.serialNumber,
        ),
        CardListTile(
          name: 'MAC Address',
          value: port.macAddress,
        ),
      ],
    );
  }

  void scanPorts() {
    setState(() => availablePorts = SerialPort.availablePorts);
  }
}

class CardListTile extends StatelessWidget {
  final String name;
  final String? value;

  const CardListTile({super.key, required this.name, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
      child: TextField(
        controller: TextEditingController(text: value ?? '-'),
        readOnly: true,
        decoration: InputDecoration(labelText: name, border: InputBorder.none),
      ),
    );
  }
}
