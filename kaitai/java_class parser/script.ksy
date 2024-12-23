meta:
  id: java_class
  file-extension: class
  endian: be

seq:
  - id: magic
    contents: [0xca, 0xfe, 0xba, 0xbe]
  - id: minor_version
    type: u2
  - id: major_version
    type: u2
  - id: constant_pool_count
    type: u2
  - id: constant_pool
    type: cp_info
    repeat: expr
    repeat-expr: constant_pool_count - 1
  - id: access_flags
    type: u2
  - id: this_class
    type: u2
  - id: super_class
    type: u2
  - id: interfaces_count
    type: u2
  - id: interfaces
    type: u2
    repeat: expr
    repeat-expr: interfaces_count
  - id: fields_count
    type: u2
  - id: fields
    type: field_info
    repeat: expr
    repeat-expr: fields_count
  - id: methods_count
    type: u2
  - id: methods
    type: method_info
    repeat: expr
    repeat-expr: methods_count
  - id: attributes_count
    type: u2
  - id: attributes
    type: attribute_info
    repeat: expr
    repeat-expr: attributes_count

types:
  cp_info: 
    seq:
      - id: tag
        type: u1
        enum: tag_enum
      - id: info
        type:
          switch-on: tag
          cases:
            'tag_enum::class_tag': class_info
            'tag_enum::fieldref_tag': fieldref_info
            'tag_enum::methodref_tag': methodref_info
            'tag_enum::interface_methodref': interface_methodref_info
            'tag_enum::string_tag': string_info
            'tag_enum::integer_tag': integer_info
            'tag_enum::float_tag': float_info
            'tag_enum::long_tag': long_info
            'tag_enum::double_tag': double_info
            'tag_enum::name_and_type_tag': name_and_type_info
            'tag_enum::utf8_tag': utf8_info
            'tag_enum::method_handle_tag': method_handle_info
            'tag_enum::method_type': method_type_info
            'tag_enum::invoke_dynamic_tag': invoke_dynamic_info 
    enums:
      tag_enum:
        7: class_tag
        9: fieldref_tag
        10: methodref_tag
        11: interface_methodref
        8: string_tag
        3: integer_tag
        4: float_tag
        5: long_tag
        6: double_tag
        12: name_and_type_tag
        1: utf8_tag
        15: method_handle_tag
        16: method_type
        18: invoke_dynamic_tag
  
  class_info:
    seq:
      - id: name_index
        type: u2
    instances:
      class_info_ele:
        value: _root.constant_pool[name_index - 1]
  
  fieldref_info:
    seq:
      - id: class_index
        type: u2
      - id: name_and_type_index
        type: u2
    instances:
      class_index_info:
        value: _root.constant_pool[class_index - 1]
      name_and_type_index_info:
        value: _root.constant_pool[name_and_type_index - 1]
  
  methodref_info:
    seq:
      - id: class_index
        type: u2
      - id: name_and_type_index
        type: u2
    instances:
      class_index_info:
        value: _root.constant_pool[class_index - 1]
      name_and_type_index_info:
        value: _root.constant_pool[name_and_type_index - 1]
  
  interface_methodref_info:
    seq:
      - id: class_index
        type: u2
      - id: name_and_type_index
        type: u2
    instances:
      class_index_info:
        value: _root.constant_pool[class_index - 1]
      name_and_type_index_info:
        value: _root.constant_pool[name_and_type_index - 1]

  string_info:
    seq:
      - id: string_index
        type: u2
    
    instances:
      string_index_info:
        value: _root.constant_pool[string_index - 1]
  
  integer_info:
    seq:
      - id: val
        type: u4
    
  float_info:
    seq:
      - id: val
        type: u4
  
  long_info:
    seq:
      - id: val
        type: u8
  
  double_info:
    seq:
      - id: val
        type: f8
  
  name_and_type_info:
    seq:
      - id: name_index
        type: u2
      - id: descriptor_index
        type: u2
    
    instances:
      name_index_info:
        value: _root.constant_pool[name_index - 1]
      descriptor_index_info:
        value: _root.constant_pool[descriptor_index - 1]
  
  utf8_info:
    seq:
      - id: utf8_len
        type: u2
      - id: value
        type: str
        size: utf8_len
        encoding: UTF-8
  
  method_handle_info:
    seq:
      - id: reference_kind
        type: u1
        enum: reference_kind_enum
      - id: reference_index
        type: u2
    
    enums:
      reference_kind_enum:
        1: get_field
        2: get_static
        3: put_field
        4: put_static
        5: invoke_virtual
        6: invoke_static
        7: invoke_special
        8: new_invoke_special
        9: invoke_interface

  method_type_info:
    seq:
      - id: descriptor_index
        type: u2
    
    instances:
      descriptor_index_info:
        value: _root.constant_pool[descriptor_index - 1]

  invoke_dynamic_info:
    seq:
      - id: bootstrap_method_attr_index
        type: u2
      - id: name_and_type_index
        type: u2
  
  field_info:
      seq:
        - id: access_flags
          type: u2
          enum: access_enum
        - id: name_index
          type: u2
        - id: descriptor_index
          type: u2
        - id: attribute_count
          type: u2
        - id: attributes
          type: attribute_info
          repeat: expr
          repeat-expr: attribute_count
      
      enums:
          access_enum:
              0x1: public
              0x2: private
              0x4: protected
              0x8: static
              0x10: final
              0x40: volatile
              0x80: transient
              0x1000: synthetic
              0x4000: enum
      
      instances:
          name_index_val:
            value: _root.constant_pool[name_index - 1]
          descriptor_index_val:
            value: _root.constant_pool[descriptor_index - 1]

  attribute_info:
    seq:
        - id: attribute_name_index
          type: u2
        - id: attribute_length
          type: u4
        - id: info
          size: attribute_length
          type:
            switch-on: attribute_name
            cases:
              '"Code"':  code_val
              '"SourceFile"': source_file_val
              '"LineNumberTable"': line_number_val
              '"LocalVariableTable"': local_var_val
    instances:
      attribute_name:
        value: _root.constant_pool[attribute_name_index - 1].info.as<utf8_info>.value

    types:
        code_val:
            seq:
              - id: max_stack
                type: u2
              - id: max_locals
                type: u2
              - id: code_length
                type: u4
              - id: code
                size: code_length
              - id: exception_table_length
                type: u2
              - id: exception_table
                type: exception_element
                repeat: expr
                repeat-expr: exception_table_length
              - id: attribute_count
                type: u2
              - id: attributes
                type: attribute_info
                repeat: expr
                repeat-expr: attribute_count
            
            types:
              exception_element:
                seq:
                  - id: start_pc
                    type: u2
                  - id: end_pc
                    type: u2
                  - id: handler_pc
                    type: u2
                  - id: catch_type
                    type: u2
                
                instances:
                    catch_type_val:
                      value: _root.constant_pool[catch_type - 1]
        
        source_file_val:
            seq:
              - id: source_file_index
                type: u2
            
            instances:
                source_file_val:
                    value: _root.constant_pool[source_file_index - 1]
        
        line_number_val:
            seq:
              - id: line_number_table_length
                type: u2
              - id: line_number_table
                type: line_number_element
                repeat: expr
                repeat-expr: line_number_table_length
            
            types:
              line_number_element:
                seq:
                  - id: start_pc
                    type: u2
                  - id: line_number
                    type: u2
        
        local_var_val:
            seq:
              - id: attribute_name_index
                type: u2
              - id: attribute_length
                type: u4
              - id: local_variable_table_length
                type: u2
              - id: local_variable_table
                type: local_variable_element
                repeat: expr
                repeat-expr: local_variable_table_length
            
            types:
                local_variable_element:
                  seq:
                    - id: start_pc
                      type: u2
                    - id: length
                      type: u2
                    - id: name_index  
                      type: u2
                    - id: descriptor_index
                      type: u2
                    - id: index
                      type: u2
                  
                  instances:
                      name_val:
                        value: _root.constant_pool[name_index - 1]
                      descriptor_val:
                        value: _root.constant_pool[descriptor_index - 1]
            
            instances:
                attribute_name_val:
                  value: _root.constant_pool[attribute_name_index - 1]
    
  method_info:
    seq:
      - id: access_flags
        type: u2
        enum: method_access_enum
      - id: name_index
        type: u2
      - id: descriptor_index
        type: u2
      - id: attributes_count
        type: u2
      - id: attributes
        type: attribute_info
        repeat: expr
        repeat-expr: attributes_count
    enums:
      method_access_enum:
        0x1: public
        0x2: private
        0x4: protected
        0x8: static
        0x10: final
        0x20: synchronized
        0x40: bridge
        0x80: varargs
        0x100: native
        0x400: abstract
        0x800: strict
        0x1000: synthetic
    
    instances:
      name_index_val:
        value: _root.constant_pool[name_index - 1]
      descriptor_val:
        value: _root.constant_pool[descriptor_index - 1]
