meta:
  id: bmp_file
  file-extension: bmp
  endian: le

seq:
  - id: bmp_file_header
    type: header
  - id: bmp_info_header
    type: info_header
  - id: bmp_color_table
    type: color_table
    repeat: expr
    repeat-expr: color_table_size
  - id: bmp_pixel_data
    type: u1
    repeat: expr
    repeat-expr: bmp_info_header.image_size

instances:
  color_table_size:
    value: |
      bmp_info_header.bits_per_pixel == 1 ? 1 :
      bmp_info_header.bits_per_pixel == 4 ? 16 :
      bmp_info_header.bits_per_pixel == 8 ? 256 : 0

types:
  header:
    seq:
      - id: signature
        contents: ['BM']
      - id: file_size
        type: u4
      - id: reserved
        type: u4
      - id: data_offset
        type: u4
  
  info_header:
    seq:
      - id: size
        type: u4
      - id: width
        type: u4
      - id: height
        type: u4
      - id: planes
        type: u2
      - id: bits_per_pixel
        type: u2
      - id: compression
        type: u4
        enum: compression_enum
      - id: image_size
        type: u4
      - id: x_pixels_per_m
        type: u4
      - id: y_pixels_per_m  
        type: u4
      - id: colors_used
        type: u4
      - id: imp_colors
        type: u4
    
    enums:
      compression_enum:
        0: bl_rgb
        1: bl_rle8
        2: bl_rle4
  
  color_table:
    seq:
      - id: red
        type: u1
      - id: green
        type: u1
      - id: blue
        type: u1
      - id: reserved
        type: u1