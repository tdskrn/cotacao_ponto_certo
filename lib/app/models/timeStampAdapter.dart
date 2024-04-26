import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TimestampAdapter extends TypeAdapter<Timestamp> {
  @override
  final int typeId = 0; // O ID do tipo Timestamp no Hive

  @override
  Timestamp read(BinaryReader reader) {
    // Lógica para ler um Timestamp do Hive
    int seconds = reader.readInt();
    int nanoseconds = reader.readInt();
    return Timestamp(seconds, nanoseconds);
  }

  @override
  void write(BinaryWriter writer, Timestamp obj) {
    // Lógica para escrever um Timestamp no Hive
    writer.writeInt(obj.seconds);
    writer.writeInt(obj.nanoseconds);
  }
}
