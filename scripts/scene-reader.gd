extends Node

const NU20_INT: int = 808605006

func read_scene(buffer: PackedByteArray):
    var position = 0;

    if buffer.decode_u32(position) == NU20_INT:
        pass