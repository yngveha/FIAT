from construct import Struct, Int16ub, Int8ub

format = Struct(
    "preamble" / Int16ub,
    "type" / Int8ub,
    "size" / Int8ub,
    "id" / Int8ub,
    "status" / Int8ub,
    "checksum" / Int8ub
)
