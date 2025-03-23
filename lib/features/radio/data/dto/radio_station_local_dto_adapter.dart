part of 'radio_station_local_dto.dart';

/// Type adapter for [RadioStationLocalDto]
class RadioStationLocalDtoAdapter extends TypeAdapter<RadioStationLocalDto> {
  @override
  final int typeId = 0;

  @override
  RadioStationLocalDto read(BinaryReader reader) {
    return RadioStationLocalDto(
      changeuuid: reader.readString(),
      name: reader.readString(),
      url: reader.readString(),
      homepage: reader.readString(),
      favicon: reader.readString(),
      country: reader.readString(),
      isFavorite: reader.readBool(),
      broken: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, RadioStationLocalDto obj) {
    writer
      ..writeString(obj.changeuuid)
      ..writeString(obj.name)
      ..writeString(obj.url)
      ..writeString(obj.homepage)
      ..writeString(obj.favicon)
      ..writeString(obj.country)
      ..writeBool(obj.isFavorite)
      ..writeBool(obj.broken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadioStationLocalDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
